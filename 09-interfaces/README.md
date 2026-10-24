# 09-interfaces — Interfaces and protocols

**Status:** 0/4 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Real designs are mostly plumbing. Learn the handshake that most modern buses are built on, then three protocols you can debug with a cheap logic analyzer, and finally the one thing that breaks every beginner: crossing clock domains.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `assign ready = !full;` | `ready <= '1' when count < DEPTH else '0';` |
| `if (!rx) state <= START;` | `if rx = '0' then state <= START; end if;` |
| `spi_sclk <= ~spi_sclk;  // in a divider` | `sclk <= not sclk after PERIOD/2;` |
| `(* ASYNC_REG = "true" *) reg s1, s2;` | `attribute async_reg : string;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [The valid/ready handshake](01-valid-ready-handshake/README.md) | Implement the three-state handshake and a skid buffer that can absorb one beat when the receiver stalls. | planned |
| 02 | [UART receiver](02-uart-receiver/README.md) | Receive what topic 04 transmits: start-bit detection, mid-bit sampling, framing and parity errors. | planned |
| 03 | [SPI master](03-spi-master/README.md) | Build a mode-0 SPI master with a clock divider, chip select, and simultaneous transmit/receive. | planned |
| 04 | [Clock domain crossing](04-clock-domain-crossing/README.md) | Cross a signal between two unrelated clocks — correctly for single bits, and honestly about what needs a FIFO. | planned |

## After this topic you can

- Implement a correct valid/ready interface with backpressure
- Build and decode a UART and an SPI master
- Cross a clock domain safely or know when you cannot

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-09-interfaces
```
