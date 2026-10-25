# 03 — downto vs to, and indexing

**Status:** done · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `slice_demo`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Get array ranges right the first time. A range direction is part of the subtype,
so `(7 downto 0)` and `(0 to 7)` hold the same eight bits but disagree about
which index is leftmost — and slices must follow the direction.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `logic [7:0] v;` (fixed direction) | `std_logic_vector(7 downto 0)` or `std_logic_vector(0 to 7)` |
| `v[3:0]` | `v(3 downto 0)` — direction must match the declaration |
| `$bits(v)` | `v'length` |
| `v[7]` (MSB) | `v(v'high)` |
| `for (int i = 0; i < 8; i++)` | `for i in v'range loop` |

Verilog has one direction: `[7:0]` means index 7 on the left. VHDL lets you
declare either direction, and code that assumes one breaks on the other.

## Concepts

- `downto` and `to` are directions, not operators. `(7 downto 0)` is descending;
  `(0 to 7)` is ascending.
- Attributes describe any range without hard-coded numbers: `'left` and `'right`
  are the textual ends, `'high` and `'low` are the numeric bounds, `'length` is
  the number of elements, and `'range` is the whole range.
- For a descending range, `'left = 'high` and `'right = 'low`. For an ascending
  range the pairs swap.
- A slice must use the same direction as the array: `din(7 downto 4)` works on
  `(7 downto 0)`, but `din(4 to 7)` does not.
- Assignment between arrays of the same length is positional. A string literal
  like `"1010"` maps to the leftmost index first, whatever that index is.
- The reversal function in `src/` works for both directions because it uses the
  argument's own attributes: `r(i) := v(v'high + v'low - i)`.

## Files

| File | Purpose |
|---|---|
| `src/slice_demo.vhd` | nibble slices, a direction-independent reversal, and two opposite 4-bit ranges |
| `tb/slice_demo_tb.vhd` | checks slices, attributes, reversal, and the index-direction trap |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and write build/slice_demo_tb.ghw
make clean  # remove build/
```

## What to observe

**PASS (21 checks)** at 2 ns.

- `din = 0x96` is `1001_0110`, so `high_nibble` is `1001`, `low_nibble` is
  `0110`, and `reversed` is `0x69`.
- `descending` and `ascending` both hold the literal `"1010"`, and both compare
  equal to that string. But `descending(3) = '1'` while `ascending(3) = '0'`:
  index 3 is the leftmost bit in one and the rightmost bit in the other.
- `descending(1) = '1'` and `ascending(1) = '0'`. If you only ever test index 0
  or 3, a palindrome such as `"1001"` hides the difference; `"1010"` does not.

## Tasks

1. Change `din` to `0xE1` and predict `reversed` before running. The answer is
   `0x87`.
2. Wrap the reversal function in a new entity with a `WIDTH : positive` generic
   and check it for 4, 8, and 12 bits.
3. Replace `din(3 downto 0)` with `din(0 to 3)` and read the compiler error.
   Then try `din(0 to 3)` on an ascending copy of the port and see it work.
4. Write a loop that resets every bit of a vector without knowing its direction
   or width.

## Hints

<details><summary>Show hints</summary>

- `v'range` in a `for` loop iterates in the declared direction, so it is safe
  for both `to` and `downto`.
- `v'left` is 7 for `(7 downto 0)` and 0 for `(0 to 7)`. `v'high` is 7 in both.
- A slice must use its source array's direction. Whole-vector assignment is
  looser: a `downto` value can be assigned to a `to` port, and it maps
  leftmost-to-leftmost — a silent reversal, not an error.

</details>
