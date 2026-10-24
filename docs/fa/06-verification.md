# ۰۶ — راستی‌آزمایی

بستر آزمونی که مقدارها را برای خواندن انسان چاپ می‌کند، یک نمایش است نه آزمون.
این دوره از درس ۰۰ بستر آزمون خودبررسی به کار می‌برد و این سند الگو و
چارچوب‌هایی را توضیح می‌دهد که بعداً می‌توانی به آن‌ها مهاجرت کنی.

---

## کمینهٔ بستر آزمون سالم

چهار فرایند مستقل، با یک ساعت مشترک:

```vhdl
architecture sim of fifo_tb is
  constant CLK_PERIOD : time := 10 ns;
  constant TIMEOUT    : time := 10 us;
  signal clk   : std_logic := '0';
  signal rst   : std_logic := '1';
  signal done  : boolean := false;
begin

  clk <= not clk after CLK_PERIOD / 2;      -- ۱. ساعت

  dut : entity work.fifo port map (...);    -- ۲. DUT

  stimulus : process                        -- ۳. ریست، محرک و بررسی
  begin
    tick(clk, 2);
    rst <= '0';
    -- محرک، tick، بررسی
    done <= true;
    summary("fifo_tb");
    wait;
  end process;

  watchdog : process                        -- ۴. تایم‌اوت
  begin
    wait for TIMEOUT;
    report "timeout: the testbench did not finish" severity failure;
  end process;

end architecture sim;
```

VHDL شکل `wait until a or timeout` ندارد، پس نگهبان معمولاً یک فرایند جدا با
`wait for` است. شبیه‌سازی با `std.env.finish` در `summary` تمام می‌شود، بنابراین
نگهبان فقط در معلق‌شدن واقعی فعال می‌شود — دقیقاً همان‌جا که لازم است.

---

## بستهٔ کمکی

`common/vhdl/tb_utils.vhd` به‌طور خودکار در هر درس کامپایل می‌شود.

```vhdl
check(condition, "message");
check_eq(actual, expected, "message");     -- سربارگذاری برای std_logic،
                                           -- std_logic_vector، unsigned،
                                           -- signed، integer، boolean
tick(clk);                                 -- یک لبهٔ بالارونده
tick(clk, 8);                              -- هشت لبه
summary("name");                           -- PASS/FAIL و std.env.finish
```

تصمیم‌های طراحی که ارزش کپی‌کردن دارند:

- شکست‌های تکی `severity warning` هستند، پس اجرا **همهٔ** شکست‌ها را گزارش
  می‌کند، نه فقط اولی را.
- خلاصه `severity failure` است، پس `--assert-level=error` کد خروج غیرصفر می‌دهد.
- شمارنده‌ها در یک نوع حفاظت‌شده درون بدنهٔ بسته‌اند. نه متغیر جهانی نشت می‌کند
  و نه پارامتر دست‌به‌دست می‌شود.
- هر بررسی مقدار انتظاری و واقعی را چاپ می‌کند. پیام شکست باید برای اشکال‌زدایی
  بدون باز کردن شکل موج کافی باشد.

---

## الگوهای بستر آزمون

### محرک روی لبهٔ پایین‌رونده

```vhdl
process
begin
  wait until falling_edge(clk);
  d <= next_value;          -- پیش از لبهٔ بالاروندهٔ بعدی پایدار است
end process;
```

این کار مسابقه میان محرک و نمونه‌برداری DUT را حذف می‌کند. روش دیگر — محرک روی
لبهٔ بالا و `wait for 1 ns` — کار می‌کند اما قصد را پنهان می‌کند.

### طراحی‌های کوچک، به‌صورت کامل

اگر فضای ورودی کمتر از حدود ۱۶ بیت است، روی همه‌اش حلقه بزن:

```vhdl
for i in 0 to 255 loop
  a <= std_logic_vector(to_unsigned(i, 8));
  wait for 1 ns;
  check_eq(y, f(i), "exhaustive i=" & integer'image(i));
end loop;
```

### آزمون تصادفی

```vhdl
use ieee.math_real.all;

impure function rand_slv(width : positive) return std_logic_vector is
  variable r : real;
begin
  uniform(seed1, seed2, r);
  return std_logic_vector(to_unsigned(integer(r * 2.0**width), width));
end function;
```

