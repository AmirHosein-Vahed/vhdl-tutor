# 02 — Signals vs variables

**Status:** done · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Ready.** Run `make` in this folder. It builds `sig_vs_var`, runs its
> self-checking testbench, and exits non-zero if anything fails.

## Goal

Understand the single biggest semantic difference from Verilog's
blocking/non-blocking split: a signal assignment is *scheduled*, a variable
assignment *happens now*. Two identical-looking processes can build different
hardware because of it.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) begin a = d; b = a; end` (blocking) | `v1 := d; v2 := v1;` — variables, immediate |
| `always @(posedge clk) begin a <= d; b <= a; end` (non-blocking) | `s1 <= d; s2 <= s1;` — signals, scheduled |

Both Verilog styles have a VHDL analogue, but the analogue is a *different kind
of object*, not a different assignment operator on the same object.

## Concepts

- **Signals** live in the architecture, connect processes, and update at the end
  of the current delta cycle. The right-hand side is evaluated immediately; the
  left-hand side changes later.
- **Variables** live inside one process or subprogram. `:=` takes effect on the
  next line, in source order, and is invisible outside the process.
- A variable declared in a process keeps its value between invocations. If it is
  read before it is written in a clocked process, it infers a register — the
  compiler will not warn you.
- A chain of signal assignments in one clocked process is a pipeline; the same
  chain with variables collapses into one stage.
- Rule of thumb: use signals for anything that crosses a process boundary, and
  variables only for intermediate combinational values inside a process.

## Files

| File | Purpose |
|---|---|
| `src/sig_vs_var.vhd` | one two-stage signal pipeline and one variable "pipeline" |
| `tb/sig_vs_var_tb.vhd` | checks that `q_sig` lags `q_var` by exactly one clock |

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and write build/sig_vs_var_tb.ghw
make clean  # remove build/
```

## What to observe

**PASS (10 checks)** at 46 ns. Then look at the waveform: `d`, `q_sig`, and
`q_var` on the same time axis.

- `q_var` changes on the same rising edge that samples `d` — it is the value
  captured at that edge.
- `q_sig` is one edge behind, because `s2 <= s1` sees the *old* `s1`.

The two processes contain the same number of assignments. Only the object kind
differs, and that changes the latency.

## Tasks

1. Open `make wave` and add `d`, `q_sig`, `q_var`. Confirm `q_sig` is exactly
   one clock later than `q_var`.
2. Add a third signal stage (`s3 <= s2`) and predict the new latency before
   running.
3. Rewrite the variable process using signals. Explain why it becomes a
   two-stage pipeline and which check in the testbench would now fail.

## Hints

<details><summary>Show hints</summary>

- Variable declarations go in the process declarative part, before `begin`.
- `:=` is variable assignment; `<=` is signal assignment. Mixing them up is a
  compile error, which is a good thing.
- A signal declared in the architecture can be read by every process; a
  variable cannot leave its process.

</details>

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — §10.5
  (signal assignment) and §10.6 (variable assignment).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — delta cycles in the
  simulation cycle.
- [04 — Pitfalls](../../docs/04-pitfalls.md) — the delta-cycle traps in context.
