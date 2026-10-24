# ۰۳ — راهنمای سبک

دوره این قواعد را پیوسته رعایت می‌کند. تنها سبک قابل دفاع نیستند، اما همین
پیوستگی است که ۵۴ پوشه را مثل یک کتاب خواندنی می‌کند.

---

## فایل‌ها و نام‌ها

| چیز | قرارداد | مثال |
|---|---|---|
| فایل سورس | هم‌نام موجودیت | `and2.vhd` شامل `entity and2` |
| فایل بستر آزمون | `<dut>_tb.vhd` | `and2_tb.vhd` |
| موجودیت / معماری | `snake_case` | `entity sync_fifo`، `architecture rtl` |
| سیگنال، درگاه، متغیر | `snake_case` | `wr_en`، `data_valid` |
| ثابت و جنریک | `UPPER_SNAKE` | `DATA_WIDTH`، `CLK_HZ` |
| نوع | پسوند `_t` | `state_t`، `mem_t` |
| نام معماری | `rtl`، `sim`، `behavioural` | `architecture rtl of fifo` |
| لیترال شمارشی | `UPPER_SNAKE` | `IDLE`، `WAIT_ACK` |
| برچسب | نام‌دار و کوتاه | `dut : entity work.foo`، `gen_bits : for i in ...` |
| سیگنال فعال‌پایین | پسوند `_n` | `rst_n` |

کلیدواژه‌ها با حروف کوچک نوشته می‌شوند (`entity`، `architecture`، `begin`،
`end`، `process`). VHDL به بزرگی و کوچکی حساس نیست؛ این قرارداد برای خوانایی است
و کلیدواژه‌ها را از شناسه‌های تو جدا می‌کند.

یک موجودیت در هر فایل، با نام فایل برابر موجودیت. بسترهای آزمون در `tb/` هستند
و هرگز سنتز نمی‌شوند.

---

## چیدمان

تورفتگی دو فاصله، بدون tab. هر درگاه یک خط، هم‌تراز، با جهت‌ها گروه‌بندی‌شده:

```vhdl
entity spi_master is
  generic (
    CLK_HZ  : positive := 50_000_000;
    SCLK_HZ : positive := 1_000_000
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    start : in  std_logic;
    din   : in  std_logic_vector(7 downto 0);
    dout  : out std_logic_vector(7 downto 0);
    busy  : out std_logic;
    sclk  : out std_logic;
    mosi  : out std_logic;
    miso  : in  std_logic;
    cs_n  : out std_logic
  );
end entity spi_master;
```

خط خالی این‌ها را جدا می‌کند: بند زمینه، موجودیت، ناحیهٔ اعلان معماری، هر فرایند
و هر گروه انتساب هم‌زمان.

توضیح‌ها *چرا* را می‌گویند. کد خودش *چه* را می‌گوید.

```vhdl
-- بد: شمارنده را یکی زیاد می‌کند
cnt <= cnt + 1;

-- خوب: شمارش پایانی N-1 است چون مقایسه پیش از به‌روزرسانی رجیستر اجرا
-- می‌شود؛ شکل موج README را ببین.
cnt <= cnt + 1;
```

---

## قواعدی که جلوی باگ را می‌گیرند

### ۱. فقط `ieee.numeric_std`

هرگز `std_logic_arith`، `std_logic_unsigned` یا `std_logic_signed`. استاندارد
IEEE نیستند، با `numeric_std` تعارض دارند و تبدیل‌های ضمنی‌ای را آموزش می‌دهند که
VHDL عمداً حذف کرده است.

```vhdl
use ieee.numeric_std.all;   -- همیشه
```

### ۲. `rising_edge`، نه `clk'event`

```vhdl
if rising_edge(clk) then          -- خوب
if clk'event and clk = '1' then   -- کار می‌کند، اما کمتر می‌گوید
```

`rising_edge` مقدارهای `'H'` و `'L'` را هم درست می‌فهمد و قصد را به سنتز منتقل
می‌کند.