دانه را در شروع اجرا چاپ کن تا هر شکست همیشه قابل بازتولید باشد. موضوع ۱۱ بستهٔ
`RandomPkg` از OSVVM را نشان می‌دهد که از تصادفی دستی بهتر است.

### جدول مرجع (scoreboard)

خروجی‌های انتظاری را هم‌زمان با دادن ورودی در صف/آرایه ذخیره کن و وقتی خروجی
ظاهر شد (که ممکن است N چرخه بعد باشد) مقایسه کن. تنها راه آزمون طراحی خط
لوله‌ای بدون تکرار منطقش در بستر آزمون همین است.

### بردار از فایل

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

مسیر فایل نسبت به پوشه‌ای است که شبیه‌ساز در آن اجرا می‌شود؛ `make` آن را پوشهٔ
درس قرار می‌دهد.

### مدل کارکردی گذرگاه

پروتکل را در رویه‌ها بپیچ تا بستر آزمون مثل یک نقشهٔ آزمون خوانده شود:

```vhdl
procedure uart_send(signal tx : out std_logic;
                    constant baud : time;
                    constant byte : std_logic_vector(7 downto 0));
```

موضوع ۰۵/۰۵ همین را می‌سازد.

---

## چارچوب‌ها

دوره به هیچ‌کدام نیاز ندارد، اما پروژهٔ واقعی از یکی از این‌ها استفاده می‌کند.

### VUnit

اجراکنندهٔ پایتونی برای بسترهای VHDL/Verilog. یک شبیه‌سازی، چند آزمون نام‌دار،
اجرای موازی و خروجی JUnit برای CI.

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
python run.py            # همهٔ موارد آزمون
python run.py --list     # نام‌ها
```

موارد آزمون با `test_runner`/`test_case` از کتابخانهٔ VHDL و VUnit ثبت می‌شوند؛
چارچوب جنریک‌ها را تنظیم می‌کند و بستر آزمون را برای هر مورد یک بار اجرا می‌کند.

### OSVVM

کتابخانهٔ راستی‌آزمایی کاملاً VHDL: تصادفی مقید، پوشش کارکردی، جدول مرجع،
رکورد تراکنش و سیستم ساخت.

```vhdl
library osvvm;
context osvvm.OsvvmContext;
...
RandInt(seed, 0, 255);
```

قوت: نه پایتون، نه API مخصوص شبیه‌ساز. هزینه: کد تکراری بیشتر و منحنی یادگیری
خودش.

### cocotb

کوروتین‌های پایتونی که VHDL تو را از طریق VPI/VHPI می‌رانند. وقتی منطق آزمون به
کتابخانه‌های پایتون (numpy، scipy، مدل مرجع) نیاز دارد خوب است و وقتی یک‌زبانه
می‌خواهی کمتر.

```python
@cocotb.test()
async def test_add(dut):
    dut.a.value = 3
    dut.b.value = 4
    await RisingEdge(dut.clk)
    assert int(dut.y.value) == 7
```

### PSL

ادعاهای زمانی که در توضیحات نوشته می‌شوند و GHDL با `-fpsl` بررسی می‌کند:

```vhdl
-- psl default clock is rising_edge(clk);
-- psl assert always req -> eventually[1 to 4] ack;
```

چون توضیح‌اند، سنتز و ابزارهای دیگر نادیده‌شان می‌گیرند. موضوع ۱۱/۰۳ نحو و
گزینه‌های GHDL را پوشش می‌دهد.

---

## «راستی‌آزمایی‌شده» در این دوره یعنی چه

یک درس وقتی تمام است که:

1. هر خروجی در هر بردار بررسی شود — نه فقط مسیر خوش‌بینانه.
2. مقدارهای مرزی پوشش داده شوند: تمام‌صفر، تمام‌یک، بیشینه، کمینه، چرخش.
3. ورودی‌های نامعتبر حداقل یک بار آزموده شوند.
4. اگر RTL را به یک نسخهٔ غلط محتمل تغییر دهیم، بستر آزمون شکست بخورد.
5. هیچ آزمونی معلق نماند و کل اجرا در چند ثانیه تمام شود.

مورد ۴ همانی است که مردم رد می‌کنند: موقتاً RTL را خراب کن (یک بیت را معکوس کن)
و مطمئن شو بستر آزمون می‌گیرد. آزمونی که روی طراحی خراب قبول می‌شود از نبود آزمون
بدتر است.

---

بعدی: [۰۷ — سنتز](07-synthesis.md)
