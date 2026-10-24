# 03 — Style guide

The course follows these rules consistently. They are not the only defensible
style, but consistency is what makes 54 folders readable as one book.

---

## Files and names

| Thing | Convention | Example |
|---|---|---|
| Source file | matches the entity name | `and2.vhd` holds `entity and2` |
| Testbench file | `<dut>_tb.vhd` | `and2_tb.vhd` |
| Entity / architecture | `snake_case` | `entity sync_fifo`, `architecture rtl` |
| Signals, ports, variables | `snake_case` | `wr_en`, `data_valid` |
| Constants, generics | `UPPER_SNAKE` | `DATA_WIDTH`, `CLK_HZ` |
| Types | `_t` suffix | `state_t`, `mem_t` |
| Architecture names | `rtl`, `sim`, `behavioural` | `architecture rtl of fifo` |
| Enum literals | `UPPER_SNAKE` | `IDLE`, `WAIT_ACK` |
| Labels | named, short | `dut : entity work.foo`, `gen_bits : for i in ...` |
| Active-low signals | `_n` suffix | `rst_n` |

Keywords are lowercase (`entity`, `architecture`, `begin`, `end`, `process`).
VHDL is case-insensitive; the convention is about scanability, and lowercase
keywords separate them visually from your identifiers.

One entity per file, file name equal to the entity. Testbenches live in `tb/`
and are never synthesized.

---

## Layout

Two-space indent, no tabs. One port per line, aligned, with the direction
grouped:

```vhdl
entity spi_master is
  generic (
    CLK_HZ : positive := 50_000_000;
    SCLK_HZ : positive := 1_000_000
  );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    start   : in  std_logic;
    din     : in  std_logic_vector(7 downto 0);
    dout    : out std_logic_vector(7 downto 0);
    busy    : out std_logic;
    sclk    : out std_logic;
    mosi    : out std_logic;
    miso    : in  std_logic;
    cs_n    : out std_logic
  );
end entity spi_master;
```

Blank lines separate: context clause, entity, architecture declarative part,
each process, each concurrent assignment group.

Comments explain *why*. The code already says what.

```vhdl
-- Bad: increments the counter
cnt <= cnt + 1;

-- Good: the terminal count is N-1 because the comparator runs before the
-- register updates; see the waveform in README.
cnt <= cnt + 1;
```

---

## The rules that prevent bugs

### 1. `ieee.numeric_std` only

Never `std_logic_arith`, `std_logic_unsigned`, or `std_logic_signed`. They are
not IEEE standards, they conflict with `numeric_std`, and they teach implicit
conversions that VHDL deliberately removed.

```vhdl
use ieee.numeric_std.all;   -- always
```

### 2. Use `rising_edge`, not `clk'event`

```vhdl
if rising_edge(clk) then          -- good
if clk'event and clk = '1' then   -- works, but says less
```

`rising_edge` also handles `'H'`/`'L'` correctly and signals intent to synthesis.

### 3. Named association, always

```vhdl
u_alu : entity work.alu
  port map (clk => clk, a => a, b => b, op => op, y => y);
```

Positional association breaks silently when someone adds a port.

### 4. Defaults before branches in combinational processes

```vhdl
process (all)
begin
  y <= '0';                 -- default: no latch on any path
  if en = '1' then
    y <= a;
  end if;
end process;
```

### 5. `process (all)` instead of a hand-written sensitivity list

VHDL-2008. It cannot drift out of sync with the body. If your tool is stuck on
VHDL-93, list every read signal — and expect to get it wrong once.

### 6. One clock per process, one process per clock

```vhdl
process (clk)
begin
  if rising_edge(clk) then
    -- registers only, no combinational next-state logic mixed in
  end if;
end process;
```

Do not put two different clocks in one process. Do not put a `rising_edge` and
a `falling_edge` in one process.

### 7. Reset first, then enable

```vhdl
if rising_edge(clk) then
  if rst = '1' then
    q <= (others => '0');
  elsif en = '1' then
    q <= d;
  end if;
end if;
```

### 8. Signals cross process boundaries; variables stay inside

Variables are fine for intermediate values inside one process. If another
process needs the value, it is a signal.

### 9. No gated clocks, no `buffer` ports

Use a clock enable. `buffer` hides a real design problem and is not universally
supported.

### 10. Initial values are a convenience, not a reset

```vhdl
signal cnt : unsigned(7 downto 0) := (others => '0');  -- FPGA/sim only
```

Acceptable in FPGA-targeted code where the tool initializes registers. Never
rely on it for ASIC code, and never let it replace a documented reset.

---

## Testbenches

- Name: `<dut>_tb`, architecture `sim`.
- No ports.
- One process for the clock, one for reset/stimulus, one watchdog — independent.
- Every check via `work.tb_utils` (`check`, `check_eq`), never a bare `report`
  that a human must read.
- End with `summary("name")`, and never leave a process without a final `wait;`.
- Parameterize the clock and data width with generics even if you only use one
  value today.

```vhdl
architecture sim of fifo_tb is
  constant CLK_PERIOD : time := 10 ns;
  signal clk : std_logic := '0';
  ...
begin
  clk <= not clk after CLK_PERIOD / 2;
  ...
  stimulus : process
  begin
    ...
    summary("fifo_tb");
    wait;
  end process;
end architecture sim;
```

---

## What a finished lesson contains

1. `src/` with one entity per file and an architecture named `rtl`.
2. `tb/` with a self-checking testbench.
3. `README.md` and `README.fa.md` with the same structure.
4. Every task in the README either implemented or explicitly left as an
   exercise — never a stale claim.
5. `make` green from a clean checkout.

---

Next: [04 — Pitfalls](04-pitfalls.md)
