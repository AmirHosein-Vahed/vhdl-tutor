# 01 — Multiplexers: when, with, case

**Status:** done · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `mux_advanced`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Build 2:1 and 4:1 muxes with enable control in all three styles (`when/else`, `with/select`, and process `case`) and know which one to reach for.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |
| `casez (sel)` | `with sel select` |

## Concepts

- `when/else` chains are priority logic; order matters.
- `with ... select` is a parallel case: exactly one branch matches, and it must be exhaustive.
- `case` inside a process is sequential syntax describing combinational hardware.

## Files

| File | Purpose |
|---|---|
| `src/mux_advanced.vhd` | 4:1 mux with enable control in 3 styles |
| `tb/mux_advanced_tb.vhd` | self-checking testbench covering all inputs and disable states |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a `valid` input to a 4:1 mux that forces the output to `'0'` when low.
2. Rewrite a nested `when/else` as `with/select` and check the truth table is unchanged.
