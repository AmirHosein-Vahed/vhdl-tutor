# 05 — Concurrent vs sequential statements

**Status:** planned · **Topic:** [01-language-basics — Language basics](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

See that `y <= a and b;` is already a process, and that `when`/`with`/`case`/`if` are interchangeable descriptions of the same hardware.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |
| `case (s) ... endcase` | `with s select y <= ... ;` |

## Concepts

- Concurrent assignments elaborate into implicit processes sensitive to their right-hand side.
- `when ... else` is conditional assignment; `with ... select` is a selected assignment; `case` needs a process.
- `process (all)` (VHDL-2008) replaces hand-written sensitivity lists and avoids simulation mismatches.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Implement a 4:1 mux three ways and confirm the synthesized logic is identical (see topic 10).
2. Write a process with an incomplete sensitivity list, observe the mismatch, then fix it with `process (all)`.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
