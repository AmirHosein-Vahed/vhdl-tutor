# 02 — VGA pattern generator

**Status:** planned · **Topic:** [12-projects — Capstone projects](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Generate 640×480 @ 60 Hz sync signals and draw a test pattern from a small ROM and a pixel pipeline.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `// no equivalent built-in` | `// counters + compare` |

## Concepts

- Timing is counters: horizontal 0–799, vertical 0–524, with sync pulses at fixed ranges.
- Visible pixels are the region between the back porch and the front porch — everything else is blanking.
- Pixel data must be registered: `rgb` for pixel N appears while the address for N+1 is being fetched.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Draw a checkerboard and a moving bar, then switch patterns with a generic.
2. Add a sprite stored in block RAM and move it with the arrow keys (debounced).
