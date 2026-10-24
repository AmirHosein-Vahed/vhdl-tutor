# 06 — Verification

A testbench that prints values for a human to read is a demo, not a test. This
course uses self-checking testbenches from lesson 00, and this document explains
the pattern and the frameworks you can graduate to.

---

## The minimum viable testbench

Four independent processes, one shared clock:

```vhdl
architecture sim of fifo_tb is
  constant CLK_PERIOD : time := 10 ns;
  constant TIMEOUT    : time := 10 us;
  signal clk   : std_logic := '0';
  signal rst   : std_logic := '1';
  signal done  : boolean := false;
begin

  clk <= not clk after CLK_PERIOD / 2;      -- 1. clock

  dut : entity work.fifo port map (...);    -- 2. DUT

  stimulus : process                        -- 3. reset + stimulus + checks
  begin
    tick(clk, 2);
    rst <= '0';
    -- drive, tick, check
    done <= true;
    summary("fifo_tb");
    wait;
  end process;

  watchdog : process                        -- 4. timeout
  begin
    wait until done or TIMEOUT;             -- (see below for a legal form)
    if not done then
      report "timeout" severity failure;
    end if;
    wait;
  end process;

end architecture sim;
```

VHDL has no `wait until a or b` on a timeout, so the watchdog is usually written
as two processes or as:

```vhdl
watchdog : process
begin
  wait for TIMEOUT;
  report "timeout: the testbench did not finish" severity failure;
end process;
```

The simulator exits when `summary` calls `std.env.finish`, so the watchdog only
fires on a real hang — exactly the case you want it for.

---

## The helper package

`common/vhdl/tb_utils.vhd` is compiled into every lesson automatically.

```vhdl
check(condition, "message");
check_eq(actual, expected, "message");     -- overloads: std_logic,
                                           -- std_logic_vector, unsigned,
                                           -- signed, integer, boolean
tick(clk);                                 -- wait one rising edge
tick(clk, 8);                              -- wait eight
summary("name");                           -- PASS/FAIL + std.env.finish
```

Design decisions worth copying:

- Individual failures are `severity warning`, so a run reports **all** failures
  instead of stopping at the first.
- The summary is `severity failure`, so `--assert-level=error` gives a non-zero
  exit code.
- Counters live in a protected type inside the package body. No global variable
  leakage, no parameter passing.
- Every check prints expected and actual values. A failure message must be
  enough to debug without opening the waveform.

---

## Testbench patterns

### Drive on the falling edge

```vhdl
process
begin
  wait until falling_edge(clk);
  d <= next_value;          -- stable before the next rising edge
end process;
```

This avoids races between stimulus and DUT sampling. The alternative — drive on
the rising edge and `wait for 1 ns` — works but hides the intent.

### Exhaustive small designs

If the input space is under ~16 bits, loop over all of it:

```vhdl
for i in 0 to 255 loop
  a <= std_logic_vector(to_unsigned(i, 8));
  wait for 1 ns;
  check_eq(y, f(i), "exhaustive i=" & integer'image(i));
end loop;
```

### Randomized testing

```vhdl
use ieee.math_real.all;

impure function rand_slv(width : positive) return std_logic_vector is
  variable r : real;
begin
  uniform(seed1, seed2, r);
  return std_logic_vector(to_unsigned(integer(r * 2.0**width), width));
end function;
```

Print the seed at the start of the run so a failure is reproducible forever.
Topic 11 shows OSVVM's `RandomPkg`, which is better than hand-rolled randoms.

### Scoreboard

Store expected outputs in a queue/array as you drive inputs, compare when the
output appears (which may be N cycles later). This is the only way to test a
pipelined design without duplicating its logic in the testbench.

### File-driven vectors

```vhdl
use std.textio.all;
use ieee.std_logic_textio.all;
...
file f : text open read_mode is "vectors.txt";
variable l : line;
variable v : std_logic_vector(7 downto 0);
...
while not endfile(f) loop
  readline(f, l);
  read(l, v);
  d <= v; tick(clk);
end loop;
```

The file path is relative to the directory where the simulator runs, which
`make` sets to the lesson folder.

### Bus functional models

Wrap a protocol in procedures so the testbench reads like a test plan:

```vhdl
procedure uart_send(signal tx : out std_logic;
                    constant baud : time;
                    constant byte : std_logic_vector(7 downto 0));
```

Topic 05/05 builds this.

---

## Frameworks

The course does not require any of these, but they are what a real project uses.

### VUnit

Python-driven runner for VHDL/Verilog testbenches. One simulation, many named
tests, parallel runs, JUnit output for CI.

```python
# run.py
from vunit import VUnit
vu = VUnit.from_argv()
lib = vu.add_library("work")
lib.add_source_files("src/*.vhd")
lib.add_source_files("tb/*.vhd")
vu.main()
```

```bash
python run.py            # runs every test case
python run.py --list     # names
```

Test cases are registered with `test_runner`/`test_case` from the VUnit VHDL
library; the framework sets generics and calls your testbench once per case.

### OSVVM

A VHDL-only verification library: constrained random, functional coverage,
scoreboards, transaction records, and a build system.

```vhdl
library osvvm;
context osvvm.OsvvmContext;
...
RandInt(seed, 0, 255);
```

Strength: no Python, no simulator-specific API. Cost: more boilerplate and a
learning curve of its own.

### cocotb

Python coroutines driving your VHDL through VPI/VHPI. Good when the test logic
needs Python libraries (numpy, scipy, reference models), less good when you want
one language.

```python
@cocotb.test()
async def test_add(dut):
    dut.a.value = 3
    dut.b.value = 4
    await RisingEdge(dut.clk)
    assert int(dut.y.value) == 7
```

### PSL

Temporal assertions written in comments, checked by GHDL with `-fpsl`:

```vhdl
-- psl default clock is rising_edge(clk);
-- psl assert always req -> eventually[1 to 4] ack;
```

Because they are comments, synthesis and other tools ignore them. Topic 11/03
covers the syntax and the GHDL flags.

---

## What "verified" means here

For this course, a lesson is done when:

1. Every output is checked on every vector — not just the happy path.
2. Boundary values are covered: all-zeros, all-ones, max, min, rollover.
3. Invalid inputs are exercised at least once.
4. The testbench fails if the RTL is changed to a plausible wrong version.
5. No test can hang, and the whole run takes under a few seconds.

Point 4 is the one people skip: temporarily break the RTL (invert one bit) and
confirm the testbench catches it. A test that passes on a broken design is
worse than no test.

---

Next: [07 — Synthesis](07-synthesis.md)
