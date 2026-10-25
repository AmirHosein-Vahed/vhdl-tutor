# 06 — Attributes and generics

**Status:** done · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `param_counter`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Use attributes instead of magic numbers, and generics instead of editing
constants before every build. One entity, two widths, two terminal counts, no
copy-paste.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `parameter WIDTH = 8;` | `generic (WIDTH : positive := 8);` |
| `#(.WIDTH(16), .MAX(1000))` | `generic map (WIDTH => 16, MAX => 1000)` |
| `$bits(v)`, `$high(v)` | `v'length`, `v'high`, `v'low` |
| `$size`, `$left`, `$right` | `'length`, `'left`, `'right`, `'range`, `'image` |
| `localparam` | `constant` in the architecture |

Generics are elaboration-time values: they can set port widths, array bounds,
constants, and the behaviour of subprograms. They are not run-time inputs.

## Concepts

- A generic is a parameter of the entity. `generic map` overrides it per
  instance, so two instances of one entity can be completely different circuits.
- `'length`, `'high`, `'low`, `'left`, `'right`, and `'range` are attributes
  that describe a signal, variable, or type. They keep code dimension-agnostic.
- `'image` turns a value into a string; it is how VHDL prints numbers in
  reports without `$display`-style formatting.
- A function declared in the architecture declarative part can read the
  generics. `terminal_count` runs at elaboration and converts the generic
  `MAX` into a `WIDTH`-bit unsigned.
- `MAX = 0` is a sentinel: it means "wrap at the natural maximum",
  `2**WIDTH - 1`. A real terminal count would use `MAX >= 1`.
- `(others => '0')` works for any width, so reset and wrap logic never mention
  `WIDTH`.
- Named association (`WIDTH => 4, MAX => 9`) is self-documenting and
  order-independent. Positional association is legal but easy to break when a
  generic is inserted.

## Files

| File | Purpose |
|---|---|
| `src/param_counter.vhd` | generic-width, generic-limit wrapping counter |
| `tb/param_counter_tb.vhd` | instantiates a 4-bit/9 and a 6-bit/40 counter and checks both |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and write build/param_counter_tb.ghw
make clean  # remove build/
```

## What to observe

**PASS (30 checks)** at 536 ns.

- `dut4` counts 0…9, raises `at_max`, and wraps to 0 on the next edge.
- `dut6` counts 0…40 and wraps to 0, independently of `dut4`. The two instances
  share a clock and a reset but have separate enables in the testbench.
- `cnt4'length = 4` and `cnt6'length = 6`. The same source produced both,
  and the testbench uses attributes to check it.
- The terminal count is computed at elaboration. If you pass `MAX = 9` with
  `WIDTH = 3`, `to_unsigned` fails during elaboration instead of producing a
  counter that never matches.

## Tasks

1. Add a `STEP : positive := 1` generic. Update the wrap condition so the
   counter never steps past `MAX`, and extend the testbench with `STEP => 3`.
2. Instantiate a third counter with `MAX => 0` and `WIDTH => 5`. Check that it
   wraps at 31.
3. Replace the reset assignment with a loop over `cnt'range` and confirm the
   behaviour is unchanged.
4. Break it on purpose: instantiate `WIDTH => 3, MAX => 9` and read the
   elaboration error. Then decide whether a runtime assertion would be better
   for your own designs.

## Hints

<details><summary>Show hints</summary>

- Generics are visible in the architecture declarative part, including inside
  functions declared there.
- `to_unsigned(MAX, WIDTH)` needs `MAX <= 2**WIDTH - 1`; check that before you
  blame the testbench.
- Attributes also work on ports (`count'length` inside the entity is fine) and
  on literal types (`integer'image`).
- `generic map` uses `=>`, the same association syntax as `port map`.

</details>

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — §6.5.3
  (generics), §16.2 (predefined attributes).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — elaboration order and
  generic diagnostics.
- [07 — Synthesis](../../docs/07-synthesis.md) — what a generic costs in
  hardware (usually nothing: it is resolved before synthesis).
