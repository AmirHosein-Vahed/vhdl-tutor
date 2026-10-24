# 11-verification — Verification frameworks

**Status:** 0/3 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Optional but career-changing: VUnit, OSVVM and cocotb turn hand-written testbenches into a regression suite. This topic shows the shape of each, not a full course.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `// no framework` | `uv run python run.py` |
| `$urandom_range(0, 15)` | `RandInt(0, 15)` |
| `assert property (@(posedge clk) req \|-> ##[1:4] ack);` | `-- psl assert always req -> eventually[1 to 4] ack;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [VUnit basics](01-vunit-basics/README.md) | Convert one hand-written testbench into a VUnit test bench, register two test cases, and run them with `python run.py`. | planned |
| 02 | [OSVVM and randomization](02-osvvm-and-randomization/README.md) | Use OSVVM's random package to hit corner cases your hand-written vectors never did. | planned |
| 03 | [PSL assertions](03-psl-assertions/README.md) | Write temporal properties next to the RTL — "once requested, acknowledged within 4 cycles" — and let GHDL check them. | planned |

## After this topic you can

- Run a VUnit test suite from the command line
- Use constrained randomization and a scoreboard concept
- Write a PSL property checked by GHDL

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-11-verification
```
