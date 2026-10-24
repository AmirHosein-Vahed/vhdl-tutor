# 04-state-machines — State machines

**Status:** 0/4 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Every FSM you have written in Verilog works in VHDL, but the idiomatic shape is different: an enumeration type instead of `localparam`, and a clear split between state register and next-state logic.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `localparam IDLE = 2'd0;` | `type state_t is (IDLE, RUN);  signal state : state_t;` |
| `(* fsm_encoding = "one_hot" *)` | `attribute enum_encoding : string;` |
| `always @(posedge clk) q1 <= q0;` | `process (clk) begin if rising_edge(clk) then q1 <= q0; end if; end process;` |
| `if (baud_tick) state <= ...;` | `if baud_tick = '1' then state <= ...;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Moore, Mealy, and the template](01-moore-mealy-template/README.md) | Implement the same protocol as a Moore and as a Mealy machine and see exactly what changes in the waveform. | planned |
| 02 | [State encoding and safe FSMs](02-encoding-and-state-signals/README.md) | Control how states are encoded, add a default transition, and understand what `when others` costs (nothing). | planned |
| 03 | [FSM + datapath: debouncer](03-fsm-debouncer/README.md) | Build a real button debouncer with a counter-based filter and an edge detector — your first FSM that owns a datapath. | planned |
| 04 | [FSM + datapath: UART transmitter](04-fsm-uart-transmitter/README.md) | Design the classic baud-rate FSM: idle, start, eight data bits (LSB first), stop — with a busy flag for back-pressure. | planned |

## After this topic you can

- Write a three-process FSM from memory
- Choose an encoding and justify it
- Combine an FSM with a datapath (debouncer, UART)

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-04-state-machines
```
