# 01 — Types and literals

**Status:** done · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `literals`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Stop treating `std_logic` as `logic`. Learn the nine values, the numeric types,
and every literal form you will meet — and see why a `std_logic_vector` is not
a number.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `logic [7:0] x = 8'hFF;` | `signal x : std_logic_vector(7 downto 0) := x"FF";` |
| `4'b1010` | `"1010"` (or `10`, or `x"A"`) |
| `logic` | `std_logic` — a 9-value resolved type, not a bit |
| `int N = 1_000_000;` | `constant N : natural := 1_000_000;` |

`logic` and `std_logic` look interchangeable in the happy path. They are not:
`std_logic` carries simulation states (`'U'`, `'X'`, `'Z'`, …) as *values*, and
the compiler will not let you add two of them.

## Concepts

- `std_logic` has nine values: `'U'` uninitialized, `'X'` conflict, `'0'`,
  `'1'`, `'Z'` high impedance, `'W'` weak unknown, `'L'` weak 0, `'H'` weak 1,
  `'-'` don't care. Only `'0'`/`'1'` exist as hardware; the others are how
  simulation tells you something is wrong.
- A *resolved* type combines multiple drivers. `'1'` and `'H'` resolve to `'1'`;
  `'0'` and `'1'` on the same net resolve to `'X'`.
- Literals: decimal `255`, based `16#FF#`, binary `2#1111_1111#`, string
  `"1010"`, bit-string `x"FF"`, with `_` ignored by the lexer.
- `integer` is a 32-bit signed type in practice; `natural` (0 and up) and
  `positive` (1 and up) are constrained subtypes. A range violation is an
  error — at elaboration for constants, at run time for signals.
- `std_logic_vector` is an array of `std_logic`; it has no arithmetic. `bit`
  and `bit_vector` exist but throw away `'U'`/`'X'`/`'Z'`, so the course uses
  `std_logic` everywhere.

## Files

| File | Purpose |
|---|---|
| `src/literals.vhd` | five spellings of 255, exposed as ports |
| `tb/literals_tb.vhd` | checks every spelling, the 9-value type, and subtype bounds |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and write build/literals_tb.ghw
make clean  # remove build/
```

## What to observe

The testbench reports **PASS (15 checks)** at 1 ns. Two details are worth
stopping on:

- `std_logic'image('Z')` returns the three-character string `"'Z'"`, quotes
  included. A `std_logic` value is an enumeration literal, not a character.
- `'1' and 'H'` evaluates to `'1'` because `std_logic` is resolved. Replace
  `'H'` with `'0'` in that expression and the result becomes `'X'` — the
  simulator's way of reporting a short circuit.

## Tasks

1. Add constants for `2#1010_1010#` and `B"10101010"` and check that both equal
   `x"AA"`.
2. Declare `subtype nibble_t is integer range 0 to 15;` and try to assign 16 to
   it. Note whether the error appears at analysis, elaboration, or run time.
3. Make `underscored` an 8-bit `std_logic_vector` output using `to_unsigned`
   and update the testbench.

## Hints

<details><summary>Show hints</summary>

- Compare values with `check_eq`; for strings use `check(expr = "text", ...)`
  because there is no string overload.
- `x"FF"` is a bit-string literal of length 4 × the number of hex digits.
- `natural` is a subtype of `integer`, so `natural'low` is 0 but
  `integer'low` is negative.

</details>

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — §5.2
  (scalar types) and §15 (lexical elements).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — how GHDL reports
  metavalues and range checks.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
