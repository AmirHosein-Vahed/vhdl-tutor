# 01 — مالتی‌پلکسرها: when، با، case

**وضعیت:** انجام‌شده · **موضوع:** [02-combinational — منطق ترکیبی](../README.fa.md) · [English](README.md)

> **آماده.** در این پوشه `make` را اجرا کنید. این دستور `mux_advanced` را ساخته، بستر آزمون خودبررسی را اجرا می‌کند.

## هدف

ساخت مالتی‌پلکسرهای ۲ به ۱ و ۴ به ۱ با کنترل enable در هر سه سبک (`when/else`، `with/select` و process `case`).

## از وریلاگ به VHDL

| وریلاگ / SystemVerilog | VHDL |
|---|---|
| `assign y = s ? b : a;` | `y <= b when s = '1' else a;` |
| `casez (sel)` | `with sel select` |

## مفاهیم

- زنجیره‌های `when/else` منطق اولویت‌دار هستند؛ ترتیب مهم است.
- `with ... select` یک انتخاب موازی است.
- `case` داخل process توصیف سخت‌افزار ترکیبی است.

## فایل‌ها

| فایل | هدف |
|---|---|
| `src/mux_advanced.vhd` | مالتی‌پلکسر ۴ به ۱ با کنترل enable در ۳ سبک |
| `tb/mux_advanced_tb.vhd` | بستر آزمون خودبررسی |

## اجرا

```bash
make        # تحلیل، بسط و اجرای بستر آزمون خودبررسی
make wave   # همان، به‌همراه باز کردن شکل موج
make clean  # پاک کردن build/
```
