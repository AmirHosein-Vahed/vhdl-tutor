#!/usr/bin/env bash
# Scaffold a new lesson from the existing conventions and register it in
# course.toml as "planned".
#
#   scripts/new-lesson.sh 04-state-machines/05-sequence-detector \
#       "Sequence detector" "آشکارساز دنباله"

set -euo pipefail
cd "$(dirname "$0")/.."

target="${1:-}"
title="${2:-New lesson}"
title_fa="${3:-درس جدید}"

if [ -z "$target" ] || [[ "$target" != */* ]]; then
  echo "usage: scripts/new-lesson.sh <topic>/<NN-slug> \"Title\" \"عنوان\""
  echo "example: scripts/new-lesson.sh 04-state-machines/05-sequence-detector \"Sequence detector\" \"آشکارساز دنباله\""
  exit 2
fi

topic="${target%%/*}"
lesson="${target#*/}"
num="${lesson%%-*}"

if [ ! -d "$topic" ]; then
  echo "error: topic folder '$topic' does not exist"
  echo "topics: $(find . -maxdepth 1 -type d -name '[0-9][0-9]-*' -printf '%f ' | sort)"
  exit 2
fi
if [ -d "$topic/$lesson" ]; then
  echo "error: $topic/$lesson already exists"
  exit 1
fi
if ! [[ "$num" =~ ^[0-9]{2}$ ]]; then
  echo "error: lesson folder must start with a two-digit number, got '$lesson'"
  exit 2
fi

dir="$topic/$lesson"
mkdir -p "$dir/src" "$dir/tb"
: >"$dir/src/.gitkeep"
: >"$dir/tb/.gitkeep"
printf '# All build logic lives in common/exercise.mk.\ninclude ../../common/exercise.mk\n' >"$dir/Makefile"

cat >"$dir/README.md" <<EOF
# $num — $title

**Status:** planned
**Topic:** [$topic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in.

## Goal

One sentence: what the learner can do after this lesson.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| \`example\` | \`example\` |

## Concepts

- Concept one.
- Concept two.

## Run

\`\`\`bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
\`\`\`

## Tasks

1. First task.
2. Second task.

## Hints

<details><summary>Show hints</summary>

- Hint one.

</details>
EOF

cat >"$dir/README.fa.md" <<EOF
# $num — $title_fa

**وضعیت:** برنامه‌ریزی‌شده
**موضوع:** [$topic](../README.fa.md) · [English](README.md)

> این درس هنوز نوشته نشده است. هدف، مفاهیم و تمرین‌های زیر قرارداد آن هستند.

## هدف

یک جمله: یادگیرنده پس از این درس چه کاری می‌تواند انجام دهد.

## از وریلاگ به VHDL

| وریلاگ / SystemVerilog | VHDL |
|---|---|
| \`example\` | \`example\` |

## مفاهیم

- مفهوم اول.
- مفهوم دوم.

## اجرا

\`\`\`bash
make        # تحلیل، بسط و اجرای بستر آزمون خودبررسی
make wave   # همان، به‌همراه باز کردن شکل موج
make clean  # پاک کردن build/
\`\`\`

## تمرین‌ها

1. تمرین اول.
2. تمرین دوم.

## راهنما

<details><summary>نمایش راهنماها</summary>

- راهنمای اول.

</details>
EOF

python3 - "$topic" "$lesson" "$title" "$title_fa" <<'PY'
import json, pathlib, sys

topic, lesson, title, title_fa = sys.argv[1:5]
path = pathlib.Path("course.toml")
text = path.read_text(encoding="utf-8")
q = lambda s: json.dumps(s, ensure_ascii=False)

block = (f"\n[[topic.lesson]]\nid = {q(lesson)}\ntitle = {q(title)}\n"
         f"title_fa = {q(title_fa)}\nstatus = \"planned\"\n")

marker = f'[[topic]]\nid = "{topic}"'
start = text.find(marker)
if start < 0:
    sys.exit(f"topic {topic} not found in course.toml")
nxt = text.find("\n[[topic]]", start + len(marker))
if nxt < 0:
    new = text.rstrip("\n") + "\n" + block
else:
    new = text[:nxt].rstrip("\n") + "\n" + block + "\n" + text[nxt:]
path.write_text(new, encoding="utf-8")
print(f"registered {topic}/{lesson} in course.toml")
PY

echo "created $dir"
echo "next: edit $dir/README.md, add src/*.vhd and tb/*_tb.vhd, then: make -C $dir"
echo "when the lesson is written, set status = \"done\" in course.toml"
