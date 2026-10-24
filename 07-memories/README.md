# 07-memories — Memories

**Status:** 0/4 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

RAM, ROM and FIFO — the structures that decide whether your design fits in block RAM or eats logic cells. The VHDL template matters as much as the algorithm.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `initial $readmemh(...)` | `constant ROM : rom_t := (...);  -- elaboration time` |
| `reg [7:0] mem [0:255];` | `type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);` |
| `always @(posedge clk) begin mem[wa] <= wd; rd <= mem[ra]; end` | `process (clk) begin if rising_edge(clk) then mem(wa) <= wd; rd <= mem(ra); end if; end process;` |
| `if (wptr - rptr == DEPTH) full = 1;` | `if wptr(wptr'high) /= rptr(rptr'high) and wptr(wptr'high-1 downto 0) = rptr(rptr'high-1 downto 0) then` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [ROM and initialized constants](01-rom-and-constants/README.md) | Initialize a ROM from a function or a file, and understand why a ROM must not have a reset. | planned |
| 02 | [Single-port RAM](02-single-port-ram/README.md) | Write the canonical synchronous-write, synchronous-read RAM that infers block RAM on every FPGA. | planned |
| 03 | [Simple dual-port RAM](03-simple-dual-port-ram/README.md) | Add a second port for simultaneous read and write, and handle the collision case explicitly. | planned |
| 04 | [Synchronous FIFO](04-synchronous-fifo/README.md) | Build a circular-buffer FIFO with full/empty flags and the pointer-width trick that avoids ambiguity. | planned |

## After this topic you can

- Write an inference-friendly RAM template
- Initialize a ROM without a reset
- Build a synchronous FIFO with correct flags

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-07-memories
```
