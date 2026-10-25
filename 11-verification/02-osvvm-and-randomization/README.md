# 02 — OSVVM and randomization

**Status:** planned · **Topic:** [11-verification — Verification frameworks](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use OSVVM's random package to hit corner cases your hand-written vectors never did.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `$urandom_range(0, 15)` | `RandInt(0, 15)` |

## Concepts

- `RandomPkg` gives `RandInt`, `RandSlv`, and distributions with seeds you can reproduce.
- A scoreboard stores expected results and compares them asynchronously.
- Functional coverage answers "did I test what I meant to test?", not "did it pass?".

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Randomize ALU operands and opcodes for 10 000 cycles with a fixed seed, then change the seed.
2. Add a simple coverpoint counting how often each opcode was exercised.
