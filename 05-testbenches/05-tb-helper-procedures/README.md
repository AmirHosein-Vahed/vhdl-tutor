# 05 — Reusable testbench helpers

**Status:** planned · **Topic:** [05-testbenches — Testbenches](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Move repeated stimulus and checking into a package (`tb_utils`), so testbenches read like test plans.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `task automatic drive(input logic [7:0] d);` | `procedure drive(signal d : out std_logic_vector);` |

## Concepts

- Procedures in a package can take signals as `signal` parameters and drive them.
- Overloading lets one `check` procedure accept `std_logic`, `unsigned`, and `integer`.
- A shared package is how VHDL teams build BFMs without a framework.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add `check_eq` overloads for `unsigned` and `integer` to `common/vhdl/tb_utils.vhd`.
2. Write a `send_byte` procedure that drives a UART transmitter and use it in two testbenches.
