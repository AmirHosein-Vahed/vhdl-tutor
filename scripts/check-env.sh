#!/usr/bin/env bash
# Check the toolchain used by the course. Optional tools are reported, not
# treated as errors; only a missing or unusable GHDL fails the check.

set -uo pipefail

ok=0
bad=0
opt=0

if [ -t 1 ]; then
  C_GREEN=$'\033[32m'; C_RED=$'\033[31m'; C_YELLOW=$'\033[33m'; C_OFF=$'\033[0m'
else
  C_GREEN=; C_RED=; C_YELLOW=; C_OFF=
fi

pass() { printf '  %sok%s     %-12s %s\n' "$C_GREEN" "$C_OFF" "$1" "$2"; ok=$((ok + 1)); }
fail() { printf '  %sMISSING%s %-11s %s\n' "$C_RED" "$C_OFF" "$1" "$2"; bad=$((bad + 1)); }
skip() { printf '  %s--%s     %-12s %s\n' "$C_YELLOW" "$C_OFF" "$1" "$2"; opt=$((opt + 1)); }

echo "vhdl-tutor environment"
echo

if command -v ghdl >/dev/null 2>&1; then
  version=$(ghdl --version | head -1)
  pass ghdl "$version"
  tmp=$(mktemp -d)
  cat >"$tmp/probe.vhd" <<'VHD'
library ieee;
use ieee.std_logic_1164.all;
entity probe is end entity;
architecture a of probe is begin
  process begin report "ok" severity note; std.env.finish; end process;
end architecture;
VHD
  if (cd "$tmp" && ghdl -a --std=08 probe.vhd >/dev/null 2>&1 \
      && ghdl -e --std=08 probe >/dev/null 2>&1 \
      && ghdl -r --std=08 probe >/dev/null 2>&1); then
    pass "vhdl-2008" "analysis, elaboration and run all work"
  else
    fail "vhdl-2008" "GHDL is present but cannot build VHDL-2008; upgrade GHDL"
  fi
  rm -rf "$tmp"
else
  fail ghdl "not found — run scripts/install-tools.sh or 'make install-tools'"
fi

if command -v make >/dev/null 2>&1; then
  pass make "$(make --version | head -1)"
else
  fail make "not found — install build-essential"
fi

if command -v python3 >/dev/null 2>&1; then
  pass python3 "$(python3 --version)"
else
  fail python3 "not found — needed by scripts/curriculum.py (3.11+)"
fi

if command -v surfer >/dev/null 2>&1; then
  pass surfer "$(surfer --version 2>/dev/null | head -1)"
elif command -v gtkwave >/dev/null 2>&1; then
  pass gtkwave "$(gtkwave --version 2>&1 | head -1)"
else
  skip viewer "no surfer/gtkwave — waveforms are still written, just not opened"
fi

if command -v yosys >/dev/null 2>&1; then
  pass yosys "$(yosys -V | head -1)"
  if yosys -m ghdl -p 'help' >/dev/null 2>&1; then
    pass "ghdl-yosys" "plugin loads"
  else
    skip "ghdl-yosys" "plugin not installed (only needed for topic 10)"
  fi
else
  skip yosys "not installed (only needed for topic 10)"
fi

if command -v vhdl_ls >/dev/null 2>&1; then
  pass vhdl_ls "$(vhdl_ls --version 2>&1 | head -1)"
else
  skip vhdl_ls "not installed (editor completion, optional)"
fi

echo
echo "$ok required tools ready, $bad missing, $opt optional not installed"
exit $(( bad > 0 ? 1 : 0 ))
