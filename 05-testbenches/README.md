# 05-testbenches — Testbenches

**Status:** 0/5 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

A testbench is where VHDL beats Verilog for verification. This topic turns hand-waved stimulus into repeatable, self-checking, timeout-protected tests — the foundation for everything in topic 11.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always #5 clk = ~clk;` | `clk <= not clk after 5 ns;` |
| `if (y !== e) $error("...");` | `assert y = e report "..." severity warning;` |
| `$readmemh("vec.hex", mem);` | `readline(f, l);  read(l, v);` |
| `#1000 $finish;` | `wait for 1 us;  std.env.finish;` |
| `task automatic drive(input logic [7:0] d);` | `procedure drive(signal d : out std_logic_vector);` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Clock, reset, stimulus](01-clock-reset-stimulus/README.md) | Build the three processes every testbench needs: clock, reset, stimulus — and keep them independent. | planned |
| 02 | [Self-checking testbenches](02-self-checking-with-asserts/README.md) | Replace print-and-squint with `assert`: count failures, print one summary, and exit non-zero on failure. | planned |
| 03 | [File I/O and TB generics](03-file-io-and-tb-generics/README.md) | Load vectors from a text file with `textio`, and make one testbench serve every configuration of the DUT. | planned |
| 04 | [wait forms and timeouts](04-wait-forms-and-timeouts/README.md) | Use all four `wait` forms correctly and add a watchdog so a broken DUT fails in seconds instead of hanging CI. | planned |
| 05 | [Reusable testbench helpers](05-tb-helper-procedures/README.md) | Move repeated stimulus and checking into a package (`tb_utils`), so testbenches read like test plans. | planned |

## After this topic you can

- Write a testbench you can trust without watching the waveform
- Drive and check DUTs from files and generics
- Stop a hung simulation deterministically

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-05-testbenches
```
