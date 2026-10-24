# 03 — File I/O and TB generics

**Status:** planned · **Topic:** [05-testbenches — Testbenches](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Load vectors from a text file with `textio`, and make one testbench serve every configuration of the DUT.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `$readmemh("vec.hex", mem);` | `readline(f, l);  read(l, v);` |

## Concepts

- `ieee.std_logic_textio` provides `read`/`write` for `std_logic_vector`; `std.textio` handles lines.
- Read until `endfile` and count lines so a malformed file fails loudly.
- Drive width, clock, and vector file from generics — the testbench becomes a reusable tool.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write a file with 32 vectors, feed it to the ALU, and assert on every output.
2. Add a `VEC_FILE` generic so `make run RUN_ARGS="-gVEC_FILE=..."` selects a different vector set.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
