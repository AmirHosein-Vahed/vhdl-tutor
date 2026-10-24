# 10-synthesis-awareness — Synthesis awareness

**Status:** 0/3 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Simulation is not hardware. This topic is deliberately short and optional: enough to recognize code that will not synthesize, and to see what your RTL becomes.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `#10 y = a;  // ignored by synthesis` | `y <= a after 10 ns;  -- simulation only` |
| `always @(*) case (s)` | `process (all) begin case s is` |
| `quartus_map / vivado synth_design` | `yosys -m ghdl -p '...; synth; stat'` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [The synthesizable subset](01-synthesizable-subset/README.md) | Sort VHDL constructs into synthesizable, simulation-only, and tool-dependent — and know why each falls where it does. | planned |
| 02 | [Inferring hardware](02-inferring-hardware/README.md) | Map familiar constructs to what the tool actually builds: LUTs, carry chains, block RAM, and latches. | planned |
| 03 | [Looking at the netlist with Yosys](03-yosys-netlist-look/README.md) | Use the open-source Yosys flow with the GHDL plugin to turn VHDL into a netlist and read the cell report. | planned |

## After this topic you can

- Tell synthesizable from simulation-only code
- Predict which construct infers RAM, mux, or a latch
- Read a Yosys `stat` report

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-10-synthesis-awareness
```
