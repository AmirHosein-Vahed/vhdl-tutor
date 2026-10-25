# 01 — Signed vs unsigned gotchas

**Status:** planned · **Topic:** [08-arithmetic-dsp — Arithmetic and DSP](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Reproduce the classic bugs — width truncation, sign extension, mixed-type comparison — and fix each one deliberately.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `$signed(a) >>> 2` | `shift_right(signed(a), 2)  -- arithmetic` |

## Concepts

- `unsigned` and `signed` are different types; `a + b` across them does not compile. That is a feature.
- `resize(sig, n)` sign-extends `signed` and zero-extends `unsigned`; a plain slice does neither.
- Multiplication of two W-bit values needs 2W bits; assigning to W bits silently truncates.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write three failing testbenches for the three bugs, then fix the RTL — not the testbench.
2. Implement a rounded right shift (add half an LSB before shifting) and test at the boundary.
