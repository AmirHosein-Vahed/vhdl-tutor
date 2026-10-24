# 04 — Counters

**Status:** planned · **Topic:** [03-sequential — Sequential logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Write up/down/load counters with terminal count, and choose between `integer range` and `unsigned` on purpose.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `counter <= counter + 1;` | `count <= count + 1;  -- unsigned` |
| `if (count == N-1)` | `if count = N - 1 then` |

## Concepts

- `integer range 0 to N-1` gives free bounds checking in simulation; `unsigned` gives free arithmetic and wrapping.
- Terminal count is a comparison against a constant, not a decode of all bits.
- Modulo-N counting is a wraparound assignment, not a divider.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a prescaler so the counter ticks once per millisecond from a 50 MHz clock.
2. Build a BCD counter (0–9) and cascade two of them into a 00–99 counter.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
