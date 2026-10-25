# 04 — Comparators and a small ALU

**Status:** planned · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use the comparison operators on numeric types, then assemble a parameterized ALU and test every opcode.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `localparam ADD = 2'b00;` | `type op_t is (OP_ADD, OP_SUB, OP_AND, OP_OR);` |

## Concepts

- Comparisons only exist for compatible types — compare `unsigned` with `unsigned`, never with a vector.
- An ALU is a `case` over an opcode enumeration, with a shared `zero`/`carry` output path.
- An enumerated opcode removes magic numbers from the testbench too.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a `NOT` and a shift op, and make sure unused opcodes produce a defined result.
2. Drive the ALU with every 4-bit opcode in a loop and check no output is `'U'` or `'X'`.
