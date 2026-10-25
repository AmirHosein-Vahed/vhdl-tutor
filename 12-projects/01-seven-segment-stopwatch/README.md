# 01 — Seven-segment stopwatch

**Status:** planned · **Topic:** [12-projects — Capstone projects](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build a stopwatch with start/stop/reset buttons, centisecond precision, and a time-multiplexed 4-digit display.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `// integration project` | `// integration project` |

## Concepts

- Cascade BCD counters: centiseconds, seconds, minutes; each carries into the next.
- Time multiplexing drives one digit at a time fast enough (>60 Hz) to look continuous.
- Every button goes through the debouncer and edge detector from topic 04.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a lap-time register that captures the current count on a fourth button.
2. Make the display blank leading zeros and test the 59.99 → 00.00 rollover.
