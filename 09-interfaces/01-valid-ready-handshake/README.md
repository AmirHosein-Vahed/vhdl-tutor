# 01 — The valid/ready handshake

**Status:** planned · **Topic:** [09-interfaces — Interfaces and protocols](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Implement the three-state handshake and a skid buffer that can absorb one beat when the receiver stalls.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign ready = !full;` | `ready <= '1' when count < DEPTH else '0';` |

## Concepts

- Transfer happens on a clock edge where `valid and ready` are both high; neither side may retract `valid` early.
- Backpressure: the receiver lowers `ready`; the sender must hold data and valid stable.
- A skid buffer registers the last beat so a purely combinational downstream `ready` cannot stall the upstream pipeline.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Build a 4-deep FIFO with valid/ready on both sides and a randomized stall pattern in the TB.
2. Add an assertion that `valid` cannot go low without a transfer, and make the TB violate it once.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
