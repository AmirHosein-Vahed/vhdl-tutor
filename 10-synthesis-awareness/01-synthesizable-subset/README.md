# 01 — The synthesizable subset

**Status:** planned · **Topic:** [10-synthesis-awareness — Synthesis awareness](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Sort VHDL constructs into synthesizable, simulation-only, and tool-dependent — and know why each falls where it does.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `#10 y = a;  // ignored by synthesis` | `y <= a after 10 ns;  -- simulation only` |

## Concepts

- Simulation-only: `after` delays, `textio`, `wait for`, `report`, unconstrained file I/O.
- Tool-dependent: initial values, records on ports, `real`, division by non-constant.
- `wait until rising_edge(clk)` is simulation-only at the top level; inside a process it is a clock.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Take a simulation-only testbench and try to synthesize it; read the first three errors.
2. Rewrite a `real`-based calculation using integers and fixed point.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
