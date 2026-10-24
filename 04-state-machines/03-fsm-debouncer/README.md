# 03 — FSM + datapath: debouncer

**Status:** planned · **Topic:** [04-state-machines — State machines](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build a real button debouncer with a counter-based filter and an edge detector — your first FSM that owns a datapath.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) q1 <= q0;` | `process (clk) begin if rising_edge(clk) then q1 <= q0; end if; end process;` |

## Concepts

- Sampling a mechanical input needs a stable-for-N-samples filter, not a delay.
- Edge detection is `q1 <= q0; rise <= q0 and not q1;` — one register and one comparison.
- Separate the filter counter from the FSM state so each is testable alone.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Make the debounce time a generic in milliseconds and derive the count from `CLK_HZ`.
2. Add long-press detection (held for 1 s) as a second output.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
