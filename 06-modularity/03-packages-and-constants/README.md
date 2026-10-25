# 03 — Packages and constants

**Status:** planned · **Topic:** [06-modularity — Modularity](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Stop copying `constant` definitions: put shared types, constants and functions in a package and `use` it everywhere.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| ``include "defs.vh"` | `use work.defs_pkg.all;` |

## Concepts

- A package declaration holds types, constants and subprogram specs; the package body holds implementations.
- Deferred constants (`constant C : integer;`) separate specification from value — set once in the body.
- `use work.pkg.all` is the VHDL equivalent of a header include, but type-checked and order-independent.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Move the ALU opcode type and the UART baud constant into a project package.
2. Add a `log2` function to the package and use it to size counters.
