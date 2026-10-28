# 07 — Synthesis awareness

Simulation answers "does the logic do what I meant?". Synthesis answers "what
hardware will it become?". You do not need an FPGA board to learn the second
question, but you do need to know which code has no hardware meaning.

This document is the companion to topic 10.

---

## The synthesizable subset

| Construct | Synthesizable? | Notes |
|---|---|---|
| `entity`, `architecture`, `port`, `generic` | yes | the core |
| concurrent assignments, `when`, `with` | yes | becomes mux/logic |
| `process` with `if`/`case`/loops | yes | loops unroll |
| `rising_edge` / `falling_edge` | yes | the only clock test |
| synchronous / asynchronous reset | yes | template-dependent |
| `for generate`, `if generate` | yes | elaborate-time replication |
| functions, procedures | yes | must be pure combinational |
| packages, records, enumerations | yes | records on top-level ports vary by tool |
| signal initial values | tool-dependent | FPGA yes, ASIC no |
| `after` delays | **no** | ignored or rejected |
| `wait for`, `wait on` | **no** | `wait until rising_edge` inside a process is how a clock is inferred |
| `textio`, `file` | **no** | testbench only |
| `report` for behaviour | **no** | assertions may be kept for formal flows |
| `real`, `time` arithmetic | **no** | use integers or fixed point |
| division by non-constant | usually no | use a divider IP or iterative algorithm |
| access types (pointers) | no | not for RTL |
| `'image`, `'value` | no | string handling has no hardware |
| `std.env.finish` | no | simulation control |
| PSL assertions in comments | ignored | useful for formal |

The pattern: **anything that depends on wall-clock time or on the host
software is simulation-only.** Everything that is a function of current inputs
and stored state can become hardware.

---

## What your code infers

| RTL pattern | Hardware |
|---|---|
| `y <= a when s = '1' else b;` | 2:1 mux (LUT) |
| `case sel is ...` with N branches | mux tree, or one LUT per output bit |
| `a + b` on `unsigned` | carry chain |
| `a * b` by a constant | shifts and adds (often free) |
| `a * b` by a variable | DSP block or a large multiplier |
| shift by a constant | wiring, zero cost |
| shift by a variable | barrel shifter (mux tree) |
| `if rising_edge(clk)` with `en` | flip-flop with a clock-enable mux |
| array with sync write + sync read | block RAM |
| array with async read | distributed RAM / LUT RAM |
| array with no reset and async read | ROM (if never written) |
| `if` without `else` in combinational code | **latch** |
| two clocked processes on different clocks | two domains; needs CDC |

The two entries in bold are the ones that cause real bugs: latches and clock
domains. Everything else is area and speed.

---

## The Yosys flow

Install Yosys and build the GHDL plugin:

```bash
sudo apt install yosys
git clone https://github.com/ghdl/ghdl-yosys-plugin
cd ghdl-yosys-plugin
make            # needs ghdl and yosys headers
sudo make install
```

Then, from a lesson folder with synthesizable `src/`:

```bash
make synth
```

which runs:

```bash
yosys -m ghdl -p "ghdl --std=08 --workdir=build and2; synth; stat"
```

The `make synth` target analyzes the sources with GHDL first, then asks the
Yosys plugin to elaborate the unit already in `build/`. If your GHDL comes from
a relocatable tarball rather than a distro package, export `GHDL_PREFIX` (for
example `~/.local/opt/ghdl-6.0.0/lib/ghdl`) so libghdl can find its `std` and
`ieee` libraries.

What the report tells you:

```
=== and2 ===

   Number of wires:                  1
   Number of cells:                  1
     $_AND_                          1
```

For a bigger design you get counts per cell type: `$_DFF_P_` (positive-edge
flip-flop), `$_MUX_`, `$_AND_`, `$_XOR_`, `$mem` (memory), `$_DFF_PP0_`
(reset), and so on. Those are generic gates, not an FPGA's LUTs, but the
*relative* numbers are still informative:

- a counter should show a carry chain and W flip-flops,
- a mux should show one `$_MUX_` per bit per select line, not a latch,
- a RAM should show a `$mem` cell, not thousands of gates,
- a latch shows up as `$_DLATCH_*`, which is almost always a bug.

To see the netlist instead of the counts:

```bash
yosys -m ghdl -p "ghdl --std=08 src/alu.vhd -e alu; synth; write_json build/alu.json"
netlistsvg build/alu.json -o build/alu.svg
```

`netlistsvg` is a small Node tool; Graphviz's `dot` works too.

---

## Reading synthesis warnings

The messages that matter, in order:

1. **"Latch inferred"** — a combinational process does not assign on every
   path. Fix the RTL; do not silence the warning.
2. **"Port has no driver"** — a signal is never assigned. It will be `'U'` in
   simulation and tied off in hardware.
3. **"Multiple drivers"** — two processes drive the same signal. Only legal
   with a resolved type and tri-state, and rarely what you meant.
4. **"Combinational loop"** — the logic depends on itself. Simulation may
   converge; hardware will not.
5. **"Ignoring initial value"** — ASIC flow; add a reset.
6. **"Found and optimized away"** — dead logic. Sometimes fine, sometimes a
   sign your output is never read.

---

## What this course does not cover

Deliberately out of scope, because they need hardware and vendor tools:

- pin constraints and I/O standards,
- clock constraints, timing closure, and `false_path`/CDC constraints,
- bitstream generation,
- board-level reset and clocking,
- power analysis.

If you later target an FPGA, the same RTL works; what you add is constraint
files and a vendor-specific synthesis run. The concepts from topic 10 —
inference, latches, memories, CDC — transfer unchanged.

---

## A sanity checklist before synthesis

- [ ] Every `process` with `rising_edge` has exactly one clock.
- [ ] Every combinational `process` assigns every output on every path.
- [ ] No `after`, `wait for`, `textio`, or `real` in `src/`.
- [ ] Every port is driven.
- [ ] Every array that should be RAM is written and read in a clocked process.
- [ ] No combinational feedback.
- [ ] Reset values are defined for every state register.
- [ ] The design still passes `make` after the last edit.

---

Back to: [Documentation index](../README.md#documentation) ·
[04 — Pitfalls](04-pitfalls.md) · [06 — Verification](06-verification.md)
