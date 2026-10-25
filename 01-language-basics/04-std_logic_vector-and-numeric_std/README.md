# 04 — std_logic_vector and numeric_std

**Status:** done · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `arith_demo`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Do arithmetic without `std_logic_arith`. Learn the explicit conversions, the
width rules, and why mixing arithmetic libraries is a bug factory.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `a + b` on `logic [7:0]` | `unsigned(a) + unsigned(b)` |
| `{carry, sum} = a + b` | `('0' & unsigned(a)) + ('0' & unsigned(b))` |
| `$signed(a)` | `signed(a)` |
| `a * b` (result 16 bits) | `unsigned(a) * unsigned(b)` (result 16 bits) |
| `a > b` | `unsigned(a) > unsigned(b)` |
| `` `include "std_logic_arith.vh" `` | never — use `ieee.numeric_std` |

In Verilog, `logic [7:0]` gets an implicit unsigned interpretation in
arithmetic. In VHDL, `std_logic_vector` has no arithmetic at all: you convert to
`unsigned` or `signed`, compute, and convert back.

## Concepts

- `std_logic_vector` is an array of bits. `unsigned` and `signed` are arrays of
  bits with a numeric interpretation. The bit pattern is the same; the type is
  not.
- Conversions are explicit: `unsigned(slv)`, `signed(slv)`,
  `std_logic_vector(u)`, `to_unsigned(n, width)`, `to_signed(n, width)`,
  `to_integer(u)`.
- Width grows with the operation. `8 + 8` needs 9 bits to keep the carry;
  `8 × 8` needs 16. VHDL will not silently widen for you — a narrower target
  truncates.
- `numeric_std` defines `+`, `-`, `*`, comparisons and shifts for `unsigned`
  and `signed`, including mixed operations with `natural`/`integer` where they
  are unambiguous.
- Unsigned subtraction is modulo `2**width`. `10 - 20` in 9 bits is 502, not
  −10. If you need a sign, use `signed` and enough width.
- `resize(x, n)` zero-extends `unsigned` and sign-extends `signed`. Slicing is
  not the same operation.
- Never use `std_logic_arith`, `std_logic_unsigned` or `std_logic_signed`. They
  make `std_logic_vector` arithmetic look implicit, conflict with `numeric_std`,
  and differ between vendors.

## Files

| File | Purpose |
|---|---|
| `src/arith_demo.vhd` | 9-bit sum and difference, 16-bit product, comparison, saturating add |
| `tb/arith_demo_tb.vhd` | carry, wrap, product width, saturation and conversion checks |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and write build/arith_demo_tb.ghw
make clean  # remove build/
```

## What to observe

**PASS (19 checks)** at 3 ns.

- With `a = 10`, `b = 20`, `sum` is 30 but `diff` is **502**. Nine-bit unsigned
  subtraction wraps modulo 512; the testbench asserts that value on purpose.
- With `a = 200`, `b = 100`, `sum` is 300 and keeps the ninth bit. `sat` is 255,
  because the saturating adder clamps instead of wrapping.
- `resize(signed(a), 16)` with `a = 0xFF` is `to_signed(-1, 16)`: sign
  extension is not zero extension.
- The transcript contains no `metavalue detected` warnings, because the
  testbench initializes its inputs. An all-`'U'` input at time 0 would make
  `numeric_std` comparisons complain — useful to know when a waveform looks
  wrong at 0 ns.

## Tasks

1. Add a `signed_diff : out std_logic_vector(8 downto 0)` that computes `a - b`
   as signed. Check that it reports −10 for the first vector.
2. Change `sum` to 8 bits and run. Find which check fails and explain why the
   ninth bit matters.
3. Implement a saturating subtract in the same style as `sat`.
4. Replace one `to_unsigned(..., 8)` conversion with a plain integer and see
   where the type checker stops you.

## Hints

<details><summary>Show hints</summary>

- `('0' & unsigned(a))` is the idiomatic way to add one bit of headroom.
- `unsigned(a) - unsigned(b)` in a 9-bit target wraps; cast to `signed` first
  and sign-extend both operands if you want a negative result.
- `to_integer` accepts `unsigned`/`signed`, not `std_logic_vector`. Convert
  first.
- `numeric_std` comparison against an integer literal works when the literal is
  a `natural` in range.

</details>
