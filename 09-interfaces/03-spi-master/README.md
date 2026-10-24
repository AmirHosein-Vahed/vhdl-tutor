# 03 — SPI master

**Status:** planned · **Topic:** [09-interfaces — Interfaces and protocols](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build a mode-0 SPI master with a clock divider, chip select, and simultaneous transmit/receive.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `spi_sclk <= ~spi_sclk;  // in a divider` | `sclk <= not sclk after PERIOD/2;` |

## Concepts

- CPOL/CPHA define which edge shifts and which samples; mode 0 is idle-low, sample on first edge.
- SPI is a shift register in each direction: `mosi` out and `miso` in on the same clock edges.
- Chip select must be asserted before the first edge and deasserted after the last, with setup/hold time.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Talk to a simulated SPI flash model that returns a fixed ID byte and assert on it.
2. Add mode 1 support behind a generic and verify both edges with a testbench.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
