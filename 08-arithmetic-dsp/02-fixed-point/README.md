# 02 — Fixed point

**Status:** planned · **Topic:** [08-arithmetic-dsp — Arithmetic and DSP](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Represent a Q1.7 number, multiply two of them, and keep the binary point where you expect it.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `logic signed [15:0] x;  // Q1.15 by convention` | `signal x : sfixed(0 downto -15);` |
| `(a*b) >> 15` | `resize(a * b, sfixed(0 downto -15))` |

## Concepts

- `ieee.fixed_pkg` gives `ufixed`/`sfixed` with an explicit range like `sfixed(0 downto -7)`.
- Multiplying two Q1.7 values gives Q2.14; you must resize back to the range you want.
- Fixed point is just integers with a documented scale — the package only helps you track it.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Build a Q1.15 multiplier and verify 0.5 * 0.5 = 0.25 in the testbench.
2. Compare `fixed_pkg` with a plain integer implementation: same result, fewer surprises?
