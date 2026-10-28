# Shared build rules for every lesson.
#
# A lesson Makefile is two lines:
#
#     include ../../common/exercise.mk
#
# Everything else is discovered: VHDL files in src/ and tb/, the first
# *_tb.vhd becomes the simulation top. Override anything on the command line:
#
#     make TOP=my_tb STD=93 RUN_ARGS="-gWIDTH=32"

LESSON_DIR  := $(CURDIR)
ROOT        := $(abspath $(LESSON_DIR)/../..)
BUILD       := $(LESSON_DIR)/build
COMMON_VHDL := $(ROOT)/common/vhdl

GHDL        ?= ghdl
STD         ?= 08
STOP_TIME   ?= 1ms
RUN_ARGS    ?=
WAVE_VIEWER ?= $(or $(shell command -v surfer 2>/dev/null),\
                    $(shell command -v gtkwave 2>/dev/null))

SRC     := $(sort $(wildcard $(LESSON_DIR)/src/*.vhd))
TB      := $(sort $(wildcard $(LESSON_DIR)/tb/*.vhd))
TB_TOP  := $(notdir $(basename $(firstword $(filter %_tb.vhd,$(TB)))))
TOP     ?= $(TB_TOP)
WAVE    := $(BUILD)/$(TOP).ghw

GHDL_FLAGS := --std=$(STD) --workdir=$(BUILD)

.PHONY: all sim planned analyze elab run wave vcd viewer synth clean help guard

all: $(if $(strip $(SRC) $(TB)),sim,planned)

planned:
	@echo "lesson planned — nothing to build yet (see README.md)"

guard:
	@test -n "$(TOP)" || { \
		echo "error: no *_tb.vhd found in tb/ — add a testbench or pass TOP=..."; \
		exit 2; }

sim: guard analyze elab run

analyze: guard | $(BUILD)
	@echo "== analyze $(STD) =="
	@$(GHDL) -a $(GHDL_FLAGS) $(COMMON_VHDL)/tb_utils.vhd
	@for f in $(SRC); do echo "   $$f"; $(GHDL) -a $(GHDL_FLAGS) $$f || exit 1; done
	@for f in $(TB); do echo "   $$f"; $(GHDL) -a $(GHDL_FLAGS) $$f || exit 1; done

elab: guard | $(BUILD)
	@echo "== elaborate $(TOP) =="
	@$(GHDL) -e $(GHDL_FLAGS) $(TOP)

run: guard | $(BUILD)
	@echo "== run $(TOP) =="
	@$(GHDL) -r $(GHDL_FLAGS) $(TOP) --assert-level=error \
		--stop-time=$(STOP_TIME) $(RUN_ARGS)

# Same run, but write a waveform and open it. If no viewer is installed the
# file is still written; open it later with `gtkwave build/<top>.ghw`.
wave: RUN_ARGS += --wave=$(WAVE)
wave: run viewer

viewer: guard
	@if [ -n "$(WAVE_VIEWER)" ]; then \
		echo "== opening $(WAVE) with $(WAVE_VIEWER) =="; \
		$(WAVE_VIEWER) $(WAVE) >/dev/null 2>&1 & \
	else \
		echo "== no waveform viewer found =="; \
		echo "   waveform written to $(WAVE)"; \
		echo "   install Surfer or GTKWave, or copy the file to a machine that has one"; \
	fi

vcd: RUN_ARGS += --vcd=$(BUILD)/$(TOP).vcd
vcd: run
	@echo "== VCD written to $(BUILD)/$(TOP).vcd =="

# Synthesis awareness (topic 10). Requires yosys and the ghdl plugin:
#   sudo apt install yosys
#   https://github.com/ghdl/ghdl-yosys-plugin
SYNTH_TOP ?= $(notdir $(basename $(firstword $(SRC))))
YOSYS     ?= yosys
synth: analyze | $(BUILD)
	@command -v $(YOSYS) >/dev/null 2>&1 || { \
		echo "yosys not found — see docs/07-synthesis.md"; exit 1; }
	@test -n "$(SYNTH_TOP)" || { \
		echo "no synthesizable source in src/ — see docs/07-synthesis.md"; exit 2; }
	@$(YOSYS) -m ghdl -p "ghdl $(GHDL_FLAGS) $(SYNTH_TOP); synth; stat" 2>&1 \
		| tee $(BUILD)/synth.log

clean:
	@rm -rf $(BUILD)
	@echo "cleaned $(LESSON_DIR)/build"

help:
	@echo "lesson: $(patsubst $(ROOT)/%,%,$(LESSON_DIR))"
	@echo ""
	@echo "  make            analyze, elaborate and run the self-checking testbench"
	@echo "  make wave       same, write build/$(TOP).ghw and open a viewer"
	@echo "  make vcd        same, write a portable build/$(TOP).vcd"
	@echo "  make synth      synthesize with yosys + ghdl plugin (topic 10)"
	@echo "  make clean      remove build/"
	@echo ""
	@echo "  variables: GHDL=$(GHDL) STD=$(STD) TOP=$(TOP) STOP_TIME=$(STOP_TIME)"
	@echo "             SYNTH_TOP=$(SYNTH_TOP) YOSYS=$(YOSYS)"
	@echo "             RUN_ARGS='$(RUN_ARGS)' WAVE_VIEWER=$(WAVE_VIEWER)"

$(BUILD):
	@mkdir -p $(BUILD)
