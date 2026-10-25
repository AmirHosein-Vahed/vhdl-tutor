# 05 — Avoiding latches

**Status:** planned · **Topic:** [02-combinational — Combinational logic](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Recognize the incomplete-assignment pattern that infers a latch, and learn the two habits that prevent it.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(*) if (en) y = a;  // latch` | `process (all) begin y <= '0'; if en = '1' then y <= a; end if; end process;` |

## Concepts

- If a combinational process does not assign an output on every path, the tool must hold the old value — that is a latch.
- Default assignments at the top of the process make every path complete.
- `when others` in a `case` is not optional for synthesizable code, even when you think it is unreachable.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write the latch-inducing version, synthesize it (topic 10) and find the latch in the netlist report.
2. Add a `default` generic that sets the reset value of every output, and remove it to see the difference.
