# vhdl-tutor

VHDL را با ساختن، شبیه‌سازی و آزمودن طراحی‌های واقعی یاد بگیر — فقط با ابزارهای
متن‌باز و بدون نیاز به هیچ بورد FPGA.

این دوره برای کسانی نوشته شده که **وریلاگ یا SystemVerilog** می‌دانند. قرار نیست
دوباره توضیح دهد فلیپ‌فلاپ چیست؛ قرار است نشان دهد VHDL همان را چگونه بیان می‌کند
و کجا غافلگیرت می‌کند: نوع‌دهی قوی، `std_logic` حل‌شده، چرخهٔ دلتا، رکوردها،
پیکربندی‌ها، و فرهنگی از بستر آزمون که واقعاً از بیشتر کدهای وریلاگی بهتر است.

هر درس یک پوشه است که می‌توانی اجرا کنی:

```console
$ cd 00-hello-world/01-first-entity-and-testbench
$ make
== analyze 08 ==
== elaborate and2_tb ==
== run and2_tb ==
and2_tb: PASS (4 checks)
```

---

## شروع سریع

```bash
git clone <this-repo> vhdl-tutor && cd vhdl-tutor

make env        # آیا GHDL نصب است و VHDL-2008 را می‌فهمد؟
make test       # اجرای همهٔ درس‌های نوشته‌شده
make list       # نقشهٔ راه کامل و میزان پیشرفت
```

هنوز GHDL نداری؟

```bash
make install-tools                    # با apt و sudo
scripts/install-tools.sh --rootless   # باز کردن بسته در ‎~/.local، بدون root
```

بعد یک درس را با شکل موج امتحان کن:

```bash
make run  LESSON=03-sequential/01-first-clocked-process
make wave LESSON=03-sequential/01-first-clocked-process
```

اگر Docker داری، نیازی به نصب نیست:

```bash
docker build -t vhdl-tutor .
docker run --rm -it -v "$PWD":/course vhdl-tutor
```

---

## ساختار دوره

```
<topic>/<lesson>/
├── README.md          # هدف، مقایسه با وریلاگ، مفاهیم، تمرین‌ها (انگلیسی)
├── README.fa.md       # همان، به فارسی
├── src/*.vhd          # طراحی تحت آزمون
├── tb/*_tb.vhd        # بستر آزمون خودبررسی
└── Makefile           # دو خط؛ همهٔ قواعد در common/exercise.mk است
```

داخل هر درس:

| فرمان | کار |
|---|---|
| `make` | تحلیل، بسط و اجرای بستر آزمون؛ در شکست کد خروج غیرصفر |
| `make wave` | همان، به‌همراه نوشتن `build/<top>.ghw` و باز کردن Surfer یا GTKWave |
| `make vcd` | همان، با خروجی `.vcd` قابل‌حمل |
| `make synth` | سنتز با Yosys و افزونهٔ GHDL (موضوع ۱۰) |
| `make help` | فهرست متغیرهایی که می‌توانی عوض کنی |
| `make clean` | پاک کردن `build/` |

متغیرهای پرکاربرد: `STD=93`، `TOP=other_tb`، `STOP_TIME=10ms`،
`RUN_ARGS="-gWIDTH=16"`، `WAVE_VIEWER=gtkwave`.

---

## نقشهٔ راه

۵۴ درس در ۱۳ موضوع. وضعیت در فایل [`course.toml`](course.toml) نگه‌داری می‌شود و
`make list` نسخهٔ زندهٔ آن را چاپ می‌کند.

| # | موضوع | درس‌ها | وضعیت |
|---|---|---|---|
| [00](00-hello-world/README.fa.md) | سلام، دنیا | ۳ | **نوشته‌شده** |
| [01](01-language-basics/README.fa.md) | مبانی زبان | ۶ | **نوشته‌شده** |
| [02](02-combinational/README.fa.md) | منطق ترکیبی | ۵ | اسکلت آماده |
| [03](03-sequential/README.fa.md) | منطق ترتیبی | ۵ | اسکلت آماده |
| [04](04-state-machines/README.fa.md) | ماشین‌های حالت | ۴ | اسکلت آماده |
| [05](05-testbenches/README.fa.md) | بسترهای آزمون | ۵ | اسکلت آماده |
| [06](06-modularity/README.fa.md) | پیمانه‌ای‌سازی | ۵ | اسکلت آماده |
| [07](07-memories/README.fa.md) | حافظه‌ها | ۴ | اسکلت آماده |
| [08](08-arithmetic-dsp/README.fa.md) | حساب و پردازش سیگنال | ۴ | اسکلت آماده |
| [09](09-interfaces/README.fa.md) | رابط‌ها و پروتکل‌ها | ۴ | اسکلت آماده |
| [10](10-synthesis-awareness/README.fa.md) | آگاهی از سنتز | ۳ | اسکلت آماده |
| [11](11-verification/README.fa.md) | چارچوب‌های راستی‌آزمایی | ۳ | اسکلت آماده |
| [12](12-projects/README.fa.md) | پروژه‌های پایانی | ۳ | اسکلت آماده |

