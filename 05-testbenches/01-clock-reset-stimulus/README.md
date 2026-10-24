# 01 — Clock, reset, stimulus

**Status:** planned · **Topic:** [05-testbenches — Testbenches](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Build the three processes every testbench needs: clock, reset, stimulus — and keep them independent.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always #5 clk = ~clk;` | `clk <= not clk after 5 ns;` |

## Concepts

- A clock is `clk <= not clk after PERIOD/2;` — a concurrent assignment with a delay.
- Reset is applied for a bounded number of cycles, then released at a clock edge.
- Stimulus should `wait until rising_edge(clk)` so vectors align with the DUT's clock.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Parameterize the clock period with a generic and run the same TB at 10 MHz and 100 MHz.
2. Add an active-low reset and check the DUT outputs are defined during reset.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
