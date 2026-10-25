# 04 — FSM + datapath: UART transmitter

**Status:** planned · **Topic:** [04-state-machines — State machines](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Design the classic baud-rate FSM: idle, start, eight data bits (LSB first), stop — with a busy flag for back-pressure.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `if (baud_tick) state <= ...;` | `if baud_tick = '1' then state <= ...;` |

## Concepts

- A baud generator is a counter to `CLK_HZ/BAUD`; the FSM ticks on its terminal count.
- A shift register transmits LSB first; the FSM only decides when to shift.
- `busy`/`ready` is a handshake: the caller must not start a new byte while busy is high.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Verify the bit period in the waveform for 115200 baud from a 50 MHz clock.
2. Add a `parity` generic and make the testbench decode the frame it receives.
