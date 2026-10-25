# 01 — The first clocked process

**Status:** planned · **Topic:** [03-sequential — Sequential logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Turn a combinational adder into a register with one `if rising_edge(clk)` — and understand why nothing else belongs in that `if`.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) q <= d;` | `process (clk) begin if rising_edge(clk) then q <= d; end if; end process;` |

## Concepts

- `rising_edge(clk)` is the only clock-edge test you should write.
- All assignments inside the clocked process become registers; assignments outside stay combinational.
- A clocked process with an asynchronous reset has two sensitivity entries (`clk`, `rst`) and a reset branch first.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add an enable and make the register hold its value when disabled.
2. Replace `rising_edge` with `clk'event and clk = '1'` and explain why the former is preferred.
