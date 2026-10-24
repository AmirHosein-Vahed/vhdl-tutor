# 00 — Coming from Verilog and SystemVerilog

You already know what a register is, what a testbench should do, and why a
combinational loop is bad. This document is only about the differences that
will actually bite you.

---

## Five mental-model changes

1. **Nothing is imported implicitly.** Every file starts with a context clause.
   There is no compilation unit scope, no `include`.

   ```vhdl
   library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;
   ```

2. **Interface and implementation are separate.** An `entity` is the module
   header; an `architecture` is one implementation of it. You can have several
   architectures, selected by a configuration or at instantiation.

3. **`std_logic` is not `logic`.** It is a *resolved* 9-value type. `'U'`
   (uninitialized) and `'X'` (conflict) are first-class and will propagate into
   your outputs, which is a feature: a nondeterministic design fails loudly.

4. **Signal assignment is scheduled, not performed.** `a <= b; c <= a;` in one
   process gives `c` the *old* `a`. Verilog's blocking assignment is VHDL's
   *variable* assignment (`:=`), and using variables in clocked logic is
   usually a mistake.

5. **Widths and types are checked.** `std_logic_vector` is not a number.
   `unsigned` and `signed` are, and they do not mix. This turns a class of
   silent truncation bugs into compile errors, at the cost of conversions.

---

## Translation table

| Verilog / SystemVerilog | VHDL |
|---|---|
| `module m (...); ... endmodule` | `entity m is port (...); end entity;` + `architecture rtl of m is ... begin ... end architecture;` |
| `input`, `output`, `inout` | `in`, `out`, `inout` (plus `buffer`, rarely used) |
| `wire a;` | `signal a : std_logic;` |
| `reg a;` | `signal a : std_logic;` (a register is a signal assigned in a clocked process) |
| `logic [7:0] a;` | `signal a : std_logic_vector(7 downto 0);` |
| `logic signed [15:0] a;` | `signal a : signed(15 downto 0);` |
| `parameter W = 8;` | `generic (W : positive := 8);` |
| `localparam IDLE = 2'd0;` | `type state_t is (IDLE, RUN);` |
| `#(.W(16))` | `generic map (W => 16)` |
| `.a(sig)` | `port map (a => sig)` |
| `assign y = a & b;` | `y <= a and b;` |
| `always @(*)` | concurrent assignments, or `process (all)` |
| `always @(posedge clk)` | `process (clk) begin if rising_edge(clk) then ...` |
| `always @(posedge clk or negedge rst_n)` | `process (clk, rst_n) begin if rst_n = '0' then ... elsif rising_edge(clk) then ...` |
| `always_ff`, `always_comb`, `always_latch` | no direct equivalent; style conventions replace them |
| `begin ... end` | `begin ... end` (named blocks: `label : begin ... end block;`) |
| `if/else` | `if/elsif/else` |
| `case` | `case ... is when ... =>` |
| `casez` | `case?` (VHDL-2008 matching case) |
| `?:` | `when ... else` |
| `{a, b}` | `a & b` |
| `a[7:4]` | `a(7 downto 4)` |
| `a[i +: 4]` | `a(i + 3 downto i)` |
| `$signed(a)` / `$unsigned(a)` | `signed(a)` / `unsigned(a)` |
| `a >>> 2` | `shift_right(a, 2)` on a `signed` value |
| `$clog2(N)` | a `log2` function in a package (not built in) |
| `` `define W 8 `` | `constant W : integer := 8;` in a package |
| `` `include "defs.vh" `` | `use work.defs_pkg.all;` |
| `$display(...)` | `report ... severity note;` |
| `$error(...)` | `report ... severity error;` |
| `$finish` | `std.env.finish;` (VHDL-2008) |
| `#10` | `wait for 10 ns;` |
| `@(posedge clk);` | `wait until rising_edge(clk);` |
| `$dumpfile/$dumpvars` | `ghdl -r ... --wave=out.ghw` (a tool flag, not code) |
| `$readmemh` | `textio` in the testbench, or a constant array in the design |
| `generate for` | `label : for i in 0 to N-1 generate` |
| `generate if` | `label : if COND generate` |
| `function automatic` | `function ... return ...` in a package |
| `task automatic` | `procedure` |
| `struct` | `record` |
| `typedef enum` | `type state_t is (...)` |
| `interface` (SV) | `record` + a package, or individual ports |
| `assert property` (SVA) | PSL in comments: `-- psl assert always ...` |
| `$urandom` | OSVVM `RandomPkg`, or a hand-written LFSR |

