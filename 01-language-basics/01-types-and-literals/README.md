# 01 — Types and literals

**Status:** planned · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Stop treating `std_logic` as `logic`. Learn the 9 values, the numeric types, and every literal form you will meet.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `logic [7:0] x;` | `signal x : std_logic_vector(7 downto 0);` |
| `4'b1010` | `"1010"  (or 10, or x"A")` |

## Concepts

- `std_logic` has 9 values (`'U' 'X' '0' '1' 'Z' 'W' 'L' 'H' '-'`); only `'0'`/`'1'` are hardware.
- `integer` is 32-bit by default; `natural`/`positive` are constrained subtypes and catch bugs at elaboration.
- Literals: `16#FF#`, `x"FF"`, `"1010"`, `2#1010#`, `1_000_000`, `1 ns`.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write a constant of each literal form that equals 255 and check them in a testbench.
2. Declare an `integer range 0 to 7` and try assigning 8; note when the error is raised.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
