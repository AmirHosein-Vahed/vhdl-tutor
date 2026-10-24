# 03 — Adders and subtractors

**Status:** planned · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build a ripple-carry adder with explicit carry, then get subtraction and overflow right using `unsigned` and `signed`.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `{cout, sum} = a + b;` | `sum : unsigned(W downto 0);  sum <= ('0' & a) + ('0' & b);` |

## Concepts

- `a + b` already produces a carry when the target is one bit wider.
- Subtraction is addition of the two's complement; borrow is the inverted carry-out.
- Signed overflow is not the carry-out — compare operand and result signs.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Extend the adder to a 4-bit ALU op (add, sub, and, or) with a carry flag.
2. Prove the signed overflow flag with 4-bit vectors 7+1 and -8-1.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
