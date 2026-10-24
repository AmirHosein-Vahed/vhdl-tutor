# 01 — Components vs direct instantiation

**Status:** planned · **Topic:** [06-modularity — Modularity](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Instantiate the same entity both ways and understand the binding step that only components have.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `foo u (.a(a), .y(y));` | `u : entity work.foo port map (a => a, y => y);` |

## Concepts

- `u : entity work.foo port map (...)` binds at elaboration and is the modern default.
- A component declaration defers binding to a configuration — useful for swapping architectures.
- Named association (`a => sig_a`) is mandatory practice; positional association breaks silently.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Swap the DUT architecture in a testbench without touching the instantiation.
2. Break an association by position and observe how late the error appears.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
