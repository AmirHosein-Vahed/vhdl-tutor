# vhdl-tutor

Learn VHDL by building, simulating and testing real designs — with open-source
tools only, and no FPGA board required.

The course is written for people who already know **Verilog or SystemVerilog**.
It does not re-teach what a flip-flop is; it teaches how VHDL expresses it, and
where VHDL will surprise you: strong typing, resolved `std_logic`, delta cycles,
records, configurations, and a testbench culture that is genuinely better than
what most Verilog codebases have.

Every lesson is a folder you can run:

```console
$ cd 00-hello-world/01-first-entity-and-testbench
$ make
== analyze 08 ==
== elaborate and2_tb ==
== run and2_tb ==
and2_tb: PASS (4 checks)
```

---

## Quickstart

```bash
git clone <this-repo> vhdl-tutor && cd vhdl-tutor

make env            # is GHDL installed and does it speak VHDL-2008?
make check-lessons  # do course.toml, folders and code agree?
make test           # run every written lesson
make test-all       # run every lesson that has real code
make list           # the full roadmap and progress
```

No GHDL yet?

```bash
make install-tools                    # apt + sudo
scripts/install-tools.sh --rootless   # unpack under ~/.local, no root
```

Then try a lesson with a waveform:

```bash
make run  LESSON=03-sequential/01-first-clocked-process
make wave LESSON=03-sequential/01-first-clocked-process
```

Docker users can skip installation entirely:

```bash
docker build -t vhdl-tutor .
docker run --rm -it -v "$PWD":/course vhdl-tutor
```

---

## How the course is organised

```
<topic>/<lesson>/
├── README.md          # goal, Verilog contrast, concepts, tasks (English)
├── README.fa.md       # same, in Persian
├── src/*.vhd          # the design under test
├── tb/*_tb.vhd        # self-checking testbench
└── Makefile           # two lines; all rules live in common/exercise.mk
```

Inside a lesson:

| Command | What it does |
|---|---|
| `make` | analyze, elaborate, run the testbench; non-zero exit on failure |
| `make wave` | same, write `build/<top>.ghw`, open Surfer or GTKWave |
| `make vcd` | same, write a portable `.vcd` |
| `make synth` | synthesize with Yosys + GHDL plugin (topic 10) |
| `make help` | list the variables you can override |
| `make clean` | remove `build/` |

Useful overrides: `STD=93`, `TOP=other_tb`, `STOP_TIME=10ms`,
`RUN_ARGS="-gWIDTH=16"`, `WAVE_VIEWER=gtkwave`.

---

## Roadmap

54 lessons in 13 topics. Status is tracked in [`course.toml`](course.toml);
`make list` prints the live version.

| # | Topic | Lessons | Status |
|---|---|---|---|
| [00](00-hello-world/README.md) | Hello world | 3 | **written** |
| [01](01-language-basics/README.md) | Language basics | 6 | **written** |
| [02](02-combinational/README.md) | Combinational logic | 5 | scaffolded |
| [03](03-sequential/README.md) | Sequential logic | 5 | scaffolded |
| [04](04-state-machines/README.md) | State machines | 4 | scaffolded |
| [05](05-testbenches/README.md) | Testbenches | 5 | scaffolded |
| [06](06-modularity/README.md) | Modularity | 5 | scaffolded |
| [07](07-memories/README.md) | Memories | 4 | scaffolded |
| [08](08-arithmetic-dsp/README.md) | Arithmetic and DSP | 4 | scaffolded |
| [09](09-interfaces/README.md) | Interfaces and protocols | 4 | scaffolded |
| [10](10-synthesis-awareness/README.md) | Synthesis awareness | 3 | scaffolded |
| [11](11-verification/README.md) | Verification frameworks | 3 | scaffolded |
| [12](12-projects/README.md) | Capstone projects | 3 | scaffolded |

A **written** lesson has the full source, a self-checking testbench and a worked
explanation; `make test` runs all of them. A scaffolded lesson already has its
goal, concepts, tasks and hints written — only the code and worked explanation
are missing. `make` inside it says so and exits successfully, so CI stays green
while the course is being written.

---

## Toolchain

All open source. Versions matter less than capabilities: GHDL must support
VHDL-2008.

| Tool | Role | Install |
|---|---|---|
| [GHDL](https://ghdl.github.io/ghdl/) | analyzer, elaborator, simulator | `apt install ghdl` |
| [GTKWave](https://gtkwave.github.io/gtkwave/) | classic waveform viewer | `apt install gtkwave` |
| [Surfer](https://surfer-project.org/) | modern Rust waveform viewer | release binary or `cargo install surfer` |
| [Yosys](https://yosyshq.net/yosys/) + [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin) | optional synthesis, topic 10 | `apt install yosys`, build plugin |
| [vhdl_ls](https://github.com/VHDL-LS/rust_hdl) | editor diagnostics/completion | `cargo install vhdl_ls` |
| [VUnit](https://vunit.github.io/), [OSVVM](https://osvvm.org/), [cocotb](https://www.cocotb.org/) | verification frameworks, topic 11 | `pip`, submodules |

Details, including rootless install and editor setup, are in
[docs/01-install.md](docs/01-install.md).

This course deliberately has **no vendor tools and no board flow**. Topic 10
uses Yosys to show what your RTL turns into, but pin constraints, bitstreams
and timing closure belong to a hardware course.

---

## Documentation

| Document | What it covers |
|---|---|
| [00 — Coming from Verilog](docs/00-verilog-to-vhdl.md) | the translation table, and the mental-model changes |
| [01 — Install](docs/01-install.md) | GHDL, viewers, language server, rootless and Docker paths |
| [02 — Workflow](docs/02-workflow.md) | analyze/elaborate/run, make variables, exit codes, waves |
| [03 — Style guide](docs/03-style-guide.md) | naming, layout, the rules this course follows |
| [04 — Pitfalls](docs/04-pitfalls.md) | latches, sensitivity, delta cycles, numeric conversions |
| [05 — Cheat sheet](docs/05-cheatsheet.md) | one-page syntax reference |
| [06 — Verification](docs/06-verification.md) | self-checking TBs, VUnit, OSVVM, cocotb, PSL |
| [07 — Synthesis](docs/07-synthesis.md) | synthesizable subset, inference, Yosys flow |
| [Glossary](docs/glossary.md) | English/Persian terms used in the course |

Persian versions live in [`docs/fa/`](docs/fa/).

---

## Adding a lesson

```bash
make new TOPIC=04-state-machines/05-sequence-detector \
         TITLE="Sequence detector" TITLE_FA="آشکارساز دنباله"
```

This creates the folder, both READMEs, the two-line Makefile, and registers the
lesson in `course.toml` as `planned`. Write the source and a testbench, then run
`make test-all`; CI picks the lesson up as soon as those files exist, even
before you flip the status to `done`.

CI runs `make check-lessons` first and then `make test-all`. A lesson is tested
as soon as it has `src/*.vhd` and a `tb/*_tb.vhd`; lessons that contain only
README files or `.gitkeep` are skipped, while a `done` lesson without code fails
the check.

Rules the course keeps:

- Every written lesson has a **self-checking** testbench and exits non-zero on
  failure — no "look at the waveform and decide".
- No testbench may hang: `--stop-time` plus a watchdog in the TB.
- Code and identifiers are English; prose is English + Persian.
- A lesson may be `planned`, but it may not rot: `make list` reads
  `course.toml`, and the counts are the truth.

## License

No license file yet — add one before publishing this repository.
