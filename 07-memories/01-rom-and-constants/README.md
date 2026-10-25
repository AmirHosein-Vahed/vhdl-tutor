# 01 — ROM and initialized constants

**Status:** planned · **Topic:** [07-memories — Memories](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Initialize a ROM from a function or a file, and understand why a ROM must not have a reset.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `initial $readmemh(...)` | `constant ROM : rom_t := (...);  -- elaboration time` |

## Concepts

- `type rom_t is array (0 to N-1) of std_logic_vector(7 downto 0); constant ROM : rom_t := (...)`.
- A function can generate coefficients (sine, log) at elaboration time.
- Resetting a ROM is a mistake: it turns block RAM into logic and destroys the initial contents.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Generate a 256-entry sine table with a function and check three values in a testbench.
2. Load the same table from a text file with `textio` and compare the two ROMs.