### ۳. همیشه اتصال نام‌دار

```vhdl
u_alu : entity work.alu
  port map (clk => clk, a => a, b => b, op => op, y => y);
```

اتصال موقعیتی وقتی کسی درگاهی اضافه کند، بی‌صدا می‌شکند.

### ۴. در فرایند ترکیبی، اول مقدار پیش‌فرض

```vhdl
process (all)
begin
  y <= '0';                 -- پیش‌فرض: در هیچ مسیری لچ نمی‌سازد
  if en = '1' then
    y <= a;
  end if;
end process;
```

### ۵. `process (all)` به‌جای فهرست حساسیت دستی

VHDL-2008. نمی‌تواند از بدنه عقب بماند. اگر ابزارت به VHDL-93 گیر است، هر
سیگنال خوانده‌شده را فهرست کن — و انتظار داشته باش یک بار اشتباه کنی.

### ۶. یک ساعت در هر فرایند، یک فرایند برای هر ساعت

```vhdl
process (clk)
begin
  if rising_edge(clk) then
    -- فقط رجیستر؛ منطق حالت بعد را اینجا مخلوط نکن
  end if;
end process;
```

دو ساعت مختلف را در یک فرایند نگذار. `rising_edge` و `falling_edge` را در یک
فرایند نگذار.

### ۷. اول ریست، بعد فعال‌ساز

```vhdl
if rising_edge(clk) then
  if rst = '1' then
    q <= (others => '0');
  elsif en = '1' then
    q <= d;
  end if;
end if;
```

### ۸. سیگنال از مرز فرایند می‌گذرد؛ متغیر درون آن می‌ماند

متغیر برای مقادیر میانی درون یک فرایند خوب است. اگر فرایند دیگری مقدار را لازم
دارد، سیگنال است.

### ۹. بدون ساعت گیت‌شده و بدون درگاه `buffer`

از فعال‌ساز ساعت استفاده کن. `buffer` یک مشکل واقعی طراحی را پنهان می‌کند و
همه‌جا پشتیبانی نمی‌شود.

### ۱۰. مقدار اولیه راحتی است، نه ریست

```vhdl
signal cnt : unsigned(7 downto 0) := (others => '0');  -- فقط FPGA/شبیه‌سازی
```

در کد FPGA که ابزار رجیسترها را مقداردهی می‌کند قابل قبول است. در ASIC هرگز به
آن تکیه نکن و هرگز جایش را به ریست مستند نده.

---

## بسترهای آزمون

- نام: `<dut>_tb`، معماری `sim`.
- بدون درگاه.
- یک فرایند برای ساعت، یکی برای ریست و محرک، یکی نگهبان — مستقل.
- هر بررسی با `work.tb_utils` (`check`، `check_eq`)، نه `report` خام که انسان
  باید بخواند.
- پایان با `summary("name")`، و هیچ فرایندی بدون `wait;` پایانی رها نشود.
- ساعت و عرض داده را با جنریک پارامتری کن، حتی اگر امروز فقط یک مقدار داری.

```vhdl
architecture sim of fifo_tb is
  constant CLK_PERIOD : time := 10 ns;
  signal clk : std_logic := '0';
  -- ...
begin
  clk <= not clk after CLK_PERIOD / 2;
  -- ...
  stimulus : process
  begin
    -- ...
    summary("fifo_tb");
    wait;
  end process;
end architecture sim;
```

---

## یک درس «تمام‌شده» چه دارد

1. `src/` با یک موجودیت در هر فایل و معماری به نام `rtl`.
2. `tb/` با بستر آزمون خودبررسی.
3. `README.md` و `README.fa.md` با ساختار یکسان.
4. هر تمرین README یا پیاده‌شده یا صریحاً به‌عنوان تمرین گذاشته شده — هیچ ادعای
   کهنه‌ای در کار نیست.
5. `make` سبز از یک checkout تمیز.

---

بعدی: [۰۴ — دام‌ها](04-pitfalls.md)
