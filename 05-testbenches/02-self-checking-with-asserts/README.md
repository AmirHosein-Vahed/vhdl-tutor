# 02 — Self-checking testbenches

**Status:** planned · **Topic:** [05-testbenches — Testbenches](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Replace print-and-squint with `assert`: count failures, print one summary, and exit non-zero on failure.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `if (y !== e) $error("...");` | `assert y = e report "..." severity warning;` |

## Concepts

- `assert condition report message severity level` is the only test primitive you need.
- Use `severity warning` for individual failures so the run continues, `severity failure` for the summary.
- `std.env.finish` gives a clean exit; `finish(1)` gives a non-zero exit for CI.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a `verbose` generic that prints every vector when true and only the summary when false.
2. Make the TB count checks and report `N checks, M failures` at the end.
