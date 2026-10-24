# 00-hello-world — سلام، دنیا

**وضعیت:** 3 از 3 درس نوشته شده · [نقشهٔ راه](../../README.fa.md) · [English](README.md)

## چرا این موضوع

کوچک‌ترین چرخهٔ ممکن: یک طراحی بنویس، یک بستر آزمون بنویس که آن را بررسی کند، اجرا کن و شکل موج را ببین. همهٔ ادامهٔ دوره همین چرخه است، فقط منطقِ وسط آن بزرگ‌تر می‌شود.

## از وریلاگ به VHDL

| Verilog / SystemVerilog | VHDL |
|---|---|
| `module and2 (input a, b, output y);<br>  assign y = a & b;<br>endmodule` | `entity and2 is<br>  port (a, b : in  std_logic;<br>        y    : out std_logic);<br>end entity;<br><br>architecture rtl of and2 is<br>begin<br>  y <= a and b;<br>end architecture;` |
| `parameter W = 8` | `generic (W : positive := 8)` |
| `always @(posedge clk)` | `process (clk) begin if rising_edge(clk) then ...` |
| `$dumpfile("x.vcd"); $dumpvars;` | `--wave=x.ghw  (a simulator flag, not VHDL)` |

## درس‌ها

| # | درس | هدف | وضعیت |
|---|---|---|---|
| 01 | [نخستین موجودیت و بستر آزمون](01-first-entity-and-testbench/README.fa.md) | کوچک‌ترین طراحی کامل VHDL را بنویس — یک گیت AND دو ورودی — به‌همراه یک بستر آزمون خودبررسی، و هر دو را با GHDL اجرا کن. | نوشته‌شده |
| 02 | [بازنویسی یک ماژول وریلاگ در VHDL](02-verilog-module-vs-vhdl-entity/README.fa.md) | ماژولی را که از قبل می‌فهمی ترجمه کن و از تفاوت‌ها سه چیز را یاد بگیر که VHDL صریح بیان می‌کند: بندهای زمینه، جدایی موجودیت از معماری، و انواع حل‌شده. | نوشته‌شده |
| 03 | [شکل موج و چرخهٔ ساخت](03-waveforms-and-the-build-loop/README.fa.md) | GHDL را دستی اجرا کن (تحلیل، بسط، اجرا)، سپس از طریق make، و شکل موج حاصل را بخوان — از جمله چرخه‌های دلتا که هرگز روی محور نانوثانیه دیده نمی‌شوند. | نوشته‌شده |

## پس از این موضوع می‌توانی

- ساخت و شبیه‌سازی یک طراحی با GHDL، بدون نیاز به IDE
- توضیح نقش موجودیت، معماری و بستر آزمون
- تولید و خواندن فایل شکل موج

## اجرای همهٔ درس‌های این موضوع

```bash
make test-00-hello-world
```
