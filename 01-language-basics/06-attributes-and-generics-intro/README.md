# 06 — Attributes and generics

**Status:** planned · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use attributes instead of magic numbers, and generics instead of editing constants before every build.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `parameter WIDTH = 8` | `generic (WIDTH : positive := 8)` |
| `#(.WIDTH(16))` | `generic map (WIDTH => 16)` |

## Concepts

- `clk'event and clk = '1'` is what `rising_edge(clk)` hides; `'stable`, `'image`, `'range` have no Verilog equivalent.
- A generic is a compile-time parameter; a port is a run-time wire. `generic map` is elaboration-time, `port map` connects signals.
- Generics can drive ranges, widths, reset polarity and even whether logic exists (`if G_ENABLE generate`).

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Parameterize the counter's width and reset polarity, then instantiate it at two widths in one testbench.
2. Use `'image` to print an integer in a `report` without `integer'image` gymnastics.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
