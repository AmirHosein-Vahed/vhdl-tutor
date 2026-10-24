# 04 — std_logic_vector and numeric_std

**Status:** planned · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Do arithmetic without `std_logic_arith`. Learn the conversions, the width rules, and why mixing libraries is a bug factory.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `a + b  // width = max(len(a), len(b))` | `unsigned(a) + unsigned(b)  -- result width = max` |
| `$signed(a)` | `signed(a)` |

## Concepts

- `std_logic_vector` is a bag of bits; `unsigned`/`signed` are numeric. Convert explicitly with `unsigned()`, `signed()`, `std_logic_vector()`.
- Addition returns the wider operand type; assign to a wider target and `resize` deliberately.
- Never use `ieee.std_logic_arith`/`std_logic_unsigned` — use `ieee.numeric_std` only.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add two 8-bit unsigned values into a 9-bit result and prove the carry is preserved.
2. Build a saturating add: on overflow return 255 instead of wrapping.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