درس **نوشته‌شده** سورس کامل، بستر آزمون خودبررسی و توضیح گام‌به‌گام دارد و
`make test` همهٔ آن‌ها را اجرا می‌کند. درس اسکلت‌شده از قبل هدف، مفاهیم،
تمرین‌ها و راهنماهایش نوشته شده است — فقط کد و توضیح گام‌به‌گام کم دارد. اجرای
`make` در آن پیام می‌دهد و با موفقیت خارج می‌شود، بنابراین CI تا پایان نوشتن
دوره سبز می‌ماند.

---

## زنجیرهٔ ابزار

همه متن‌باز. نسخه مهم نیست، توانایی مهم است: GHDL باید VHDL-2008 را پشتیبانی کند.

| ابزار | نقش | نصب |
|---|---|---|
| [GHDL](https://ghdl.github.io/ghdl/) | تحلیل، بسط و شبیه‌سازی | `apt install ghdl` |
| [GTKWave](https://gtkwave.github.io/gtkwave/) | نمایشگر کلاسیک شکل موج | `apt install gtkwave` |
| [Surfer](https://surfer-project.org/) | نمایشگر مدرن نوشته‌شده با Rust | فایل آماده یا `cargo install surfer` |
| [Yosys](https://yosyshq.net/yosys/) + [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin) | سنتز اختیاری، موضوع ۱۰ | `apt install yosys` و ساخت افزونه |
| [vhdl_ls](https://github.com/VHDL-LS/rust_hdl) | تشخیص و تکمیل در ویرایشگر | `cargo install vhdl_ls` |
| [VUnit](https://vunit.github.io/), [OSVVM](https://osvvm.org/), [cocotb](https://www.cocotb.org/) | چارچوب‌های راستی‌آزمایی، موضوع ۱۱ | `pip` یا زیرماژول |

جزئیات، از جمله نصب بدون root و تنظیم ویرایشگر، در
[docs/fa/01-install.md](docs/fa/01-install.md) آمده است.

این دوره عمداً **ابزار فروشنده و جریان بورد ندارد**. موضوع ۱۰ با Yosys نشان
می‌دهد RTL تو به چه تبدیل می‌شود، اما قید پایه‌ها، بیت‌استریم و بستن زمان‌بندی
به یک دورهٔ سخت‌افزار تعلق دارد.

---

## مستندات

| سند | محتوا |
|---|---|
| [۰۰ — از وریلاگ به VHDL](docs/fa/00-verilog-to-vhdl.md) | جدول ترجمه و تغییرهای ذهنی |
| [۰۱ — نصب](docs/fa/01-install.md) | GHDL، نمایشگرها، سرور زبان، مسیر بدون root و Docker |
| [۰۲ — چرخهٔ کار](docs/fa/02-workflow.md) | تحلیل/بسط/اجرا، متغیرهای make، کد خروج، شکل موج |
| [۰۳ — راهنمای سبک](docs/fa/03-style-guide.md) | نام‌گذاری، چیدمان، قواعد این دوره |
| [۰۴ — دام‌ها](docs/fa/04-pitfalls.md) | لچ، فهرست حساسیت، چرخهٔ دلتا، تبدیل‌های عددی |
| [۰۵ — برگهٔ تقلب](docs/fa/05-cheatsheet.md) | مرجع یک‌صفحه‌ای نحو |
| [۰۶ — راستی‌آزمایی](docs/fa/06-verification.md) | بستر خودبررسی، VUnit، OSVVM، cocotb، PSL |
| [۰۷ — سنتز](docs/fa/07-synthesis.md) | زیرمجموعهٔ سنتزپذیر، استنتاج، جریان Yosys |
| [واژه‌نامه](docs/fa/glossary.md) | اصطلاحات انگلیسی/فارسی دوره |

نسخهٔ انگلیسی در پوشهٔ [`docs/`](docs/) است.

---

## افزودن درس

```bash
make new TOPIC=04-state-machines/05-sequence-detector \
         TITLE="Sequence detector" TITLE_FA="آشکارساز دنباله"
```

این فرمان پوشه، دو README، Makefile دوخطی را می‌سازد و درس را با وضعیت
`planned` در `course.toml` ثبت می‌کند. کد را بنویس، وضعیت را `done` کن و
`make test` آن را خودکار برمی‌دارد.

قواعدی که دوره رعایت می‌کند:

- هر درس نوشته‌شده یک بستر آزمون **خودبررسی** دارد و در شکست کد خروج غیرصفر
  می‌دهد — نه «شکل موج را نگاه کن و خودت قضاوت کن».
- هیچ بستری معلق نمی‌ماند: `--stop-time` به‌همراه نگهبان در خود بستر.
- کد و نام‌ها انگلیسی‌اند؛ متن انگلیسی + فارسی است.
- یک درس می‌تواند `planned` باشد، اما نباید کهنه شود: `make list` از
  `course.toml` می‌خواند و شمارش‌ها حقیقت‌اند.

## پروانه

هنوز فایل پروانه ندارد — پیش از انتشار مخزن یکی اضافه کن.
