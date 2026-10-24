# 02 — The workflow: analyze, elaborate, run

GHDL is three tools in one binary, and the split matters.

| Stage | Command | What it does | Output |
|---|---|---|---|
| Analyze | `ghdl -a file.vhd` | Parses and type-checks one design unit, writes it to a library | `work-obj08.cf` |
| Elaborate | `ghdl -e top` | Builds the hierarchy, resolves generics, connects ports | an executable model |
| Run | `ghdl -r top` | Simulates | transcript, optional waveform |

You can do all three by hand — useful when `make` hides something:

```bash
cd 00-hello-world/01-first-entity-and-testbench
mkdir -p build
ghdl -a --std=08 --workdir=build ../../common/vhdl/tb_utils.vhd
ghdl -a --std=08 --workdir=build src/and2.vhd
ghdl -a --std=08 --workdir=build tb/and2_tb.vhd
ghdl -e --std=08 --workdir=build and2_tb
ghdl -r --std=08 --workdir=build and2_tb --assert-level=error --stop-time=1ms
```

`--workdir` keeps every generated file in `build/`, so the source tree stays
clean and `make clean` is trivial.

---

## What `make` does

Each lesson has a two-line Makefile:

```make
# All build logic lives in common/exercise.mk.
include ../../common/exercise.mk
```

`common/exercise.mk` discovers `src/*.vhd` and `tb/*.vhd`, picks the first
`*_tb.vhd` as the top, and runs `analyze → elab → run`.

```bash
make                  # the whole loop
make analyze          # syntax/type check only, fastest feedback
make elab             # hierarchy only
make run              # run without re-analyzing (still checks deps)
make wave             # run with --wave=build/<top>.ghw, then open a viewer
make vcd              # run with --vcd=build/<top>.vcd
make synth            # yosys + ghdl plugin (topic 10)
make help             # show the resolved variables
make clean            # remove build/
```

Overridable variables:

| Variable | Default | Use it for |
|---|---|---|
| `GHDL` | `ghdl` | another simulator build, or a wrapper |
| `STD` | `08` | `STD=93` to check backward compatibility |
| `TOP` | first `*_tb.vhd` | multiple testbenches in one lesson |
| `STOP_TIME` | `1ms` | long simulations |
| `RUN_ARGS` | empty | `-gWIDTH=16 --ieee-asserts=disable` |
| `WAVE_VIEWER` | surfer, else gtkwave | force a specific viewer |

Examples:

```bash
make TOP=fifo_full_tb STOP_TIME=10ms
make RUN_ARGS="-gWIDTH=32 -gDEPTH=64"
make wave WAVE_VIEWER=gtkwave
```

---

## Exit codes and CI

`make` exits non-zero if analysis fails, elaboration fails, or the testbench
reports a failure. That is the whole contract, and it is why every lesson can
be regression-tested with one command:

```bash
make test              # every lesson with status done or draft
make test-all          # every lesson that has code
make test-07-memories  # one topic
make test -v           # same, but print simulator output for failures
```

GHDL details that make this work:

- `--assert-level=error` stops the simulation on any `severity error` or
  higher. The course's helpers report individual failures as `warning` so the
  whole vector set is checked, and the summary as `failure`.
- `--stop-time` guarantees termination even if the testbench forgets to call
  `std.env.finish`.
- `std.env.finish` closes waveform files before exiting, so `make wave`
  produces a complete trace.

A passing run looks like this:

```
== analyze 08 ==
== elaborate and2_tb ==
== run and2_tb ==
and2_tb: PASS (4 checks)
```

A failing run:

```
FAIL: 1 and 1 (expected '0', got '1')
and2_tb: FAIL (1 of 4 checks failed)
ghdl:error: report failed
make: *** [run] Error 1
```

---

## Waveforms

```bash
make wave
```

writes `build/<top>.ghw` and launches the viewer. GHW keeps full type
information: enumerations appear as names, `std_logic` as its nine values,
records expanded. VCD flattens everything to bits — use it only for
interoperability.

What to put on the trace, in order:

1. the clock, and a clock-derived cursor,
2. reset and enable,
3. every state signal (if it is an enumeration, you see `IDLE`, `RUN`, …),
4. inputs and outputs of the DUT,
5. internal pipeline registers when debugging timing.

Two habits worth building:

- **Always inspect the first 100 ns.** Reset value, `'U'` on undriven signals,
  and the first clock edge tell you most of what is wrong.
- **Zoom to the delta, not the nanosecond.** When two signals change at the
  same timestamp but a report shows the old value, the answer is in the
  ordering, not the timing.

GHW can be opened later on any machine with GTKWave or Surfer:

```bash
gtkwave build/and2_tb.ghw
surfer build/and2_tb.ghw
```

---

## Debugging order

When a lesson fails, resist the urge to change the RTL first.

1. **Read the first failing check.** It prints expected and actual values.
2. **Check the time.** A failure at 0 ns is usually an uninitialized signal or
   an asynchronous reset that has not been applied.
3. **`'U'` everywhere?** A port is undriven. Check the port map directions and
   the testbench.
4. **Value one cycle late?** Signal vs variable, or a delta cycle.
5. **Wrong only at the boundary?** Width, sign extension, or an off-by-one
   range.
6. **Then** look at the waveform — with the failing check's time as the cursor.

Useful severity levels, in increasing order of "please stop":

```vhdl
report "..." severity note;     -- visible, harmless
report "..." severity warning;  -- visible, does not stop
report "..." severity error;    -- stops with --assert-level=error
report "..." severity failure;  -- always stops
```

`report` without a condition is unconditional; `assert cond report msg` only
prints when `cond` is false, which is the opposite of `assert` in software
testing — keep that in mind when reading other people's testbenches.

---

## A normal working session

```bash
make list                          # what am I doing today
cd 03-sequential/01-first-clocked-process
make analyze                       # fast type check while editing
make                               # run the tests
make wave                          # only when a check fails and you need time
make clean                         # before committing, to keep build/ out of git
```

Then, from the repository root:

```bash
make test                          # everything still green?
make check-i18n                    # did I forget a Persian README?
```

---

Next: [03 — Style guide](03-style-guide.md)
