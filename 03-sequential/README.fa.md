# 03-sequential — منطق ترتیبی

**وضعیت:** 0 از 5 درس نوشته شده · [نقشهٔ راه](../../README.fa.md) · [English](README.md)

## چرا این موضوع

ساعت، ریست و حالت. عادت‌های وریلاگ اینجا هم کار می‌کنند، اما VHDL تو را مجبور می‌کند فرایند ساعت‌دار را از ترکیبی جدا کنی — این یک مزیت است، نه هزینه.

## از وریلاگ به VHDL

| Verilog / SystemVerilog | VHDL |
|---|---|
| `always @(posedge clk) q <= d;` | `process (clk) begin if rising_edge(clk) then q <= d; end if; end process;` |
| `always @(posedge clk or negedge rst_n)` | `process (clk, rst_n) begin if rst_n = '0' then ... elsif rising_edge(clk) then ...` |
| `always @(posedge clk) if (we) mem[addr] <= d;` | `process (clk) begin if rising_edge(clk) then if we = '1' then mem(addr) <= d; end if; end if; end process;` |
| `counter <= counter + 1;` | `count <= count + 1;  -- unsigned` |
| `if (count == N-1)` | `if count = N - 1 then` |
| `q <= {q[6:0], d};` | `q <= q(6 downto 0) & d;` |

## درس‌ها

| # | درس | هدف | وضعیت |
|---|---|---|---|
| 01 | [نخستین فرایند ساعت‌دار](01-first-clocked-process/README.fa.md) | یک جمع‌کنندهٔ ترکیبی را با یک if rising_edge(clk) به رجیستر تبدیل کن و بفهم چرا چیز دیگری جای آن ندارد. | برنامه‌ریزی‌شده |
| 02 | [سبک‌های ریست](02-reset-styles/README.fa.md) | ریست هم‌زمان و ناهم‌زمان، فعال‌پایین و فعال‌بالا را مقایسه کن و برای هر طراحی تصمیم بگیر، نه با کپی یک الگو. | برنامه‌ریزی‌شده |
| 03 | [رجیسترها و فعال‌ساز ساعت](03-registers-and-clock-enable/README.fa.md) | یک فایل رجیستر بساز و یاد بگیر چرا enable یک if است و هرگز ساعت گیت‌شده نیست. | برنامه‌ریزی‌شده |
| 04 | [شمارنده‌ها](04-counters/README.fa.md) | شمارندهٔ بالا/پایین/بارگذاری با شمارش پایانی بنویس و آگاهانه بین integer range و unsigned یکی را انتخاب کن. | برنامه‌ریزی‌شده |
| 05 | [شیفت‌رجیسترها](05-shift-registers/README.fa.md) | شیفت SISO و SIPO و PISO و سپس یک LFSR را با عملگرهای شیفتی که از وریلاگ می‌شناسی پیاده کن. | برنامه‌ریزی‌شده |

## پس از این موضوع می‌توانی

- نوشتن فرایند ساعت‌دار تمیز در هر بار
- انتخاب آگاهانهٔ سبک ریست
- ساخت شمارنده و شیفت‌رجیستر با سنتز قابل پیش‌بینی

## پیش‌نیاز

ابتدا موضوع قبلی را تمام کن؛ هر موضوع مستقیماً روی قبلی ساخته می‌شود.
درس اول کل زنجیرهٔ ابزار را هم توضیح می‌دهد، بنابراین پیش‌زمینهٔ VHDL لازم نیست.

## اجرای همهٔ درس‌های این موضوع

```bash
make test-03-sequential
```
