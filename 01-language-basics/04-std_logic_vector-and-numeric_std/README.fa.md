# 04 — std_logic_vector و numeric_std

**وضعیت:** برنامه‌ریزی‌شده · **موضوع:** [01-language-basics — مبانی زبان](../README.fa.md) · [English](README.md)

> این درس هنوز نوشته نشده است. هدف، مفاهیم و تمرین‌های زیر قرارداد آن هستند
> و کد هنگام تکمیل موضوع اضافه می‌شود.

## هدف

بدون std_logic_arith حساب کن. تبدیل‌ها، قواعد عرض و دلیل اینکه ترکیب کتابخانه‌ها کارخانهٔ باگ است را یاد بگیر.

## از وریلاگ به VHDL

| Verilog / SystemVerilog | VHDL |
|---|---|
| `a + b  // width = max(len(a), len(b))` | `unsigned(a) + unsigned(b)  -- result width = max` |
| `$signed(a)` | `signed(a)` |

## مفاهیم

- std_logic_vector کیسه‌ای از بیت است؛ unsigned و signed عددی‌اند. تبدیل را صریح انجام بده: unsigned() و signed() و std_logic_vector().
- جمع، نوع عملوند بزرگ‌تر را برمی‌گرداند؛ به هدفی با عرض بیشتر انتساب بده و resize را آگاهانه به کار ببر.
- هرگز از ieee.std_logic_arith یا std_logic_unsigned استفاده نکن — فقط ieee.numeric_std.

## اجرا

```bash
make        # تحلیل، بسط و اجرای بستر آزمون خودبررسی
make wave   # همان، به‌همراه باز کردن شکل موج در Surfer یا GTKWave
make clean  # پاک کردن build/
```

## تمرین‌ها

1. دو مقدار ۸ بیتی unsigned را در نتیجهٔ ۹ بیتی جمع کن و نشان بده رقم نقلی حفظ می‌شود.
2. یک جمع اشباعی بساز: در سرریز به‌جای چرخش، ۲۵۵ برگردان.
