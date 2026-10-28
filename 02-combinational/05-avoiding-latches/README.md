# 05 — Avoiding latches

**Status:** done · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `latch_avoid`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Understand how incomplete assignments in combinational processes infer unintended latches, and learn the idiomatic VHDL fix.

## Concepts

- In VHDL, any signal assigned inside a process must be assigned on *every* possible execution path. Otherwise, the synthesizer infers a latch to remember the previous state.
- Rule: Always assign a default value to outputs at the very beginning of a combinational process.

## Files

| File | Purpose |
|---|---|
| `src/latch_avoid.vhd` | combinational process with default assignment preventing latches |
| `tb/latch_avoid_tb.vhd` | self-checking testbench verifying output behavior |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform
make clean  # remove build/
```
