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

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
