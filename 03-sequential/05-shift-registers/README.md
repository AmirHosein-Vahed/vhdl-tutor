# 05 — Shift registers

**Status:** planned · **Topic:** [03-sequential — Sequential logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Implement SISO, SIPO and PISO shifts, then an LFSR, using the shift operators you already know from Verilog.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `q <= {q[6:0], d};` | `q <= q(6 downto 0) & d;` |

## Concepts

- `shift_left`/`shift_right` are logical; `sll`/`srl` are the older operator forms; `rotate_left` wraps.
- A shift register is just a register whose next value is a concatenation or slice of itself.
- An LFSR is a shift register with XOR feedback — useful as a cheap PRNG in testbenches.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Build a parameterized barrel shifter and compare its size with the serial version in topic 10.
2. Use an 8-bit LFSR to generate 100 pseudo-random test vectors and check them for repeats.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
