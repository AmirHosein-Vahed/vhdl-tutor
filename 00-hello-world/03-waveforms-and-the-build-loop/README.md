# 03 — Waveforms and the build loop

**Status:** done · **Topic:** [00-hello-world — Hello world](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds the reference design,
> runs its self-checking testbench, and exits non-zero if anything fails.

## Goal

Drive GHDL by hand (analyze, elaborate, run), then through `make`, and read the resulting waveform — including the delta cycles that never appear on a nanosecond axis.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `$dumpfile("x.vcd"); $dumpvars;` | `--wave=x.ghw  (a simulator flag, not VHDL)` |

## Concepts

- `ghdl -a` analyzes, `-e` elaborates, `-r` runs; `--workdir` keeps generated files out of the source tree.
- `--wave=x.ghw` writes a GHW waveform; `--vcd=x.vcd` writes a portable VCD.
- Signals update after a delta cycle, so two assignments in one process do not see each other immediately.

## Files

| File | Purpose |
|---|---|
| `src/swapper.vhd` | two signals swapped in one process — delta-cycle demo |
| `tb/swapper_tb.vhd` | prints values before and after the delta |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## What to observe

In the transcript, `a` and `b` appear to swap only one assignment late. On the waveform they change at the same time stamp. That gap is the delta cycle.

## Tasks

1. Add `--stop-time=100ns` to the run target and explain why the simulation ends even though no `finish` was called.
2. Open the GHW in GTKWave and in Surfer; add both signals and a divider, and save the layout.

## Hints

<details><summary>Show hints</summary>

- `make wave` uses `WAVE_VIEWER`; override it with `make wave WAVE_VIEWER=gtkwave`.
- GHW keeps full type information; VCD flattens everything to bits.

</details>

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
