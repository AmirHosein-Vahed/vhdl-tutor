# 01-language-basics — Language basics

**Status:** 0/6 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

The parts of VHDL that have no Verilog equivalent, or a misleading one: strong typing, resolved signals, array ranges, and the delta cycle. Short topic, but everything after it depends on it.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `logic [7:0] x;` | `signal x : std_logic_vector(7 downto 0);` |
| `4'b1010` | `"1010"  (or 10, or x"A")` |
| `always @(*) begin t = a; y = t; end  // blocking` | `process (all) variable t : std_logic; begin t := a; y <= t; end process;` |
| `[7:0] v;  // fixed direction` | `signal v : std_logic_vector(7 downto 0);` |
| `v[3:0]` | `v(3 downto 0)` |
| `a + b  // width = max(len(a), len(b))` | `unsigned(a) + unsigned(b)  -- result width = max` |
| `$signed(a)` | `signed(a)` |
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Types and literals](01-types-and-literals/README.md) | Stop treating `std_logic` as `logic`. Learn the 9 values, the numeric types, and every literal form you will meet. | planned |
| 02 | [Signals vs variables](02-signals-vs-variables/README.md) | Understand the single biggest semantic difference from Verilog's blocking/non-blocking split: signals are scheduled, variables are immediate. | planned |
| 03 | [downto vs to, and indexing](03-downto-vs-to-and-indexing/README.md) | Get array ranges right the first time, and stop guessing which bit is the MSB. | planned |
| 04 | [std_logic_vector and numeric_std](04-std_logic_vector-and-numeric_std/README.md) | Do arithmetic without `std_logic_arith`. Learn the conversions, the width rules, and why mixing libraries is a bug factory. | planned |
| 05 | [Concurrent vs sequential statements](05-concurrent-vs-sequential/README.md) | See that `y <= a and b;` is already a process, and that `when`/`with`/`case`/`if` are interchangeable descriptions of the same hardware. | planned |
| 06 | [Attributes and generics](06-attributes-and-generics-intro/README.md) | Use attributes instead of magic numbers, and generics instead of editing constants before every build. | planned |

## After this topic you can

- Read and write any VHDL declaration without guessing
- Convert between `std_logic_vector`, `unsigned`, `signed` and `integer` on purpose
- Predict when a signal assignment takes effect

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-01-language-basics
```
