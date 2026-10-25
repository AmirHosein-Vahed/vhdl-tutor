# 01 — VUnit basics

**Status:** planned · **Topic:** [11-verification — Verification frameworks](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Convert one hand-written testbench into a VUnit test bench, register two test cases, and run them with `python run.py`.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `// no framework` | `uv run python run.py` |

## Concepts

- VUnit discovers test benches from a `run.py` that lists source files and libraries.
- `test_runner` + `test_case` give one simulation run with multiple named tests.
- `check_equal` replaces hand-rolled asserts and integrates with the VUnit report.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a test case that injects an error and mark it `should_fail`.
2. Add a second top-level (the FIFO) and run both suites with one command.
