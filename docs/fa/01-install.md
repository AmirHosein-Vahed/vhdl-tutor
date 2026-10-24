# ۰۱ — نصب زنجیرهٔ ابزار

همهٔ دوره روی لینوکس، مک و ویندوز اجرا می‌شود، اما فرمان‌های اینجا پوستهٔ یونیکسی
را فرض می‌کنند. سه چیز لازم داری:

1. **GHDL** — تحلیل، بسط و شبیه‌سازی. ضروری.
2. **نمایشگر شکل موج** — GTKWave یا Surfer. به‌شدت توصیه می‌شود.
3. **make و Python 3.11+** — اسکریپت‌های ساخت و فهرست دوره.

---

## GHDL

### اوبونتو / دبیان (پیشنهادی)

```bash
sudo apt update
sudo apt install ghdl
ghdl --version
```

اوبونتو ۲۶٫۰۴ نسخهٔ 5.0.1 و اوبونتو ۲۴٫۰۴ نسخهٔ 4.1 را دارد. هر دو کافی‌اند؛
دوره به VHDL-2008 نیاز دارد که هر دو پشتیبانی می‌کنند.

### بدون root

دوره می‌تواند بسته‌های دبیان را در `~/.local` باز کند:

```bash
scripts/install-tools.sh --rootless
```

این فرمان `ghdl`، `ghdl-common` و `ghdl-mcode` را با `apt-get download`
می‌گیرد، زیر `~/.local/opt/ghdl` باز می‌کند و پوششی در `~/.local/bin/ghdl`
می‌نویسد که `GHDL_PREFIX` را درست تنظیم می‌کند. مطمئن شو `~/.local/bin` در
`PATH` تو هست.

### مک

```bash
brew install ghdl
```

### ویندوز

از WSL2 استفاده کن و دستورهای اوبونتو را دنبال کن. GHDL بومی ویندوز وجود دارد،
اما Makefileهای دوره پوستهٔ یونیکسی می‌خواهند.

### بررسی

```bash
make env
```

باید `ok ghdl`، `ok vhdl-2008`، `ok make` و `ok python3` را ببینی. ابزارهای
اختیاری با `--` گزارش می‌شوند و بررسی را شکست نمی‌دهند.

اگر GHDL نصب است اما `vhdl-2008` شکست می‌خورد، نسخه قدیمی است یا کتابخانه‌ها
جای درست نیستند. علت رایج در نصب بدون root، `GHDL_PREFIX` اشتباه است؛
`scripts/install-tools.sh --rootless` را دوباره اجرا کن.

---

## نمایشگرهای شکل موج

هر دو GHW را می‌خوانند؛ GTKWave علاوه بر آن VCD و Surfer هر سه قالب GHW/VCD/FST
را می‌خواند و روی ردهای طولانی بسیار سریع‌تر است.

```bash
sudo apt install gtkwave          # کلاسیک
```

Surfer: فایل آماده را از <https://surfer-project.org/> بگیر و در `PATH` بگذار، یا:

```bash
cargo install surfer
```

`make wave` هر کدام را که نصب باشد برمی‌دارد (اول surfer) و می‌توانی اجبار کنی:

```bash
make wave WAVE_VIEWER=gtkwave
```

اگر هیچ‌کدام نصب نباشد، `make wave` باز هم `build/<top>.ghw` را می‌نویسد و
مسیرش را نشان می‌دهد.

---

## اختیاری: سرور زبان

`vhdl_ls` تشخیص خطا، رفتن به تعریف و تکمیل خودکار را در ویرایشگرهای دارای LSP
(VS Code، Neovim، Emacs، Helix) فراهم می‌کند و پروژهٔ GHDL را از `vhdl_ls.toml`
می‌شناسد.

```bash
cargo install vhdl_ls
# یا فایل آماده از https://github.com/VHDL-LS/rust_hdl/releases
```

کمینهٔ `vhdl_ls.toml` که همهٔ درس‌ها را شامل شود:

```toml
[libraries]
work = { vhdl.sources = ["**/src/*.vhd", "**/tb/*.vhd"],
         vhdl.generic = "08" }
```