---

## The same module, twice

Verilog:

```verilog
module sync_fifo #(parameter W = 8, parameter D = 16) (
  input  logic clk, rst, wr_en, rd_en,
  input  logic [W-1:0] din,
  output logic [W-1:0] dout,
  output logic full, empty
);
  logic [W-1:0] mem [0:D-1];
  logic [$clog2(D)-1:0] wptr, rptr;
  ...
endmodule
```

VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_fifo is
  generic (
    W : positive := 8;
    D : positive := 16                -- must be a power of two
  );
  port (
    clk, rst, wr_en, rd_en : in  std_logic;
    din                    : in  std_logic_vector(W - 1 downto 0);
    dout                   : out std_logic_vector(W - 1 downto 0);
    full, empty            : out std_logic
  );
end entity sync_fifo;

architecture rtl of sync_fifo is
  type mem_t is array (0 to D - 1) of std_logic_vector(W - 1 downto 0);
  signal mem        : mem_t;
  signal wptr, rptr : unsigned(0 to D);   -- one extra bit: full/empty trick
begin
  -- ... see 07-memories/04-synchronous-fifo
end architecture rtl;
```

Notice what is *not* there: no `logic`, no width inference, and the ports have
directions in the declaration rather than in a separate list.

---

## Things VHDL has that Verilog does not

| Feature | Why you might care |
|---|---|
| Configurations | Bind a whole hierarchy to architectures without editing instantiations |
| Records on ports | Bundle `valid`/`data`/`ready`; shorter port maps |
| Resolved subtypes | Multiple drivers resolved by a resolution function you can write |
| Protected types | Object-like shared state in testbenches (VHDL's answer to classes) |
| Conditional analysis | Tool-specific `--` directives; this course uses generics instead |
| Physical types | `time` is a first-class type, not a preprocessor macro |
| Matching case (`case?`) | `'-'` as don't-care in a `case` |
| PSL in comments | Temporal assertions the simulator can check, invisible to synthesis |
| Custom operators | Overload `+`, `=`, `&` for your own types |

(Conditional analysis is technically a tool feature, not the language; the
course avoids it and uses generics instead.)

---

## What you will miss, and the replacement

| Verilog habit | VHDL replacement | Lesson |
|---|---|---|
| macros for widths | `generic` + attributes (`'range`, `'length`) | 01/06 |
| implicit width extension | `resize`, explicit concatenation with `'0'` | 01/04, 08/01 |
| `logic` everywhere | pick `std_logic`, `unsigned`, `signed`, or an enum | 01/01 |
| one-process FSMs | two/three-process style | 04/01 |
| `initial` blocks | signal initial values (simulation/FPGA only), or a reset | 03/02 |
| `always_comb` guarantees | `process (all)` + defaults to avoid latches | 02/05 |
| `$display` debugging | `report` with severity, plus a real waveform | 00/03 |
| `force`/`release` | not standard; redesign the testbench | 05/05 |
| SV interfaces / classes | records, protected types, access types (rare) | 06/04 |
| preprocessor | packages + generics | 06/03 |

---

## Suggested order for a Verilog user

1. `00-hello-world` — the loop, and the delta cycle (30 min).
2. `01-language-basics` — types and conversions; this is the real tax.
3. `02`, `03`, `04` — skim the concepts, focus on idiom and testbenches.
4. `05` — do not skip; this is where VHDL pays you back.
5. Everything else in order; `06` and `09` are where VHDL differs most.

---

Next: [01 — Install](01-install.md) · [Cheat sheet](05-cheatsheet.md) ·
[Pitfalls](04-pitfalls.md)
