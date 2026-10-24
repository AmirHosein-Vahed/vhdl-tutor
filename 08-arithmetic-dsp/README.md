# 08-arithmetic-dsp — Arithmetic and DSP

**Status:** 0/4 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

Signed arithmetic, fixed point, pipelining and saturation. The place where VHDL's numeric packages either make your life easy or produce results that are wrong by exactly one bit.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `$signed(a) >>> 2` | `shift_right(signed(a), 2)  -- arithmetic` |
| `logic signed [15:0] x;  // Q1.15 by convention` | `signal x : sfixed(0 downto -15);` |
| `(a*b) >> 15` | `resize(a * b, sfixed(0 downto -15))` |
| `always @(posedge clk) begin v1 <= v; d1 <= d; end` | `process (clk) begin if rising_edge(clk) then v1 <= v; d1 <= d; end if; end process;` |
| `y = (sum > MAX) ? MAX : sum;` | `if sum > MAX then y <= MAX; else y <= sum; end if;` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Signed vs unsigned gotchas](01-signed-vs-unsigned-gotchas/README.md) | Reproduce the classic bugs — width truncation, sign extension, mixed-type comparison — and fix each one deliberately. | planned |
| 02 | [Fixed point](02-fixed-point/README.md) | Represent a Q1.7 number, multiply two of them, and keep the binary point where you expect it. | planned |
| 03 | [Pipelining and registered math](03-pipelining-and-registered-math/README.md) | Turn a multi-level combinational datapath into a pipelined one with a valid chain, and measure the latency. | planned |
| 04 | [Saturation and a FIR filter](04-saturation-and-fir/README.md) | Implement saturating arithmetic and use it in a small FIR filter built from shift registers and constants. | planned |

## After this topic you can

- Mix signed and unsigned without silent truncation
- Implement a fixed-point multiply with known scaling
- Pipeline a datapath and keep it correct

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-08-arithmetic-dsp
```
