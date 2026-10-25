# 01 — First entity and testbench

**Status:** done · **Topic:** [00-hello-world — Hello world](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds the reference design,
> runs its self-checking testbench, and exits non-zero if anything fails.

## Goal

Write the smallest complete VHDL design — a 2-input AND gate — plus a self-checking testbench, and run both with GHDL.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `module and2 (input a, b, output y);<br>  assign y = a & b;<br>endmodule` | `entity and2 is<br>  port (a, b : in  std_logic;<br>        y    : out std_logic);<br>end entity;<br><br>architecture rtl of and2 is<br>begin<br>  y <= a and b;<br>end architecture;` |

## Concepts

- An `entity` declares the interface; an `architecture` holds the behaviour.
- A testbench is an entity with no ports that instantiates the design under test (DUT).
- `assert ... report ... severity ...` turns expected values into automated checks.

## Files

| File | Purpose |
|---|---|
| `src/and2.vhd` | the design under test |
| `tb/and2_tb.vhd` | self-checking testbench |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## What to observe

The testbench prints a single `PASS (4 checks)` summary and exits 0. Change the gate to OR without touching the testbench: the summary becomes `FAIL (1 of 4 checks failed)` and `make` exits non-zero.

## Tasks

1. Add a third input `c` and make the output `a and b and c`; update the testbench vectors.
2. Add a vector that drives `'X'` on an input and explain the result (`'X'` is a *simulation* value, not a hardware one).

## Hints

<details><summary>Show hints</summary>

- Compare against `'1'` / `'0'` character literals, not the strings `"1"` and `"0"`.
- Every `std_logic` input must be driven in every vector, or the result is `'U'`.

</details>
