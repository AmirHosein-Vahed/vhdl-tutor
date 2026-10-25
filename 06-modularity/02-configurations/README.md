# 02 — Configurations

**Status:** planned · **Topic:** [06-modularity — Modularity](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use a configuration declaration to bind entities to architectures once, instead of editing every instantiation.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| ``ifdef SIM / `else` | `configuration sim_cfg of top is ...` |

## Concepts

- `configuration cfg of top is for rtl ... end for;` binds a whole hierarchy.
- Configurations let one netlist have simulation and synthesis variants.
- Most tools support them, but few teams use them — know they exist and why.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Create two architectures (rtl, behavioural) and two configurations; run both from one testbench.
2. Explain in one paragraph when a configuration is better than a generic.
