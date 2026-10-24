# 02 — Single-port RAM

**Status:** planned · **Topic:** [07-memories — Memories](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Write the canonical synchronous-write, synchronous-read RAM that infers block RAM on every FPGA.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `reg [7:0] mem [0:255];` | `type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);` |

## Concepts

- `if rising_edge(clk) then if we then mem(addr) <= d; q <= mem(addr); end if;` — one clock, one port.
- Read-during-write returns the old value in simulation unless you specify otherwise; document it.
- An asynchronous read (`q <= mem(addr)` outside the clock) infers distributed RAM, not block RAM.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Write and read 16 addresses, then dump the memory content and compare with expectations.
2. Change the read to asynchronous and compare the synthesized resource usage.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
