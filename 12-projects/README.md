# 12-projects — Capstone projects

**Status:** 0/3 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Three designs that combine everything: a stopwatch, a VGA pattern generator, and a small serial-controlled CPU. No new language features — only integration, which is the actual skill.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `// integration project` | `// integration project` |
| `// no equivalent built-in` | `// counters + compare` |
| `// no equivalent built-in` | `// decode FSM + datapath` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Seven-segment stopwatch](01-seven-segment-stopwatch/README.md) | Build a stopwatch with start/stop/reset buttons, centisecond precision, and a time-multiplexed 4-digit display. | planned |
| 02 | [VGA pattern generator](02-vga-pattern-generator/README.md) | Generate 640×480 @ 60 Hz sync signals and draw a test pattern from a small ROM and a pixel pipeline. | planned |
| 03 | [Serial-controlled ALU/CPU](03-serial-alu-cpu/README.md) | Combine UART, a command parser, a register file and the ALU into a tiny accumulator machine you can drive from a terminal. | planned |

## After this topic you can

- Integrate debouncer, FSM, counters and display in one top level
- Generate video timing and a pixel pipeline
- Design a small instruction set and its datapath

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-12-projects
```
