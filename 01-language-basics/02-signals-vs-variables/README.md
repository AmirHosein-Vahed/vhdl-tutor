# 02 — Signals vs variables

**Status:** planned · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Understand the single biggest semantic difference from Verilog's blocking/non-blocking split: signals are scheduled, variables are immediate.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(*) begin t = a; y = t; end  // blocking` | `process (all) variable t : std_logic; begin t := a; y <= t; end process;` |

## Concepts

- A signal assignment schedules an update at the end of the current delta cycle.
- A variable assignment takes effect on the next line, inside one process invocation.
- Use variables for intermediate combinational values inside a process; use signals for anything that crosses a process boundary.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Rewrite the swapper from topic 00 using variables and explain the different transcript.
2. Build a 3-stage combinational pipeline with signals only; count the delta cycles needed to settle.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
