# 03 — downto vs to, and indexing

**Status:** planned · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Get array ranges right the first time, and stop guessing which bit is the MSB.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `[7:0] v;  // fixed direction` | `signal v : std_logic_vector(7 downto 0);` |
| `v[3:0]` | `v(3 downto 0)` |

## Concepts

- `(7 downto 0)` means index 7 is MSB; `(0 to 7)` means index 0 is MSB. Direction is part of the type.
- Slices must match direction: `v(7 downto 4)`, never `v(4 to 7)` on a downto vector.
- Attributes `'left 'right 'high 'low 'length 'range` describe a range without hard-coding it.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write a function that reverses any `std_logic_vector` using `'range` and `'reverse_range`.
2. Deliberately index a downto vector with `to` and explain the compiler error.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
