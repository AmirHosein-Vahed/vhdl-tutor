# 04 — wait forms and timeouts

**Status:** planned · **Topic:** [05-testbenches — Testbenches](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Use all four `wait` forms correctly and add a watchdog so a broken DUT fails in seconds instead of hanging CI.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `#1000 $finish;` | `wait for 1 us;  std.env.finish;` |

## Concepts

- `wait for`, `wait until`, `wait on`, `wait;` — only `wait;` is allowed outside a process.
- A watchdog is `wait for MAX_TIME; report "timeout" severity failure;` in a parallel process.
- `--stop-time` on the GHDL command line is the backstop when the TB itself is broken.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Add a watchdog with a generic timeout to every testbench in the course and verify it triggers.
2. Replace a `wait for 10 ns` with `wait until rising_edge(clk)` and explain the changed behaviour.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
