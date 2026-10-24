# 03 — Looking at the netlist with Yosys

**Status:** planned · **Topic:** [10-synthesis-awareness — Synthesis awareness](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use the open-source Yosys flow with the GHDL plugin to turn VHDL into a netlist and read the cell report.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `quartus_map / vivado synth_design` | `yosys -m ghdl -p '...; synth; stat'` |

## Concepts

- `yosys -m ghdl -p 'ghdl --std=08 file.vhd -e top; synth; stat'` is the whole flow.
- `write_json` plus netlistsvg draws the result; `show` works if Graphviz is installed.
- Yosys' generic `synth` targets gates, not an FPGA — area numbers are indicative, not final.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Synthesize the ALU and the counter; record cell counts per module in a table.
2. Draw the netlist with netlistsvg and identify one mux you predicted in lesson 02.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
