# 03 — Serial-controlled ALU/CPU

**Status:** planned · **Topic:** [12-projects — Capstone projects](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Combine UART, a command parser, a register file and the ALU into a tiny accumulator machine you can drive from a terminal.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `// no equivalent built-in` | `// decode FSM + datapath` |

## Concepts

- Instruction format: opcode, register index, immediate — decode in one cycle, execute in the next.
- A command parser is an FSM over ASCII bytes, with a small buffer for the operand.
- The testbench can drive the same byte stream the terminal would send, so the CPU is testable without hardware.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a conditional branch and implement a loop that computes a sum of 1..N.
2. Add a `HALT` instruction and make the testbench assert on the final register dump.
