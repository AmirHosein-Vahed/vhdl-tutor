# 03 — دیدن شبکه با Yosys

**وضعیت:** برنامه‌ریزی‌شده · **موضوع:** [10-synthesis-awareness — آگاهی از سنتز](../README.fa.md) · [English](README.md)

> این درس هنوز نوشته نشده است. هدف، مفاهیم و تمرین‌های زیر قرارداد آن هستند
> و کد هنگام تکمیل موضوع اضافه می‌شود.

## هدف

از جریان متن‌باز Yosys با افزونهٔ GHDL استفاده کن تا VHDL را به شبکه تبدیل کنی و گزارش سلول‌ها را بخوانی.

## از وریلاگ به VHDL

| Verilog / SystemVerilog | VHDL |
|---|---|
| `quartus_map / vivado synth_design` | `yosys -m ghdl -p '...; synth; stat'` |

## مفاهیم

- عبارت yosys -m ghdl -p 'ghdl --std=08 file.vhd -e top; synth; stat' تمام جریان است.
- ‎write_json به‌همراه netlistsvg نتیجه را رسم می‌کند؛ show هم با Graphviz کار می‌کند.
- هدف synth در Yosys گیت‌های عمومی است، نه FPGA — اعداد سطح تقریبی‌اند، نه نهایی.

## اجرا

```bash
make        # تحلیل، بسط و اجرای بستر آزمون خودبررسی
make wave   # همان، به‌همراه باز کردن شکل موج در Surfer یا GTKWave
make clean  # پاک کردن build/
```

## تمرین‌ها

1. ALU و شمارنده را سنتز کن؛ تعداد سلول هر ماژول را در جدولی ثبت کن.
2. شبکه را با netlistsvg رسم کن و یک مالتی‌پلکسری را که در درس ۰۲ پیش‌بینی کردی پیدا کن.
