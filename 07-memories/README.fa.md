# 07-memories — حافظه‌ها

**وضعیت:** 0 از 4 درس نوشته شده · [نقشهٔ راه](../../README.fa.md) · [English](README.md)

## چرا این موضوع

RAM و ROM و FIFO — ساختارهایی که تعیین می‌کنند طراحی‌ات در بلوک RAM جا می‌شود یا سلول‌های منطقی را می‌خورد. در اینجا الگوی VHDL به‌اندازهٔ الگوریتم مهم است.

## از وریلاگ به VHDL

| Verilog / SystemVerilog | VHDL |
|---|---|
| `initial $readmemh(...)` | `constant ROM : rom_t := (...);  -- elaboration time` |
| `reg [7:0] mem [0:255];` | `type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);` |
| `always @(posedge clk) begin mem[wa] <= wd; rd <= mem[ra]; end` | `process (clk) begin if rising_edge(clk) then mem(wa) <= wd; rd <= mem(ra); end if; end process;` |
| `if (wptr - rptr == DEPTH) full = 1;` | `if wptr(wptr'high) /= rptr(rptr'high) and wptr(wptr'high-1 downto 0) = rptr(rptr'high-1 downto 0) then` |

## درس‌ها

| # | درس | هدف | وضعیت |
|---|---|---|---|
| 01 | [ROM و ثابت‌های مقدارگذاری‌شده](01-rom-and-constants/README.fa.md) | یک ROM را از تابع یا فایل مقداردهی کن و بفهم چرا ROM نباید ریست داشته باشد. | برنامه‌ریزی‌شده |
| 02 | [RAM تک‌درگاهه](02-single-port-ram/README.fa.md) | الگوی متعارف RAM با نوشتن هم‌زمان و خواندن هم‌زمان را بنویس که روی هر FPGA به بلوک RAM نگاشت شود. | برنامه‌ریزی‌شده |
| 03 | [RAM سادهٔ دو‌درگاهه](03-simple-dual-port-ram/README.fa.md) | درگاه دومی برای خواندن و نوشتن هم‌زمان اضافه کن و حالت برخورد را صریح مدیریت کن. | برنامه‌ریزی‌شده |
| 04 | [FIFO هم‌زمان](04-synchronous-fifo/README.fa.md) | یک FIFO با بافر حلقه‌ای و پرچم‌های پر/خالی بساز، با ترفند عرض اشاره‌گر که ابهام را حذف می‌کند. | برنامه‌ریزی‌شده |

## پس از این موضوع می‌توانی

- نوشتن الگوی RAM مناسب استنتاج
- مقداردهی اولیهٔ ROM بدون ریست
- ساخت FIFO هم‌زمان با پرچم‌های درست

## پیش‌نیاز

ابتدا موضوع قبلی را تمام کن؛ هر موضوع مستقیماً روی قبلی ساخته می‌شود.
درس اول کل زنجیرهٔ ابزار را هم توضیح می‌دهد، بنابراین پیش‌زمینهٔ VHDL لازم نیست.

## اجرای همهٔ درس‌های این موضوع

```bash
make test-07-memories
```
