# 04 — Synchronous FIFO

**Status:** planned · **Topic:** [07-memories — Memories](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build a circular-buffer FIFO with full/empty flags and the pointer-width trick that avoids ambiguity.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `if (wptr - rptr == DEPTH) full = 1;` | `if wptr(wptr'high) /= rptr(rptr'high) and wptr(wptr'high-1 downto 0) = rptr(rptr'high-1 downto 0) then` |

## Concepts

- Keep one extra pointer bit: `full` when the write pointer equals the read pointer with opposite MSBs.
- `empty` is pointer equality; do not use a counter unless you need occupancy.
- Simultaneous read and write at full/empty needs explicit rules; decide them before coding.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Fill the FIFO, overflow it, and assert that `full` stays high and no data is overwritten.
2. Add an `almost_full` output at 75% occupancy and test the threshold.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
