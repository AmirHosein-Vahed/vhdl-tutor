# 02 — A Verilog module, rewritten in VHDL

**Status:** done · **Topic:** [00-hello-world — Hello world](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds the reference design,
> runs its self-checking testbench, and exits non-zero if anything fails.

## Goal

Translate a module you already understand and use the diff to learn the three things VHDL makes explicit: context clauses, entity/architecture separation, and resolved types.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `parameter W = 8` | `generic (W : positive := 8)` |
| `always @(posedge clk)` | `process (clk) begin if rising_edge(clk) then ...` |

## Concepts

- `library ieee; use ieee.std_logic_1164.all;` is a context clause — VHDL imports nothing implicitly.
- Interface and implementation live in separate declarative regions, so one entity can have several architectures.
- `std_logic` is a resolved 9-value type; `std_logic_vector` is an array of it, and it is *not* a number until you say so.

## Files

| File | Purpose |
|---|---|
| `src/counter.vhd` | the translated module, one entity + one architecture |
| `tb/counter_tb.vhd` | checks reset and three counts |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## What to observe

Compare the number of lines in `src/` with the equivalent Verilog: VHDL spends lines on declarations and buys explicitness. `generic` replaces `parameter`; there is no `reg`/`wire` split — only signals and variables.

## Tasks

1. Add a `generic (MAX : positive := 15)` and make the counter wrap at `MAX` instead of `2**W - 1`.
2. Write a second architecture `behavioural` for the same entity using a variable instead of a signal, and select it in the testbench.

## Hints

<details><summary>Show hints</summary>

- Use `W` and `MAX` through `generic map`, never hard-coded numbers.
- `work.counter` is how you name the entity in the testbench.

</details>

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
