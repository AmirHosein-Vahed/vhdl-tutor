# 03 — Simple dual-port RAM

**Status:** planned · **Topic:** [07-memories — Memories](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Add a second port for simultaneous read and write, and handle the collision case explicitly.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) begin mem[wa] <= wd; rd <= mem[ra]; end` | `process (clk) begin if rising_edge(clk) then mem(wa) <= wd; rd <= mem(ra); end if; end process;` |

## Concepts

- Simple dual-port = one write port, one read port; true dual-port = two of each.
- A collision (same address, same cycle) has tool-dependent behaviour; define it in your code.
- Dual-port RAM is how you build a frame buffer or a FIFO with independent clocks.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write port A and read port B at different rates and prove no data is lost.
2. Add a `write-through` output so a read of the written address returns the new value.
