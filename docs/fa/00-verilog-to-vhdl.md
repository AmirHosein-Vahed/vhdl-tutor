# ۰۰ — از وریلاگ و SystemVerilog به VHDL

تو می‌دانی رجیستر چیست، بستر آزمون چه باید بکند و چرا حلقهٔ ترکیبی بد است.
این سند فقط دربارهٔ تفاوت‌هایی است که واقعاً اذیتت می‌کنند.

---

## پنج تغییر ذهنی

1. **هیچ چیز به‌صورت خودکار وارد نمی‌شود.** هر فایل با بند زمینه شروع می‌شود.
   نه دامنهٔ واحد کامپایل داریم و نه `include`.

   ```vhdl
   library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;
   ```

2. **رابط و پیاده‌سازی جدا هستند.** `entity` سرصفحهٔ ماژول است و
   `architecture` یک پیاده‌سازی از آن. می‌توانی چند معماری داشته باشی و با
   پیکربندی یا هنگام نمونه‌سازی انتخابشان کنی.

3. **`std_logic` همان `logic` نیست.** یک نوع ۹مقداریِ *حل‌شده* است. `'U'`
   (مقدارنگرفته) و `'X'` (تعارض) شهروند درجه‌یک‌اند و به خروجی نشت می‌کنند؛
   این یک مزیت است: طراحی نامعین با صدای بلند شکست می‌خورد.

4. **انتساب سیگنال زمان‌بندی می‌شود، نه اجرا.** در یک فرایند،
   `a <= b; c <= a;` مقدار *قبلی* `a` را به `c` می‌دهد. انتساب blocking
   وریلاگ معادل انتساب *متغیر* (`:=`) در VHDL است و استفاده از متغیر در منطق
   ساعت‌دار معمولاً اشتباه است.

5. **عرض و نوع بررسی می‌شوند.** `std_logic_vector` عدد نیست. `unsigned` و
   `signed` عدد هستند و با هم مخلوط نمی‌شوند. این یک دسته باگ برش بی‌صدا را به
   خطای کامپایل تبدیل می‌کند، به قیمت تبدیل‌های صریح.

---

## جدول ترجمه

| وریلاگ / SystemVerilog | VHDL |
|---|---|
| `module m (...); ... endmodule` | `entity m is port (...); end entity;` + `architecture rtl of m is ... begin ... end architecture;` |
| `input`، `output`، `inout` | `in`، `out`، `inout` (و `buffer` که به‌ندرت استفاده می‌شود) |
| `wire a;` | `signal a : std_logic;` |
| `reg a;` | `signal a : std_logic;` (رجیستر یعنی سیگنالی که در فرایند ساعت‌دار مقدار می‌گیرد) |
| `logic [7:0] a;` | `signal a : std_logic_vector(7 downto 0);` |
| `logic signed [15:0] a;` | `signal a : signed(15 downto 0);` |
| `parameter W = 8;` | `generic (W : positive := 8);` |
| `localparam IDLE = 2'd0;` | `type state_t is (IDLE, RUN);` |
| `#(.W(16))` | `generic map (W => 16)` |
| `.a(sig)` | `port map (a => sig)` |
| `assign y = a & b;` | `y <= a and b;` |
| `always @(*)` | انتساب‌های هم‌زمان یا `process (all)` |
| `always @(posedge clk)` | `process (clk) begin if rising_edge(clk) then ...` |
| `always @(posedge clk or negedge rst_n)` | `process (clk, rst_n) begin if rst_n = '0' then ... elsif rising_edge(clk) then ...` |
| `always_ff`، `always_comb`، `always_latch` | معادل مستقیم ندارد؛ قراردادهای سبک جایشان را می‌گیرند |
| `begin ... end` | `begin ... end` (بلوک نام‌دار: `label : begin ... end block;`) |
| `if/else` | `if/elsif/else` |
| `case` | `case ... is when ... =>` |
| `casez` | `case?` (تطبیق‌دهنده، VHDL-2008) |
| `?:` | `when ... else` |
| `{a, b}` | `a & b` |
| `a[7:4]` | `a(7 downto 4)` |
| `a[i +: 4]` | `a(i + 3 downto i)` |
| `$signed(a)` / `$unsigned(a)` | `signed(a)` / `unsigned(a)` |
| `a >>> 2` | `shift_right(a, 2)` روی مقدار `signed` |
| `$clog2(N)` | تابع `log2` در یک بسته (درون زبان نیست) |
| `` `define W 8 `` | `constant W : integer := 8;` در یک بسته |
| `` `include "defs.vh" `` | `use work.defs_pkg.all;` |
| `$display(...)` | `report ... severity note;` |
| `$error(...)` | `report ... severity error;` |
| `$finish` | `std.env.finish;` (VHDL-2008) |
| `#10` | `wait for 10 ns;` |
| `@(posedge clk);` | `wait until rising_edge(clk);` |
| `$dumpfile/$dumpvars` | `ghdl -r ... --wave=out.ghw` (گزینهٔ ابزار، نه کد) |
| `$readmemh` | `textio` در بستر آزمون، یا آرایهٔ ثابت در طراحی |
| `generate for` | `label : for i in 0 to N-1 generate` |
| `generate if` | `label : if COND generate` |
| `function automatic` | `function ... return ...` در بسته |
| `task automatic` | `procedure` |
| `struct` | `record` |
| `typedef enum` | `type state_t is (...)` |
| `interface` (SV) | `record` + یک بسته، یا درگاه‌های جدا |
| `assert property` (SVA) | PSL در توضیحات: `-- psl assert always ...` |
| `$urandom` | بستهٔ `RandomPkg` از OSVVM یا یک LFSR دستی |

