# 01 — Install the toolchain

Everything in this course runs on Linux, macOS and Windows, but the commands
here assume a Unix shell. You need three things:

1. **GHDL** — analyzer, elaborator, simulator. Required.
2. **A waveform viewer** — GTKWave or Surfer. Strongly recommended.
3. **make + Python 3.11+** — the course's build and inventory scripts.

---

## GHDL

### Ubuntu / Debian (recommended)

```bash
sudo apt update
sudo apt install ghdl
ghdl --version
```

Ubuntu 26.04 ships GHDL 5.0.1; Ubuntu 24.04 ships 4.1. Either is fine —
the course needs VHDL-2008, which both support.

### Without root

The course can unpack the Debian packages into `~/.local`:

```bash
scripts/install-tools.sh --rootless
```

This downloads `ghdl`, `ghdl-common` and `ghdl-mcode` with `apt-get download`,
unpacks them under `~/.local/opt/ghdl`, and writes a wrapper at
`~/.local/bin/ghdl` that sets `GHDL_PREFIX` correctly. Make sure
`~/.local/bin` is on your `PATH`.

### macOS

```bash
brew install ghdl
```

### Windows

Use WSL2 and follow the Ubuntu instructions. Native Windows GHDL exists but
the course's Makefiles assume a Unix shell.

### Verify

```bash
make env
```

You should see `ok ghdl`, `ok vhdl-2008`, `ok make`, `ok python3`. Missing
optional tools are reported with `--` and do not fail the check.

If GHDL is installed but `vhdl-2008` fails, your build is too old or the
libraries are misplaced. The usual cause on a rootless install is a wrong
`GHDL_PREFIX`; re-run `scripts/install-tools.sh --rootless`.

---

## Waveform viewers

Both read GHW; GTKWave also reads VCD, Surfer reads GHW/VCD/FST and is much
faster on long traces.

```bash
sudo apt install gtkwave          # classic
```

Surfer: download a release binary from <https://surfer-project.org/> and put it
on your `PATH`, or:

```bash
cargo install surfer
```

`make wave` picks whichever is installed (`surfer` first), and you can force one:

```bash
make wave WAVE_VIEWER=gtkwave
```

If neither is installed, `make wave` still writes `build/<top>.ghw` and tells
you where it is.

---

## Optional: language server

`vhdl_ls` gives diagnostics, go-to-definition and autocomplete in editors that
speak LSP (VS Code, Neovim, Emacs, Helix). It understands GHDL projects through
a `vhdl_ls.toml`.

```bash
cargo install vhdl_ls
# or download a release from https://github.com/VHDL-LS/rust_hdl/releases
```

A minimal `vhdl_ls.toml` that includes every lesson:

```toml
[libraries]
work = { vhdl.sources = ["**/src/*.vhd", "**/tb/*.vhd"],
         vhdl.generic = "08" }
```

Editor setup:

- **VS Code** — install `teros-technology.teroshdl`; point it at `ghdl` and
  `vhdl_ls`.
- **Neovim** — `nvim-lspconfig` has a `vhdl_ls` preset.
- **Emacs** — `lsp-mode` or `eglot` with `vhdl-ls`.

The language server is a convenience. The course never depends on it; `make`
is the source of truth.

---

## Optional: synthesis

Topic 10 uses Yosys and the GHDL plugin to turn VHDL into a netlist:

```bash
sudo apt install yosys
# then build ghdl-yosys-plugin:
# https://github.com/ghdl/ghdl-yosys-plugin
```

The plugin is not packaged on most distros. If building it is a hassle, read
topic 10 without running `make synth`; nothing later depends on it.

---

## Docker: zero install

```bash
docker build -t vhdl-tutor .
docker run --rm -it -v "$PWD":/course vhdl-tutor
```

Inside the container, `make test` and `make wave` work. `make wave` needs a
viewer *on the host*: the container writes `build/<top>.ghw`, and the bind
mount means the file appears in your checkout.

VS Code users can open the folder and "Reopen in Container"; the devcontainer
runs `make env && make test` on creation.

---

## Editors: the 10-second setup

You do not need an IDE. This is enough:

- syntax highlighting for `.vhd` (Vim, VS Code, Emacs all ship it),
- `make` in a terminal,
- a viewer for `.ghw`.

Useful editor conventions:

| File | Meaning |
|---|---|
| `*.vhd` / `*.vhdl` | VHDL source |
| `build/work-obj08.cf` | GHDL's library file (never edit, never commit) |
| `.ghw` | GHDL waveform (binary, commit only small ones) |
| `.vcd` | portable waveform (large, do not commit) |

Add this to `.vimrc` if you want `:make` inside Vim:

```vim
set makeprg=make
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `ghdl:error: cannot find "std" library` | wrong `GHDL_PREFIX` | reinstall, or `export GHDL_PREFIX=$(dirname $(find ~/.local -name std -type d \| head -1))` |
| `no *_tb.vhd found in tb/` | lesson is scaffolded, or TB not written | check the lesson status; `make` in a planned lesson exits 0 on purpose |
| `make wave` opens nothing | no viewer installed | install GTKWave/Surfer, or open `build/*.ghw` elsewhere |
| simulation never ends | no `std.env.finish` and no `--stop-time` | the course sets `STOP_TIME=1ms`; override with `STOP_TIME=10ms` |
| `can't open work-obj08.cf` | stale/corrupt build dir | `make clean` |
| VHDL-2008 syntax rejected | old GHDL | `ghdl --version`; 4.1+ is fine, 3.x is not |

---

Next: [02 — Workflow](02-workflow.md)
