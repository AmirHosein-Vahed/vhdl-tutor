# 04 — Pitfalls

These are the mistakes that actually happen, in rough order of frequency. Each
one has a wrong version, why it is wrong, and the fix.

---

## 1. Doing arithmetic on `std_logic_vector`

```vhdl
signal a, b, y : std_logic_vector(7 downto 0);
y <= a + b;                       -- does not compile
```

`std_logic_vector` is an array of nine-value bits, not a number. `+` is not
defined for it.

```vhdl
use ieee.numeric_std.all;
y <= std_logic_vector(unsigned(a) + unsigned(b));   -- 8-bit result: carry lost
```

If the carry matters, widen the result first:

```vhdl
signal sum : unsigned(8 downto 0);
sum <= ('0' & unsigned(a)) + ('0' & unsigned(b));
```

---

## 2. The accidental latch

```vhdl
process (all)
begin
  if en = '1' then
    y <= a;              -- y is not assigned when en = '0'
  end if;
end process;
```

The tool must hold `y` when `en = '0'`, so it builds a latch. Synthesis warns;
simulation happily runs, which is why this survives until hardware.

```vhdl
process (all)
begin
  y <= '0';              -- every path assigns y
  if en = '1' then
    y <= a;
  end if;
end process;
```

A `case` without `when others` is the same bug in disguise.

---

## 3. A sensitivity list that does not match the body

```vhdl
process (a)              -- b is missing
begin
  y <= a and b;
end process;
```

Simulation ignores changes on `b`; synthesis ignores the list and builds the
correct gate. The two disagree, and you debug a ghost.

Use `process (all)` in VHDL-2008. If you must use VHDL-93, list every signal
read by the process, including ones read inside procedures.

A clocked process is different: only `clk` (and `rst` for asynchronous reset)
belongs in the list. Listing data signals there is also a bug.

---

## 4. Signal vs variable in one process

```vhdl
process (clk)
begin
  if rising_edge(clk) then
    a <= b;
    c <= a;              -- c gets the OLD a
  end if;
end process;
```

Both right-hand sides are evaluated with the pre-edge values; both updates
happen in the same delta. This is usually what you want for a shift register,
and usually *not* what you want for software-style sequential code.

```vhdl
process (clk)
  variable tmp : std_logic;
begin
  if rising_edge(clk) then
    tmp := b;
    c   <= tmp;          -- sees the new value
  end if;
end process;
```

Variables in clocked processes are legal and occasionally useful, but they
hide registers from readers. Prefer signals; use variables for intermediate
combinational values only.

---

## 5. Delaying by "just waiting a delta"

```vhdl
a <= '1';
wait for 0 ns;          -- does NOT guarantee a has updated
b <= a;
```

`wait for 0 ns` is a delta-cycle yield, and the number of deltas a signal
update needs is not something to rely on. If you need ordering in a testbench,
wait for real time (`wait for 1 ns`) or restructure the stimulus.

---

## 6. Unbounded integers

```vhdl
signal count : integer;         -- 32-bit signed, wraps at 2**31-1
count <= count + 1;             -- wraps silently
```

Prefer a constrained subtype or an unsigned vector:

```vhdl
signal count : integer range 0 to 4095;
signal count : unsigned(11 downto 0);
```

The range is checked at elaboration and (for signals) at run time in
simulation, turning a wrap into an error.

---

## 7. Comparing across types

```vhdl
if slv = 5 then ...                       -- illegal
if unsigned(slv) = to_unsigned(5, 8) then -- legal, explicit
if slv = std_logic_vector(to_unsigned(5, 8)) then  -- legal, verbose
```

There is no implicit conversion. That is the point, but it makes testbenches
noisy. Helpers in `tb_utils` (`check_eq` for `unsigned` and `integer`) exist to
keep this out of your face.

---

## 8. Losing bits in addition and multiplication

```vhdl
signal a, b : unsigned(7 downto 0);
signal y    : unsigned(7 downto 0);
y <= a * b;                    -- 8 bits of a 16-bit product: truncated
```

Multiplication of `W`-bit operands needs `2W` bits. Addition needs `W+1` if the
carry matters. The compiler will not warn; the result is simply wrong.

```vhdl
signal p : unsigned(15 downto 0);
p <= a * b;
```

For signed values, remember `resize` sign-extends and slicing does not:

```vhdl
y <= resize(signed(a), 16);            -- sign extension
y <= signed(a) & x"00";                -- zero extension, probably a bug
```

---

## 9. `'U'` propagating everywhere

`'U'` means "uninitialized". A `std_logic` signal that is never driven stays
`'U'`, and any gate it touches becomes `'U'`.

Common causes:

- the testbench never assigns an input,
- a port map connection is missing or misspelled (named association prevents
  this),
- a signal is declared but only assigned inside an `if` that never fires,
- a reset was never applied.

This is a feature: a `'U'` on an output in the first 100 ns is telling you the
design is incomplete, not that the simulator is broken.

---

## 10. Gating a clock

```vhdl
gated_clk <= clk and en;        -- do not do this
```

It creates a new clock domain, breaks timing analysis, and glitches. Use a
clock enable:

```vhdl
process (clk)
begin
  if rising_edge(clk) then
    if en = '1' then
      q <= d;
    end if;
  end if;
end process;
```

---

## 11. Treating an initial value as a reset

```vhdl
signal state : state_t := IDLE;
```

This works in simulation and on most FPGAs (the tool initializes the register
at configuration). It does not work in ASIC synthesis, and it does not recover
from a glitch that corrupts the state. Use a real reset for anything that
matters, and keep the initial value only as a simulation convenience.

Related: asynchronous reset release is asynchronous. If the reset deasserts
near a clock edge, the first register can go metastable. A two-flop reset
synchronizer fixes it; topic 03/02 covers this.

---

## 12. Simulation-only code in synthesizable RTL

```vhdl
y <= a after 5 ns;          -- ignored by synthesis
```

Also simulation-only: `wait for`, `textio` in RTL, `report` used for behaviour,
`real` arithmetic, division by a non-constant, file I/O.

The rule: if it needs a clock or a delay to behave, it belongs in the
testbench, not in `src/`.

---

## 13. A testbench that can hang

```vhdl
wait until ack = '1';       -- forever, if the DUT is broken
```

Every testbench in this course has both:

- a watchdog: a parallel process that reports a failure after `TIMEOUT`,
- `--stop-time` on the simulator command line, as the last line of defence.

```vhdl
watchdog : process
begin
  wait for TIMEOUT;
  report "timeout: ack never arrived" severity failure;
end process;
```

---

## 14. Using `bit` because it looks simpler

`bit` has two values and no resolution. It cannot express a bus conflict, an
undriven net, or a tristate. Use `std_logic` for every signal that touches a
port or a bus. `bit`/`bit_vector` are fine for pure internal constants, and
even then `std_logic` costs nothing.

---

## 15. Forgetting that `=` on arrays compares length too

```vhdl
signal a : std_logic_vector(7 downto 0);
constant C : std_logic_vector(3 downto 0) := x"F";
if a = C then ...            -- always false: 8 bits vs 4 bits
```

VHDL does not zero-extend for you. This is a common testbench bug when a
literal is shorter than the signal. Qualify and size it:

```vhdl
if a = x"0F" then ...
```

---

Next: [05 — Cheat sheet](05-cheatsheet.md)
