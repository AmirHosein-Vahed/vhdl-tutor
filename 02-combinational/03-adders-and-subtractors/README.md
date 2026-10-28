# 03 — Adders and subtractors

**Status:** done · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `adder_subtractor`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Build combinational adders and subtractors with carry-out and signed overflow detection using `numeric_std`.

## Concepts

- `unsigned` and `signed` types from `ieee.numeric_std` enable arithmetic operators (`+`, `-`).
- Carry-out (`cout`) is captured by extending the vector width during addition/subtraction.
- Signed overflow occurs when two operands of the same sign yield a result of the opposite sign.

## Files

| File | Purpose |
|---|---|
| `src/adder_subtractor.vhd` | 8-bit adder/subtractor with cout and signed overflow |
| `tb/adder_subtractor_tb.vhd` | self-checking testbench verifying arithmetic and flags |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform
make clean  # remove build/
```
