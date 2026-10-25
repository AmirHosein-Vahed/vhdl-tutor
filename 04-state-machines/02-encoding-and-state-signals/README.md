# 02 — State encoding and safe FSMs

**Status:** planned · **Topic:** [04-state-machines — State machines](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Control how states are encoded, add a default transition, and understand what `when others` costs (nothing).

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `(* fsm_encoding = "one_hot" *)` | `attribute enum_encoding : string;` |

## Concepts

- `enum_encoding` attributes are vendor-specific; binary is the default and one-hot is faster on FPGA.
- A default `next_state <= state` assignment makes the FSM recover from an illegal state.
- `when others` on an enumeration is impossible in simulation but essential after synthesis.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Force a one-hot encoding with an attribute and compare the synthesized state register.
2. Remove the default assignment, force an illegal state in simulation, and observe the difference.
