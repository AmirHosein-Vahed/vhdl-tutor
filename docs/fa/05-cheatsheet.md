# ۰۵ — برگهٔ تقلب

یک صفحه، بدون حاشیه. همهٔ کدهای زیر VHDL-2008 هستند و با
`ghdl --std=08` کامپایل می‌شوند.

---

## بند زمینه

```vhdl
library ieee;
use ieee.std_logic_1164.all;   -- std_logic، std_logic_vector، rising_edge
use ieee.numeric_std.all;      -- unsigned، signed، to_integer، resize
use ieee.fixed_pkg.all;        -- ufixed، sfixed (موضوع ۰۸)
use ieee.math_real.all;        -- sin، cos، log2 در زمان بسط
use std.textio.all;            -- ورودی/خروجی فایل
use work.my_pkg.all;           -- انواع و ثابت‌های پروژه
```

## موجودیت و معماری

```vhdl
entity name is
  generic (
    W    : positive := 8;
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

## نمونه‌سازی

```vhdl
u1 : entity work.name
  generic map (W => 16)
  port map (clk => clk, d => d, q => q);

-- شکل کامپوننتی (VHDL-93، نیازمند اعلان کامپوننت)
u2 : component name
  generic map (W => 8)
  port map (clk => clk, d => d, q => q);
```

## سیگنال، متغیر، ثابت، نوع

```vhdl
signal s : std_logic := '0';
variable v : integer;                    -- درون فرایند یا رویه
constant C : integer := 42;
type state_t is (IDLE, RUN, DONE);       -- شمارشی
type mem_t is array (0 to 255) of std_logic_vector(7 downto 0);
type rec_t is record
  data  : std_logic_vector(31 downto 0);
  valid : std_logic;
end record;
subtype byte_t is std_logic_vector(7 downto 0);
```

## انتساب

```vhdl
s <= a and b;          -- سیگنال: زمان‌بندی‌شده، پس از یک دلتا اثر می‌کند
v := a and b;          -- متغیر: فوری
s <= d after 5 ns;     -- فقط شبیه‌سازی؛ هرگز سنتزپذیر نیست
```

## دستورهای هم‌زمان

```vhdl
y <= a and b;
y <= b when sel = '1' else a;                       -- شرطی
with sel select y <=                                 -- انتخابی
  a when "00",
  b when "01",
  c when others;

gen : for i in 0 to W - 1 generate                   -- تکرار
  y(i) <= a(i) xor b(i);
end generate;

gen_if : if USE_PIPE generate
  -- ...
end generate;
```

## فرایند

```vhdl
process (all)                     -- ترکیبی، VHDL-2008
begin
  y <= '0';
  if en = '1' then
    y <= a;
  end if;
end process;

process (clk)                     -- ریست هم‌زمان
begin
  if rising_edge(clk) then
    if rst = '1' then
      q <= (others => '0');
    elsif en = '1' then
      q <= d;
    end if;
  end if;
end process;

process (clk, rst_n)              -- ریست ناهم‌زمان، فعال‌پایین
begin
  if rst_n = '0' then
    q <= (others => '0');
  elsif rising_edge(clk) then
    q <= d;
  end if;
end process;
```

## کنترل جریان

```vhdl
if a = '1' then ... elsif b = '1' then ... else ... end if;

case sel is
  when "00" => y <= a;
  when "01" => y <= b;
  when others => y <= (others => '0');
end case;

case? sel is                     -- تطبیق‌دهنده: '-' یعنی بی‌اهمیت
  when "0-" => y <= a;
  when others => y <= b;
end case?;
```

## حلقه و انتظار

```vhdl
for i in 0 to 7 loop ... end loop;
while cond loop ... end loop;

wait for 10 ns;
wait until rising_edge(clk);
wait on a, b;
wait;                            -- همیشه؛ پایان فرایند محرک
```

## تبدیل‌های عددی

```vhdl
unsigned(slv)                 signed(slv)
std_logic_vector(u)           std_logic_vector(s)
to_integer(u)                 to_integer(s)
to_unsigned(5, 8)             to_signed(-5, 8)
resize(u, 16)                 resize(s, 16)      -- گسترش صفر/علامت
u + 1                         s - 1
shift_left(u, 2)              shift_right(s, 2)  -- حسابی برای signed
rotate_left(u, 1)             u sll 1            -- شکل قدیمی عملگر
```

## لیترال‌ها

```vhdl
'1'                -- std_logic
"1010"             -- رشته؛ std_logic_vector
x"AF"              -- هگز؛ std_logic_vector
B"1010"            -- دودویی
16#AF#             -- لیترال مبنایی عدد صحیح
1_000_000          -- زیرخط نادیده گرفته می‌شود
1 ns               -- لیترال فیزیکی (زمان)
```

## ویژگی‌ها

```vhdl
clk'event            rising_edge(clk)
s'stable             'image، 'value
v'range              -- 0 to 7 (یا 7 downto 0)
v'reverse_range
v'left  v'right  v'high  v'low  v'length
state_t'pos(RUN)     state_t'val(1)
```

## ادعا و گزارش

```vhdl
assert cond report "message" severity note;
report "message" severity warning;
std.env.finish;      -- پایان تمیز (VHDL-2008)
std.env.finish(1);   -- وضعیت غیرصفر
```

## اسکلت بستر آزمون

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
    -- محرک، tick(clk)، check_eq(...)
    summary("dut_tb");
    wait;
  end process;
end architecture sim;
```

## اهداف make

```bash
make            # تحلیل + بسط + اجرا
make wave       # به‌همراه build/<top>.ghw و باز کردن نمایشگر
make vcd        # به‌همراه build/<top>.vcd
make synth      # Yosys و افزونهٔ GHDL
make clean
make RUN_ARGS="-gWIDTH=16" TOP=other_tb STD=93
```

## GHDL دستی

```bash
ghdl -a --std=08 --workdir=build file.vhd
ghdl -e --std=08 --workdir=build top
ghdl -r --std=08 --workdir=build top --assert-level=error --stop-time=1ms
ghdl -r --std=08 --workdir=build top --wave=build/top.ghw
ghdl --clean --workdir=build
ghdl --remove --workdir=build
```
