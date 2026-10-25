# 04 — Saturation and a FIR filter

**Status:** planned · **Topic:** [08-arithmetic-dsp — Arithmetic and DSP](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Implement saturating arithmetic and use it in a small FIR filter built from shift registers and constants.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `y = (sum > MAX) ? MAX : sum;` | `if sum > MAX then y <= MAX; else y <= sum; end if;` |

## Concepts

- Saturation clamps to min/max instead of wrapping; detect overflow before assigning.
- A FIR is a chain of registered samples, each multiplied by a constant and summed.
- Constants let synthesis replace multipliers with shifts/adds — big area savings.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Implement a 5-tap moving average with integer coefficients and compare it with the floating-point reference.
2. Swap one coefficient for a power of two and check the multiplier disappears from the netlist.
