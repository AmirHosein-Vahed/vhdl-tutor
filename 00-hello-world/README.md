# 00-hello-world — Hello world

**Status:** 3/3 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

The smallest possible loop: write a design, write a testbench that checks it, run it, look at the waveform. Everything later in the course is this loop with more logic in the middle.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `module and2 (input a, b, output y);<br>  assign y = a & b;<br>endmodule` | `entity and2 is<br>  port (a, b : in  std_logic;<br>        y    : out std_logic);<br>end entity;<br><br>architecture rtl of and2 is<br>begin<br>  y <= a and b;<br>end architecture;` |
| `parameter W = 8` | `generic (W : positive := 8)` |
| `always @(posedge clk)` | `process (clk) begin if rising_edge(clk) then ...` |
| `$dumpfile("x.vcd"); $dumpvars;` | `--wave=x.ghw  (a simulator flag, not VHDL)` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [First entity and testbench](01-first-entity-and-testbench/README.md) | Write the smallest complete VHDL design — a 2-input AND gate — plus a self-checking testbench, and run both with GHDL. | done |
| 02 | [A Verilog module, rewritten in VHDL](02-verilog-module-vs-vhdl-entity/README.md) | Translate a module you already understand and use the diff to learn the three things VHDL makes explicit: context clauses, entity/architecture separation, and resolved types. | done |
| 03 | [Waveforms and the build loop](03-waveforms-and-the-build-loop/README.md) | Drive GHDL by hand (analyze, elaborate, run), then through `make`, and read the resulting waveform — including the delta cycles that never appear on a nanosecond axis. | done |

## After this topic you can

- Build and simulate a design with GHDL without any IDE
- Explain the roles of entity, architecture and testbench
- Produce and read a waveform file

## Run everything in this topic

```bash
make test-00-hello-world
```
