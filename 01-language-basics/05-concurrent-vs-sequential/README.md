# 05 — Concurrent vs sequential statements

**Status:** done · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `mux_styles`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

See that `y <= a and b;` is already a process, and that `when` / `with` /
`case` / `if` are interchangeable descriptions of the same hardware. Choose
between them for readability, not for behaviour.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |
| `always @(*) case (s) ... endcase` | `process (all) ... case s is ... end case;` |
| `always_comb` | `process (all)` with a default assignment |
| `assign y = a & b;` | `y <= a and b;` — concurrent, no `assign` keyword |

There is no `assign` keyword in VHDL. Every concurrent statement in an
architecture body is an implicit process that runs whenever one of its inputs
changes. Sequential statements only exist *inside* a process.

## Concepts

- A concurrent signal assignment is equivalent to a process with the right
  sensitivity list. `y <= a and b;` and a `process (a, b) begin y <= a and b;
  end process;` describe the same circuit.
- `when`/`else` is a priority chain. The first true condition wins, so later
  branches imply the earlier ones were false.
- `with ... select` is a parallel case: choices must be disjoint and exhaustive.
  There is no priority; each choice maps independently.
- `case` lives inside a process, requires a `when others` for `std_logic_vector`
  in practice, and is the clearest way to write a decoder.
- `process (all)` (VHDL-2008) derives the sensitivity list from the body, which
  prevents the classic "forgot an input, simulation passes, synthesis differs"
  bug.
- Every branch must assign the output, or you infer a latch. A default
  assignment at the top of the process is the usual guard.

## Files

| File | Purpose |
|---|---|
| `src/mux_styles.vhd` | one 4:1 mux written with `when`, `with`, and `case` |
| `tb/mux_styles_tb.vhd` | drives all four select values through all three outputs |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and write build/mux_styles_tb.ghw
make clean  # remove build/
```

## What to observe

**PASS (19 checks)** at 5 ns. Every select value produces the same byte on
`y_when`, `y_with` and `y_case`, and the testbench also checks that the three
outputs agree with each other.

- `sel = "11"` falls into the final `else` / `when others` branch. That is the
  only branch that keeps the design total.
- `with sel select` is a lookup table, not a priority chain. In `when`/`else`,
  reordering the branches can change behaviour; in `with`/`select`, each choice
  is independent.
- The process has no sensitivity list at all in the source; `(all)` is what
  keeps it correct.

## Tasks

1. Add a `valid` input. When it is `'0'`, all three outputs must be `0`. Keep
   the three styles behaviourally identical.
2. Replace the `case` with `if`/`elsif`/`else` and confirm the testbench still
   passes.
3. Remove `when others` from the `with`/`select` and read the compiler error.
   Do the same for the `case`, and note the difference between the two messages.
4. Add a default assignment at the top of the process, then delete one branch.
   Explain what hardware the missing branch would infer.

## Hints

<details><summary>Show hints</summary>

- `process (all)` is VHDL-2008; the build already uses `--std=08`.
- A selected assignment needs a choice for every possible value of the selector.
  `when others` covers the rest.
- `y <= (others => '0');` as the first statement of a process is the standard
  way to avoid latches.

</details>
