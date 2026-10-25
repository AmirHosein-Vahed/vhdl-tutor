# 03 — Registers and clock enables

**Status:** planned · **Topic:** [03-sequential — Sequential logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build a register file and learn why an enable is an `if`, never a gated clock.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) if (we) mem[addr] <= d;` | `process (clk) begin if rising_edge(clk) then if we = '1' then mem(addr) <= d; end if; end if; end process;` |

## Concepts

- Clock gating in RTL creates clock-domain and timing problems; use a clock enable instead.
- A register file is an array of `std_logic_vector` with synchronous write and asynchronous read.
- Read-during-write behaviour of an array in simulation must be made explicit.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Make the register file dual-write and prove two writes in the same cycle resolve deterministically.
2. Add a `bypass` path so a read of the just-written address returns the new data.
