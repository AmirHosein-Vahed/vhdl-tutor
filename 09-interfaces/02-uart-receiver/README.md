# 02 — UART receiver

**Status:** planned · **Topic:** [09-interfaces — Interfaces and protocols](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Receive what topic 04 transmits: start-bit detection, mid-bit sampling, framing and parity errors.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `if (!rx) state <= START;` | `if rx = '0' then state <= START; end if;` |

## Concepts

- Detect the falling edge of an idle-high line, then sample at half a bit period to find the bit centre.
- Oversample (e.g. 16x) and vote, or sample once per bit at the centre — decide and document.
- `framing_error` when the stop bit is not `'1'`; `parity_error` when the parity does not match.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Loop the transmitter into the receiver in one testbench and send 100 random bytes.
2. Add a 16x oversampler with majority voting and compare error rates with single sampling.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