تنظیم ویرایشگر:

- **VS Code** — افزونهٔ `teros-technology.teroshdl` را نصب کن و مسیر `ghdl` و
  `vhdl_ls` را به آن بده.
- **Neovim** — در `nvim-lspconfig` از پیش `vhdl_ls` هست.
- **Emacs** — `lsp-mode` یا `eglot` به‌همراه `vhdl-ls`.

سرور زبان فقط راحتی است. دوره هیچ‌جا به آن وابسته نیست؛ `make` مرجع است.

---

## اختیاری: سنتز

موضوع ۱۰ از Yosys و افزونهٔ GHDL برای تبدیل VHDL به شبکه استفاده می‌کند:

```bash
sudo apt install yosys
# سپس ghdl-yosys-plugin را بساز:
# https://github.com/ghdl/ghdl-yosys-plugin
```

افزونه در بیشتر توزیع‌ها بسته‌بندی نشده است. اگر ساختنش دردسر است، موضوع ۱۰ را
بدون اجرای `make synth` بخوان؛ هیچ درس بعدی به آن وابسته نیست.

---

## Docker: بدون نصب

```bash
docker build -t vhdl-tutor .
docker run --rm -it -v "$PWD":/course vhdl-tutor
```

داخل کانتینر `make test` و `make wave` کار می‌کنند. `make wave` نمایشگر *روی
میزبان* می‌خواهد: کانتینر `build/<top>.ghw` را می‌نویسد و به‌خاطر bind mount،
فایل در پوشهٔ تو ظاهر می‌شود.

کاربران VS Code می‌توانند پوشه را باز کنند و «Reopen in Container» را بزنند؛
devcontainer هنگام ساخت `make env && make test` را اجرا می‌کند.

---

## ویرایشگر: تنظیم ده‌ثانیه‌ای

به IDE نیاز نداری. همین کافی است:

- رنگ‌آمیزی نحو برای `.vhd` (Vim، VS Code و Emacs از پیش دارند)،
- `make` در یک ترمینال،
- یک نمایشگر برای `.ghw`.

قراردادهای مفید:

| فایل | معنا |
|---|---|
| `*.vhd` / `*.vhdl` | سورس VHDL |
| `build/work-obj08.cf` | فایل کتابخانهٔ GHDL (ویرایش نکن، کامیت نکن) |
| `.ghw` | شکل موج GHDL (دودویی؛ فقط کوچک‌ها را کامیت کن) |
| `.vcd` | شکل موج قابل‌حمل (بزرگ؛ کامیت نکن) |

اگر می‌خواهی داخل Vim `:make` بزنی:

```vim
set makeprg=make
```

---

## عیب‌یابی

| نشانه | علت | راه‌حل |
|---|---|---|
| `ghdl:error: cannot find "std" library` | `GHDL_PREFIX` اشتباه | دوباره نصب کن، یا `export GHDL_PREFIX=$(dirname $(find ~/.local -name std -type d \| head -1))` |
| `no *_tb.vhd found in tb/` | درس اسکلت است یا بستر آزمون نوشته نشده | وضعیت درس را ببین؛ `make` در درس برنامه‌ریزی‌شده عمداً با ۰ خارج می‌شود |
| `make wave` چیزی باز نمی‌کند | نمایشگر نصب نیست | GTKWave یا Surfer نصب کن، یا `build/*.ghw` را جای دیگری باز کن |
| شبیه‌سازی تمام نمی‌شود | نه `std.env.finish` هست نه `--stop-time` | دوره `STOP_TIME=1ms` می‌گذارد؛ با `STOP_TIME=10ms` عوض کن |
| `can't open work-obj08.cf` | پوشهٔ build کهنه یا خراب | `make clean` |
| نحو VHDL-2008 رد می‌شود | GHDL قدیمی | `ghdl --version`؛ ۴٫۱ به بالا خوب است، ۳٫x نه |

---

بعدی: [۰۲ — چرخهٔ کار](02-workflow.md)
