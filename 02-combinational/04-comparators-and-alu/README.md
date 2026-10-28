# 04 — Comparators and a small ALU

**Status:** done · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `alu`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Build a small combinational ALU supporting arithmetic, bitwise logic, and signed comparisons with a zero flag.

## Concepts

- Combining `case` statements with arithmetic and logic operations in a combinational process.
- Generating status flags like `zero` based on internal signal states.

## Files

| File | Purpose |
|---|---|
| `src/alu.vhd` | small combinational ALU and comparator |
| `tb/alu_tb.vhd` | self-checking testbench for ALU operations |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform
make clean  # remove build/
```
