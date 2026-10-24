# 04 — Clock domain crossing

**Status:** planned · **Topic:** [09-interfaces — Interfaces and protocols](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Cross a signal between two unrelated clocks — correctly for single bits, and honestly about what needs a FIFO.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `(* ASYNC_REG = "true" *) reg s1, s2;` | `attribute async_reg : string;` |

## Concepts

- Two flops in the destination domain for a single bit; never combinationally combine the two.
- A multi-bit bus cannot be synchronized bit-by-bit — use a handshake, gray code, or an async FIFO.
- `false_path`/CDC constraints are documentation for the timing tool, not a fix.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Send a 1 Hz pulse from a 100 MHz domain to a 33 MHz domain and count received pulses.
2. Build a gray-code counter crossing and show why binary would corrupt.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