---

## همان ماژول، دو بار

وریلاگ:

```verilog
module sync_fifo #(parameter W = 8, parameter D = 16) (
  input  logic clk, rst, wr_en, rd_en,
  input  logic [W-1:0] din,
  output logic [W-1:0] dout,
  output logic full, empty
);
  logic [W-1:0] mem [0:D-1];
  logic [$clog2(D)-1:0] wptr, rptr;
  // ...
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
    D : positive := 16                -- باید توانی از دو باشد
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
  signal wptr, rptr : unsigned(0 to D);   -- یک بیت اضافه: ترفند پر/خالی
begin
  -- ... در 07-memories/04-synchronous-fifo
end architecture rtl;
```

توجه کن چه چیزی *نیست*: نه `logic`، نه استنتاج عرض، و جهت درگاه‌ها همان‌جا در
اعلان آمده، نه در فهرستی جدا.

---

## چیزهایی که VHDL دارد و وریلاگ ندارد

| ویژگی | چرا مهم است |
|---|---|
| پیکربندی‌ها | اتصال کل سلسله‌مراتب به معماری‌ها بدون ویرایش نمونه‌ها |
| رکورد در درگاه | دسته‌کردن `valid`/`data`/`ready`؛ نگاشت درگاه کوتاه‌تر |
| زیرنوع‌های حل‌شده | چند راه‌انداز با تابع حل که خودت می‌نویسی |
| انواع حفاظت‌شده | حالت مشترک شیءگونه در بستر آزمون (پاسخ VHDL به کلاس) |
| تحلیل شرطی | دستورهای `--` مخصوص ابزار؛ این دوره به‌جایش از جنریک استفاده می‌کند |
| انواع فیزیکی | `time` یک نوع درجه‌یک است، نه ماکروی پیش‌پردازنده |
| تطبیق در `case` | `'-'` به‌عنوان بی‌اهمیت |
| PSL در توضیحات | ادعاهای زمانی که شبیه‌ساز بررسی می‌کند و سنتز نادیده می‌گیرد |
| عملگرهای سفارشی | سربارگذاری `+`، `=`، `&` برای انواع خودت |

---

## چیزهایی که کم می‌آوری و جایگزینشان

| عادت وریلاگی | جایگزین VHDL | درس |
|---|---|---|
| ماکرو برای عرض | `generic` + ویژگی‌ها (`'range`، `'length`) | 01/06 |
| گسترش عرض خودکار | `resize` یا الحاق صریح با `'0'` | 01/04، 08/01 |
| `logic` همه‌جا | انتخاب `std_logic` یا `unsigned`/`signed` یا شمارشی | 01/01 |
| ماشین حالت تک‌فرایندی | سبک دو/سه‌فرایندی | 04/01 |
| بلوک `initial` | مقدار اولیهٔ سیگنال (فقط شبیه‌سازی/FPGA) یا ریست | 03/02 |
| تضمین‌های `always_comb` | `process (all)` + مقدار پیش‌فرض برای پرهیز از لچ | 02/05 |
| اشکال‌زدایی با `$display` | `report` با سطح، به‌همراه شکل موج واقعی | 00/03 |
| `force`/`release` | استاندارد نیست؛ بستر آزمون را بازطراحی کن | 05/05 |
| اینترفیس/کلاس SV | رکورد، نوع حفاظت‌شده، نوع دسترسی (کم‌کاربرد) | 06/04 |
| پیش‌پردازنده | بسته‌ها + جنریک‌ها | 06/03 |

---

## ترتیب پیشنهادی برای کسی که وریلاگ می‌داند

1. `00-hello-world` — چرخهٔ کار و چرخهٔ دلتا (۳۰ دقیقه).
2. `01-language-basics` — انواع و تبدیل‌ها؛ همان هزینهٔ واقعی است.
3. `02`، `03`، `04` — مفاهیم را سریع رد کن، روی اصطلاحات و بستر آزمون تمرکز کن.
4. `05` — رد نکن؛ اینجاست که VHDL جبران می‌کند.
5. بقیه به‌ترتیب؛ `06` و `09` بیشترین تفاوت را دارند.

---

بعدی: [۰۱ — نصب](01-install.md) · [برگهٔ تقلب](05-cheatsheet.md) ·
[دام‌ها](04-pitfalls.md)
