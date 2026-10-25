# 03 — Pipelining and registered math

**Status:** planned · **Topic:** [08-arithmetic-dsp — Arithmetic and DSP](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Turn a multi-level combinational datapath into a pipelined one with a valid chain, and measure the latency.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) begin v1 <= v; d1 <= d; end` | `process (clk) begin if rising_edge(clk) then v1 <= v; d1 <= d; end if; end process;` |

## Concepts

- Each pipeline stage is a register; the `valid` bit must be delayed in lockstep with the data.
- Latency grows, throughput stays one result per clock — that is the trade.
- `for generate` with a shift-register scoreboard keeps the testbench aligned.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a 4-stage pipeline to the ALU and prove the output matches the unpipelined reference after N cycles.
2. Insert a bubble (valid = 0) and verify it propagates correctly.
