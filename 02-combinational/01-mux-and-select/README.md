# 01 — Multiplexers: when, with, case

**Status:** planned · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build 2:1 and 4:1 muxes in all three styles and know which one to reach for.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |
| `casez (sel)` | `with sel select` |

## Concepts

- `when/else` chains are priority logic; order matters.
- `with ... select` is a parallel case: exactly one branch matches, and it must be exhaustive.
- `case` inside a process is sequential syntax describing combinational hardware.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a `valid` input to a 4:1 mux that forces the output to `'0'` when low.
2. Rewrite a nested `when/else` as `with/select` and check the truth table is unchanged.
