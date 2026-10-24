# 06-modularity — Modularity

**Status:** 0/5 lessons written · [Roadmap](../../README.md) · [فارسی](README.fa.md)

## Why this topic

How VHDL structures large designs: components, configurations, packages, records and generate. This is where the language does things Verilog simply cannot.

## Coming from Verilog

| Verilog / SystemVerilog | VHDL |
|---|---|
| `foo u (.a(a), .y(y));` | `u : entity work.foo port map (a => a, y => y);` |
| ``ifdef SIM / `else` | `configuration sim_cfg of top is ...` |
| ``include "defs.vh"` | `use work.defs_pkg.all;` |
| `typedef struct packed {...} axi_t;` | `type axi_t is record data : std_logic_vector(31 downto 0); valid : std_logic; end record;` |
| `generate for (genvar i=0; i<N; i++)` | `gen : for i in 0 to N-1 generate` |
| `if (WIDTH > 8) begin ... end` | `gen_if : if WIDTH > 8 generate` |

## Lessons

| # | Lesson | Goal | Status |
|---|---|---|---|
| 01 | [Components vs direct instantiation](01-components-vs-direct-instantiation/README.md) | Instantiate the same entity both ways and understand the binding step that only components have. | planned |
| 02 | [Configurations](02-configurations/README.md) | Use a configuration declaration to bind entities to architectures once, instead of editing every instantiation. | planned |
| 03 | [Packages and constants](03-packages-and-constants/README.md) | Stop copying `constant` definitions: put shared types, constants and functions in a package and `use` it everywhere. | planned |
| 04 | [Records and bundled ports](04-records-and-bundled-ports/README.md) | Bundle related signals into a record so port maps stop being twenty lines of individual names. | planned |
| 05 | [Generate and conditional logic](05-generate-and-conditional-logic/README.md) | Use `for generate` and `if generate` to build parameterized structure, and understand that they elaborate, not execute. | planned |

## After this topic you can

- Instantiate other entities correctly and know when to use components
- Share types and constants through packages
- Generate repeated structure from a generic

## Prerequisites

Finish the previous topic first; each one builds directly on the last.
The very first lesson also explains the toolchain, so no prior VHDL is assumed.

## Run everything in this topic

```bash
make test-06-modularity
```
