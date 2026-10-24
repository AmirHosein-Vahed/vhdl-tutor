# 03-sequential — Sequential logic

**Status:** 0/5 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Clocks, resets and state. Verilog habits transfer here, but VHDL forces you to separate the clocked process from the combinational one — which is a feature, not a tax.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) q <= d;` | `process (clk) begin if rising_edge(clk) then q <= d; end if; end process;` |
| `always @(posedge clk or negedge rst_n)` | `process (clk, rst_n) begin if rst_n = '0' then ... elsif rising_edge(clk) then ...` |
| `always @(posedge clk) if (we) mem[addr] <= d;` | `process (clk) begin if rising_edge(clk) then if we = '1' then mem(addr) <= d; end if; end if; end process;` |
| `counter <= counter + 1;` | `count <= count + 1;  -- unsigned` |
| `if (count == N-1)` | `if count = N - 1 then` |
| `q <= {q[6:0], d};` | `q <= q(6 downto 0) & d;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [The first clocked process](01-first-clocked-process/README.md) | Turn a combinational adder into a register with one `if rising_edge(clk)` — and understand why nothing else belongs in that `if`. | planned |
| 02 | [Reset styles](02-reset-styles/README.md) | Compare synchronous and asynchronous reset, active-low and active-high, and decide per design instead of copying a template. | planned |
| 03 | [Registers and clock enables](03-registers-and-clock-enable/README.md) | Build a register file and learn why an enable is an `if`, never a gated clock. | planned |
| 04 | [Counters](04-counters/README.md) | Write up/down/load counters with terminal count, and choose between `integer range` and `unsigned` on purpose. | planned |
| 05 | [Shift registers](05-shift-registers/README.md) | Implement SISO, SIPO and PISO shifts, then an LFSR, using the shift operators you already know from Verilog. | planned |

## After this topic you can

- Write a clean clocked process every time
- Choose reset style deliberately
- Build counters and shift registers that synthesize as expected

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-03-sequential
```
