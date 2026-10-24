# 04 — Records and bundled ports

**Status:** planned · **Topic:** [06-modularity — Modularity](../README.md) · [فارسی](README.fa.md)

> **Planned.** The goal, concepts and tasks below are the contract for this
> lesson; the code arrives when this topic is filled in. Feel free to attempt
> the tasks against the patterns from earlier lessons.

## Goal

Bundle related signals into a record so port maps stop being twenty lines of individual names.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `typedef struct packed {...} axi_t;` | `type axi_t is record data : std_logic_vector(31 downto 0); valid : std_logic; end record;` |

## Concepts

- A record type groups fields; `signal bus : axi_t;` then `bus.data`, `bus.valid`.
- Records drastically shorten port maps and make interfaces self-documenting.
- Some synthesis tools struggle with records at top-level ports — keep them internal, flatten at the boundary.

## Run

```bash
make        # analyze + elaborate + run the self-checking testbench
make wave   # same, and open the waveform in Surfer or GTKWave
make clean  # remove build/
```

## Tasks

1. Define a valid/ready record and use it for the handshake module in topic 09.
2. Write a function that converts the record to a flat vector for a top-level port.

## Further reading

- [IEEE 1076-2008](https://ieeexplore.ieee.org/document/4774590) — the language standard (dry, definitive).
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the simulator used throughout this course.
- [VHDL-2008: Just the New Stuff](https://www.elsevier.com/books/vhdl-2008-just-the-new-stuff/ashenden/978-0-12-374249-0) — Ashenden & Lewis.
