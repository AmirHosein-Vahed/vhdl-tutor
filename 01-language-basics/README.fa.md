# 01-language-basics — مبانی زبان

**وضعیت:** ۶ از ۶ درس نوشته شده · [نقشهٔ راه](../../README.fa.md) · [English](README.md)

## چرا این موضوع

بخش‌هایی از VHDL که معادل وریلاگی ندارند یا معادلشان گمراه‌کننده است: نوع‌دهی قوی، سیگنال‌های حل‌شده، بازهٔ آرایه و چرخهٔ دلتا. موضوع کوتاه است، اما همهٔ ادامه به آن وابسته است.

## از وریلاگ به VHDL

| Verilog / SystemVerilog | VHDL |
|---|---|
| `logic [7:0] x;` | `signal x : std_logic_vector(7 downto 0);` |
| `4'b1010` | `"1010"  (or 10, or x"A")` |
| `always @(*) begin t = a; y = t; end  // blocking` | `process (all) variable t : std_logic; begin t := a; y <= t; end process;` |
| `[7:0] v;  // fixed direction` | `signal v : std_logic_vector(7 downto 0);` |
| `v[3:0]` | `v(3 downto 0)` |
| `a + b  // width = max(len(a), len(b))` | `unsigned(a) + unsigned(b)  -- result width = max` |
| `$signed(a)` | `signed(a)` |
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |

## درس‌ها

| # | درس | هدف | وضعیت |
|---|---|---|---|
| 01 | [انواع و لیترال‌ها](01-types-and-literals/README.fa.md) | دیگر std_logic را مثل logic وریلاگ نبین. ۹ مقدار آن، انواع عددی و همهٔ شکل‌های لیترال را یاد بگیر. | نوشته‌شده |
| 02 | [سیگنال در برابر متغیر](02-signals-vs-variables/README.fa.md) | مهم‌ترین تفاوت معنایی با تقسیم blocking/non-blocking وریلاگ را بفهم: سیگنال زمان‌بندی می‌شود، متغیر بلافاصله اثر می‌کند. | نوشته‌شده |
| 03 | [downto و to و اندیس‌گذاری](03-downto-vs-to-and-indexing/README.fa.md) | بازهٔ آرایه‌ها را بار اول درست بنویس و دیگر حدس نزن کدام بیت پرارزش است. | نوشته‌شده |
| 04 | [std_logic_vector و numeric_std](04-std_logic_vector-and-numeric_std/README.fa.md) | بدون std_logic_arith حساب کن. تبدیل‌ها، قواعد عرض و دلیل اینکه ترکیب کتابخانه‌ها کارخانهٔ باگ است را یاد بگیر. | نوشته‌شده |
| 05 | [دستورهای هم‌زمان و ترتیبی](05-concurrent-vs-sequential/README.fa.md) | ببین که y <= a and b; خودش یک فرایند است و when و with و case و if توصیف‌های جایگزینِ یک سخت‌افزارند. | نوشته‌شده |
| 06 | [ویژگی‌ها و جنریک‌ها](06-attributes-and-generics-intro/README.fa.md) | به‌جای اعداد جادویی از ویژگی‌ها و به‌جای ویرایش ثابت‌ها پیش از هر ساخت از جنریک‌ها استفاده کن. | نوشته‌شده |

## پس از این موضوع می‌توانی

- خواندن و نوشتن هر اعلان VHDL بدون حدس‌زدن
- تبدیل آگاهانه میان std_logic_vector و unsigned و signed و integer
- پیش‌بینی اینکه انتساب سیگنال کِی اثر می‌کند

## پیش‌نیاز

ابتدا موضوع قبلی را تمام کن؛ هر موضوع مستقیماً روی قبلی ساخته می‌شود.
درس اول کل زنجیرهٔ ابزار را هم توضیح می‌دهد، بنابراین پیش‌زمینهٔ VHDL لازم نیست.

## اجرای همهٔ درس‌های این موضوع

```bash
make test-01-language-basics
```
