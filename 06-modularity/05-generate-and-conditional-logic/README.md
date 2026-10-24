# 05 — Generate and conditional logic

**Status:** planned · **Topic:** [06-modularity — Modularity](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use `for generate` and `if generate` to build parameterized structure, and understand that they elaborate, not execute.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `generate for (genvar i=0; i<N; i++)` | `gen : for i in 0 to N-1 generate` |
| `if (WIDTH > 8) begin ... end` | `gen_if : if WIDTH > 8 generate` |

## Concepts

- `gen : for i in 0 to N-1 generate` replicates hardware; the loop variable is a constant.
- `if generate` includes or excludes hardware at elaboration — unlike an `if` statement, which is a mux.
- Generate labels are optional in VHDL-2008, required in older standards; use them anyway.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Build an N-bit ripple-carry adder from N full adders with `for generate`.
2. Add an optional pipeline register with `if generate` and measure the changed latency.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
