# 02 — Inferring hardware

**Status:** planned · **Topic:** [10-synthesis-awareness — Synthesis awareness](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Map familiar constructs to what the tool actually builds: LUTs, carry chains, block RAM, and latches.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(*) case (s)` | `process (all) begin case s is` |

## Concepts

- `case` on a signal infers a mux tree; a wide `and`/`or` reduces to LUTs.
- `+` on unsigned infers a carry chain; a shift by a constant is free wiring.
- An array with synchronous read/write infers block RAM; an asynchronous read infers distributed RAM.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write the same mux with `when/else`, `with/select`, and `case`; compare the three netlists.
2. Change a RAM's read to asynchronous and diff the resource report.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
