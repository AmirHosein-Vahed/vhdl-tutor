# 02 — Decoders and priority encoders

**Status:** done · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `decoder_encoder`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Build binary decoders and priority encoders using selected signal assignments and sequential loops.

## Concepts

- Binary decoders convert a binary index to a one-hot vector using `with/select`.
- Priority encoders find the highest-index active bit using a descending loop inside a combinational process.

## Files

| File | Purpose |
|---|---|
| `src/decoder_encoder.vhd` | 3-to-8 binary decoder and 8-to-3 priority encoder |
| `tb/decoder_encoder_tb.vhd` | self-checking testbench for decoder and priority encoder |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform
make clean  # remove build/
```
