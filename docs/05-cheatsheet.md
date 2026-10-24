# 05 — Cheat sheet

One page, no prose. Everything below is VHDL-2008 and compiles with
`ghdl --std=08`.

---

## Context clause

```vhdl
library ieee;
use ieee.std_logic_1164.all;   -- std_logic, std_logic_vector, rising_edge
use ieee.numeric_std.all;      -- unsigned, signed, to_integer, resize
use ieee.fixed_pkg.all;        -- ufixed, sfixed (topic 08)
use ieee.math_real.all;        -- sin, cos, log2 at elaboration time
use std.textio.all;            -- file I/O
use work.my_pkg.all;           -- project types and constants
```

## Entity and architecture

```vhdl
entity name is
  generic (
    W : positive := 8;
    INIT : std_logic_vector(7 downto 0) := x"00"
  );
  port (
    clk : in  std_logic;
    d   : in  std_logic_vector(W - 1 downto 0);
    q   : out std_logic_vector(W - 1 downto 0)
  );
end entity name;

architecture rtl of name is
  signal r : std_logic_vector(W - 1 downto 0) := INIT;
begin
  q <= r;
end architecture rtl;
```

## Instantiation

```vhdl
u1 : entity work.name
  generic map (W => 16)
  port map (clk => clk, d => d, q => q);

-- component form (VHDL-93, needs a component declaration)
u2 : component name
  generic map (W => 8)
  port map (clk => clk, d => d, q => q);
```

## Signals, variables, constants, types

```vhdl
signal s : std_logic := '0';
variable v : integer;                    -- inside a process/procedure
constant C : integer := 42;
type state_t is (IDLE, RUN, DONE);       -- enumeration
type mem_t is array (0 to 255) of std_logic_vector(7 downto 0);
type rec_t is record
  data  : std_logic_vector(31 downto 0);
  valid : std_logic;
end record;
subtype byte_t is std_logic_vector(7 downto 0);
```

## Assignment

```vhdl
s <= a and b;          -- signal: scheduled, takes effect after a delta
v := a and b;          -- variable: immediate
s <= d after 5 ns;     -- simulation only, never synthesizable
```

## Concurrent statements

```vhdl
y <= a and b;
y <= b when sel = '1' else a;                       -- conditional
with sel select y <=                                 -- selected
  a when "00",
  b when "01",
  c when others;

gen : for i in 0 to W - 1 generate                   -- replication
  y(i) <= a(i) xor b(i);
end generate;

gen_if : if USE_PIPE generate
  -- ...
end generate;
```

## Process

```vhdl
process (all)                     -- combinational, VHDL-2008
begin
  y <= '0';
  if en = '1' then
    y <= a;
  end if;
end process;

process (clk)                     -- synchronous reset
begin
  if rising_edge(clk) then
    if rst = '1' then
      q <= (others => '0');
    elsif en = '1' then
      q <= d;
    end if;
  end if;
end process;

process (clk, rst_n)              -- asynchronous reset, active low
begin
  if rst_n = '0' then
    q <= (others => '0');
  elsif rising_edge(clk) then
    q <= d;
  end if;
end process;
```

## Control flow

```vhdl
if a = '1' then ... elsif b = '1' then ... else ... end if;

case sel is
  when "00" => y <= a;
  when "01" => y <= b;
  when others => y <= (others => '0');
end case;

case? sel is                     -- matching case: '-' is don't care
  when "0-" => y <= a;
  when others => y <= b;
end case?;
```

## Loops and waits

```vhdl
for i in 0 to 7 loop ... end loop;
while cond loop ... end loop;

wait for 10 ns;
wait until rising_edge(clk);
wait on a, b;
wait;                            -- forever; ends a stimulus process
```

## Numeric conversions

```vhdl
unsigned(slv)                 signed(slv)
std_logic_vector(u)           std_logic_vector(s)
to_integer(u)                 to_integer(s)
to_unsigned(5, 8)             to_signed(-5, 8)
resize(u, 16)                 resize(s, 16)      -- zero/sign extend
u + 1                         s - 1
shift_left(u, 2)              shift_right(s, 2)  -- arithmetic for signed
rotate_left(u, 1)             u sll 1            -- older operator form
```

## Literals

```vhdl
'1'                -- std_logic
"1010"             -- string literal, std_logic_vector
x"AF"              -- hex, std_logic_vector
B"1010"            -- binary
16#AF#             -- based integer literal
1_000_000          -- underscores ignored
1 ns               -- physical literal (time)
```

## Attributes

```vhdl
clk'event            rising_edge(clk)
s'stable             'image, 'value
v'range              -- 0 to 7 (or 7 downto 0)
v'reverse_range
v'left  v'right  v'high  v'low  v'length
state_t'pos(RUN)     state_t'val(1)
```

## Assertions and reports

```vhdl
assert cond report "message" severity note;
report "message" severity warning;
std.env.finish;      -- clean end (VHDL-2008)
std.env.finish(1);   -- non-zero status
```

## Testbench skeleton

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity dut_tb is
end entity dut_tb;

architecture sim of dut_tb is
  constant CLK_PERIOD : time := 10 ns;
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
begin
  clk <= not clk after CLK_PERIOD / 2;

  dut : entity work.dut
    port map (clk => clk, rst => rst);

  stimulus : process
  begin
    tick(clk);
    rst <= '0';
    -- drive, `tick(clk)`, `check_eq(...)`
    summary("dut_tb");
    wait;
  end process;
end architecture sim;
```

## Make targets

```bash
make            # analyze + elaborate + run
make wave       # + build/<top>.ghw and open a viewer
make vcd        # + build/<top>.vcd
make synth      # yosys + ghdl plugin
make clean
make RUN_ARGS="-gWIDTH=16" TOP=other_tb STD=93
```

## GHDL by hand

```bash
ghdl -a --std=08 --workdir=build file.vhd
ghdl -e --std=08 --workdir=build top
ghdl -r --std=08 --workdir=build top --assert-level=error --stop-time=1ms
ghdl -r --std=08 --workdir=build top --wave=build/top.ghw
ghdl --clean --workdir=build
ghdl --remove --workdir=build
```
