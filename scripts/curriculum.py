#!/usr/bin/env python3
"""Course inventory, consistency checks and test runner.

course.toml is the single source of truth: this script reads it for
`make list`, `make test`, `make test-all`, `make check-lessons` and
`make run`. A lesson is considered testable by its files, not by its
status: `tb/*_tb.vhd` is what puts it in the CI run.
"""
from __future__ import annotations

import argparse
import json
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


def vhdl_files(path: pathlib.Path, sub: str, pattern: str = "*.vhd") -> list[pathlib.Path]:
    """Return VHDL files in path/sub. .gitkeep and other placeholders are ignored."""
    directory = path / sub
    return sorted(directory.glob(pattern)) if directory.is_dir() else []


def is_testable(path: pathlib.Path) -> bool:
    """A lesson runs in CI when it has a testbench top, not just placeholder files."""
    return bool(vhdl_files(path, "tb", "*_tb.vhd"))


def cmd_check(args) -> int:
    """Verify that course.toml, the folders and the actual code agree."""
    _, topics = load()
    errors: list[str] = []
    warnings: list[str] = []
    coded = stubs = 0

    for topic in topics:
        for lesson in topic["lesson"]:
            label = f"{topic['id']}/{lesson['id']}"
            path = lesson_dir(topic, lesson)
            status = lesson["status"]

            if not path.is_dir():
                errors.append(f"{label}: lesson folder is missing")
                continue

            src = vhdl_files(path, "src")
            tb_any = vhdl_files(path, "tb")
            tb_top = vhdl_files(path, "tb", "*_tb.vhd")

            if status == "done":
                if not src:
                    errors.append(f"{label}: status is done but src/ has no .vhd file")
                if not tb_top:
                    errors.append(f"{label}: status is done but tb/ has no *_tb.vhd")
            elif status == "draft" and not (src or tb_any):
                errors.append(f"{label}: status is draft but no VHDL files exist")
            elif status != "done" and src and not tb_top:
                errors.append(f"{label}: source exists but there is no tb/*_tb.vhd")

            if tb_any and not src:
                warnings.append(f"{label}: tb/ has files but src/ has no .vhd")
            if status == "planned" and (src or tb_any):
                warnings.append(
                    f"{label}: status is planned but code exists; mark it draft or done")

            if src and tb_top:
                coded += 1
                if args.verbose:
                    print(f"  code   {label}  ({len(src)} src, {len(tb_top)} tb)")
            elif not src and not tb_any:
                stubs += 1
                if args.verbose:
                    print(f"  stub   {label}")

    registered = {
        lesson_dir(topic, lesson).resolve()
        for topic in topics for lesson in topic["lesson"]
    }
    for topic_path in sorted(ROOT.iterdir()):
        if not topic_path.is_dir() or not topic_path.name[:2].isdigit():
            continue
        for path in sorted(topic_path.iterdir()):
            if not path.is_dir() or not path.name[:2].isdigit():
                continue
            if not (path / "src").is_dir() and not (path / "tb").is_dir():
                continue
            if path.resolve() not in registered:
                errors.append(
                    f"{path.relative_to(ROOT)}: folder with src/ or tb/ is not in course.toml")

    print(f"{coded} lessons with source + testbench, {stubs} stubs")
    for warning in warnings:
        print(f"warning: {warning}")
    for error in errors:
        print(f"error: {error}")
    if errors:
        print(f"\n{len(errors)} problem(s): every coded lesson must be registered and testable")
        return 1
    return 0


def cmd_coded(args) -> int:
    """List lessons that have both a source file and a testbench top."""
    _, topics = load()
    for topic in topics:
        for lesson in topic["lesson"]:
            path = lesson_dir(topic, lesson)
            if vhdl_files(path, "src") and is_testable(path):
                print(f"{topic['id']}/{lesson['id']}")
    return 0


def cmd_matrix(args) -> int:
    """Print a GitHub Actions matrix of everything that can be simulated."""
    _, topics = load()
    include = []
    if args.by == "lesson":
        for topic in topics:
            for lesson in topic["lesson"]:
                path = lesson_dir(topic, lesson)
                if is_testable(path):
                    label = f"{topic['id']}/{lesson['id']}"
                    include.append({"lesson": label, "path": label})
    else:
        for topic in topics:
            count = sum(1 for lesson in topic["lesson"]
                        if is_testable(lesson_dir(topic, lesson)))
            if count:
                include.append({"topic": topic["id"], "lessons": count})
    print(json.dumps({"include": include}, separators=(",", ":")))
    return 0


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
          f"`make test` runs done/draft lessons; `make test-all` runs every lesson with code.")
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

    p_check = sub.add_parser("check", help="check course.toml against the lesson folders")
    p_check.add_argument("-v", "--verbose", action="store_true",
                         help="show every coded lesson and stub")
    p_check.set_defaults(func=cmd_check)

    p_coded = sub.add_parser("coded", help="list lessons with a source file and testbench")
    p_coded.set_defaults(func=cmd_coded)

    p_matrix = sub.add_parser("matrix", help="print a GitHub Actions matrix as JSON")
    p_matrix.add_argument("--by", choices=("topic", "lesson"), default="topic",
                          help="group the matrix by topic or by lesson (default: topic)")
    p_matrix.set_defaults(func=cmd_matrix)

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
