# 01 — Moore, Mealy, and the template

**Status:** planned · **Topic:** [04-state-machines — State machines](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Implement the same protocol as a Moore and as a Mealy machine and see exactly what changes in the waveform.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `localparam IDLE = 2'd0;` | `type state_t is (IDLE, RUN);  signal state : state_t;` |

## Concepts

- Moore output depends on state only; Mealy output depends on state and input, so it reacts one cycle earlier and is glitchier.
- Three-process style: state register, next-state function, output function. Two-process merges the last two.
- An enumeration type (`type state_t is (IDLE, RUN)`) gives readable waveforms and compiler-checked states.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Draw both state diagrams for a `1011` sequence detector and implement one of them.
2. Add a `timeout` input that forces a return to IDLE from every state.
