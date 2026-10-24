# 02 — Decoders and priority encoders

**Status:** planned · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Write a one-hot decoder and a priority encoder, then a 7-segment decoder you can reuse in the capstone.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `casez (sel)` | `case? sel is` |

## Concepts

- A decoder is a `case`/indexed assignment from a small type to one-hot bits.
- A priority encoder is an `if/elsif` chain — order encodes priority, and `'Z'`/`'X'` handling must be explicit.
- `case?` (VHDL-2008 matching case) treats `'-'` as don't-care, similar to `casez`.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Make the 7-segment decoder display `A`–`F` for inputs 10–15 and a blank for an invalid digit.
2. Add an enable to the decoder and explain why gating the outputs is better than gating the input.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
