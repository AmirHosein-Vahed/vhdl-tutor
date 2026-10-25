# 03 — PSL assertions

**Status:** planned · **Topic:** [11-verification — Verification frameworks](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Write temporal properties next to the RTL — "once requested, acknowledged within 4 cycles" — and let GHDL check them.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assert property (@(posedge clk) req \|-> ##[1:4] ack);` | `-- psl assert always req -> eventually[1 to 4] ack;` |

## Concepts

- PSL lives in VHDL comments, so it is invisible to synthesis and other tools.
- `default clock is rising_edge(clk);` then `assert always req -> eventually! ack;`.
- GHDL needs `-fpsl` at analyze and `--psl-report=...` to collect results.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a PSL assertion to the UART transmitter that a start bit is always followed by a stop bit.
2. Break the RTL on purpose and confirm the assertion, not the testbench, catches it.
