#!/usr/bin/env bash
# Verify that every English document has its Persian counterpart, and that no
# Persian document is orphaned. Convention:
#
#   <dir>/README.md            <-> <dir>/README.fa.md
#   docs/<name>.md             <-> docs/fa/<name>.md
#
# Exit non-zero if anything is missing, so CI catches drift.

set -uo pipefail
cd "$(dirname "$0")/.."

missing=0
orphan=0
pairs=0

is_fa() { case "$1" in */README.fa.md|./docs/fa/*|docs/fa/*) return 0 ;; *) return 1 ;; esac; }

en_file_for_fa() {
  case "$1" in
    */README.fa.md) echo "${1%README.fa.md}README.md" ;;
    ./docs/fa/*) echo "./docs/${1#./docs/fa/}" ;;
    docs/fa/*) echo "docs/${1#docs/fa/}" ;;
  esac
}

while IFS= read -r f; do
  is_fa "$f" && continue
  case "$f" in
    ./README.md) fa="README.fa.md" ;;
    */README.md) fa="${f%README.md}README.fa.md" ;;
    ./docs/*.md) fa="./docs/fa/${f#./docs/}" ;;
    docs/*.md) fa="docs/fa/${f#docs/}" ;;
    *) continue ;;
  esac
  pairs=$((pairs + 1))
  if [ ! -f "$fa" ]; then
    echo "missing translation: $f -> $fa"
    missing=$((missing + 1))
  fi
done < <(find . -name '*.md' -not -path './.git/*' -not -path '*/build/*' | sort)

while IFS= read -r f; do
  is_fa "$f" || continue
  en=$(en_file_for_fa "$f")
  if [ ! -f "$en" ]; then
    echo "orphan translation: $f -> $en does not exist"
    orphan=$((orphan + 1))
  fi
done < <(find . -name 'README.fa.md' -o -path './docs/fa/*.md' | sort)

echo
if [ "$missing" -eq 0 ] && [ "$orphan" -eq 0 ]; then
  echo "i18n ok: $pairs document pairs (en + fa)"
  exit 0
else
  echo "i18n: $missing missing, $orphan orphaned"
  exit 1
fi
