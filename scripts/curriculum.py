#!/usr/bin/env python3
"""Course inventory and test runner.

course.toml is the single source of truth: this script reads it for
`make list`, `make test` and `make run`.
"""
from __future__ import annotations

import argparse
import pathlib
import subprocess
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent
COURSE = ROOT / "course.toml"
STATUS_ORDER = {"done": 0, "draft": 1, "planned": 2}
STATUS_MARK = {"done": "ok", "draft": "draft", "planned": "planned"}


def load():
    with COURSE.open("rb") as fh:
        data = tomllib.load(fh)
    topics = []
    for topic in data.get("topic", []):
        topic.setdefault("lesson", [])
        topics.append(topic)
    return data.get("course", {}), topics


def lesson_dir(topic, lesson) -> pathlib.Path:
    return ROOT / topic["id"] / lesson["id"]


def cmd_list(args) -> int:
    course, topics = load()
    std = course.get("standard", "08")
    std = f"20{std}" if len(std) == 2 else std
    print(f"{course.get('name', 'course')} — VHDL-{std}, "
          f"docs in {course.get('language', 'en')} + {course.get('second_language', '?')}")
    print()
    total = written = 0
    for topic in topics:
        lessons = topic["lesson"]
        done = sum(1 for l in lessons if l["status"] == "done")
        total += len(lessons)
        written += done
        print(f"{topic['id']:<28} {done}/{len(lessons)} done  {topic['title']}")
        if args.verbose:
            for lesson in lessons:
                mark = STATUS_MARK.get(lesson["status"], "?")
                print(f"  {lesson['id']:<36} {mark:<8} {lesson['title']}")
    print()
    print(f"{written}/{total} lessons written. "
          f"`make test` runs the written ones; `make test-all` runs everything.")
    return 0


def cmd_test(args) -> int:
    _, topics = load()
    wanted = None if args.status == "all" else {
        s.strip() for s in args.status.split(",") if s.strip()}

    selected = []
    for topic in topics:
        if args.topic and topic["id"] != args.topic:
            continue
        for lesson in topic["lesson"]:
            if wanted is not None and lesson["status"] not in wanted:
                continue
            selected.append((topic, lesson))

    if not selected:
        print(f"nothing to run for --status {args.status}"
              + (f" --topic {args.topic}" if args.topic else ""))
        return 0

    passed, failed, skipped = [], [], []
    for topic, lesson in selected:
        path = lesson_dir(topic, lesson)
        if not any((path / "src").glob("*.vhd")) and not any((path / "tb").glob("*.vhd")):
            skipped.append((topic, lesson))
            continue
        label = f"{topic['id']}/{lesson['id']}"
        proc = subprocess.run(
            ["make", "--no-print-directory", "-C", str(path), "sim"],
            capture_output=True, text=True)
        if proc.returncode == 0:
            passed.append(label)
            line = next((l for l in proc.stdout.splitlines() if "PASS (" in l), "")
            print(f"  ok    {label}  {line.split(':')[-1].strip()}")
        else:
            failed.append((label, proc.stdout + proc.stderr))
            print(f"  FAIL  {label}")
            if args.verbose:
                print(indent(proc.stdout + proc.stderr))

    print()
    print(f"{len(passed)} passed, {len(failed)} failed, {len(skipped)} not written yet")
    if failed:
        print()
        for label, output in failed:
            print(f"--- {label} ---")
            print(indent(output))
        return 1
    return 0


def indent(text: str, prefix: str = "    ") -> str:
    return "\n".join(prefix + line for line in text.rstrip().splitlines())


def find_lesson(path_arg: str):
    _, topics = load()
    matches = []
    for topic in topics:
        for lesson in topic["lesson"]:
            full = f"{topic['id']}/{lesson['id']}"
            if path_arg in (full, lesson["id"]):
                matches.append((topic, lesson))
    if len(matches) > 1:
        print(f"ambiguous lesson '{path_arg}'; use the full topic/lesson path:")
        for topic, lesson in matches:
            print(f"  {topic['id']}/{lesson['id']}")
        return None, None
    if not matches:
        return None, None
    return matches[0]


def cmd_run(args) -> int:
    topic, lesson = find_lesson(args.lesson.rstrip("/"))
    if lesson is None:
        print(f"unknown lesson: {args.lesson}")
        print("use `make list -v` to see the lesson ids")
        return 2
    path = lesson_dir(topic, lesson)
    make_args = ["make", "--no-print-directory", "-C", str(path),
                 "wave" if args.wave else "sim"]
    if args.run_args:
        make_args.append(f"RUN_ARGS={args.run_args}")
    return subprocess.call(make_args)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_list = sub.add_parser("list", help="print the course inventory")
    p_list.add_argument("-v", "--verbose", action="store_true",
                        help="show every lesson and its status")
    p_list.set_defaults(func=cmd_list)

    p_test = sub.add_parser("test", help="run the self-checking testbenches")
    p_test.add_argument("--status", default="done,draft",
                        help="comma list of statuses, or 'all' (default: done,draft)")
    p_test.add_argument("--topic", help="limit to one topic, e.g. 03-sequential")
    p_test.add_argument("-v", "--verbose", action="store_true",
                        help="show simulator output for failures")
    p_test.set_defaults(func=cmd_test)

    p_run = sub.add_parser("run", help="run one lesson")
    p_run.add_argument("--lesson", required=True,
                       help="topic/lesson path, e.g. 03-sequential/01-first-clocked-process")
    p_run.add_argument("--wave", action="store_true", help="open the waveform viewer")
    p_run.add_argument("--run-args", default="", help="extra arguments for GHDL")
    p_run.set_defaults(func=cmd_run)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
