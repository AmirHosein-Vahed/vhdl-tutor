# 02 — Reset styles

**Status:** planned · **Topic:** [03-sequential — Sequential logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Compare synchronous and asynchronous reset, active-low and active-high, and decide per design instead of copying a template.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk or negedge rst_n)` | `process (clk, rst_n) begin if rst_n = '0' then ... elsif rising_edge(clk) then ...` |

## Concepts

- Asynchronous reset reacts immediately but needs a release synchronizer; synchronous reset costs a mux in the datapath.
- FPGA vendors prefer synchronous or asynchronous-with-sync-release; ASIC flows usually prefer synchronous.
- Initial values (`:= '0'`) simulate but do not guarantee a hardware reset.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Implement both reset styles behind a generic and show the waveform difference at time 0.
2. Add a two-flop reset synchronizer and explain what problem it solves.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
