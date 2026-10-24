# 02-combinational — Combinational logic

**Status:** 0/5 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Pure logic with no clock: the place where VHDL's strictness either saves you or gets in your way. Every example is small enough to check exhaustively.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |
| `casez (sel)` | `with sel select` |
| `casez (sel)` | `case? sel is` |
| `{cout, sum} = a + b;` | `sum : unsigned(W downto 0);  sum <= ('0' & a) + ('0' & b);` |
| `localparam ADD = 2'b00;` | `type op_t is (OP_ADD, OP_SUB, OP_AND, OP_OR);` |
| `always @(*) if (en) y = a;  // latch` | `process (all) begin y <= '0'; if en = '1' then y <= a; end if; end process;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Multiplexers: when, with, case](01-mux-and-select/README.md) | Build 2:1 and 4:1 muxes in all three styles and know which one to reach for. | planned |
| 02 | [Decoders and priority encoders](02-decoders-and-encoders/README.md) | Write a one-hot decoder and a priority encoder, then a 7-segment decoder you can reuse in the capstone. | planned |
| 03 | [Adders and subtractors](03-adders-and-subtractors/README.md) | Build a ripple-carry adder with explicit carry, then get subtraction and overflow right using `unsigned` and `signed`. | planned |
| 04 | [Comparators and a small ALU](04-comparators-and-alu/README.md) | Use the comparison operators on numeric types, then assemble a parameterized ALU and test every opcode. | planned |
| 05 | [Avoiding latches](05-avoiding-latches/README.md) | Recognize the incomplete-assignment pattern that infers a latch, and learn the two habits that prevent it. | planned |

## After this topic you can

- Describe any truth table as concurrent VHDL
- Avoid accidental latches
- Build an ALU from typed arithmetic instead of bit twiddling

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-02-combinational
```
