# vhdl-tutor — top-level commands. Run `make help` for the short version.
#
#   make                 quickstart: environment check, then run every written lesson
#   make list            course inventory and progress
#   make test            run all written lessons (done + draft)
#   make test-all        run every lesson that has code
#   make test-03-sequential   run one topic
#   make run LESSON=00-hello-world/01-first-entity-and-testbench
#   make wave LESSON=...
#   make new TOPIC=04-state-machines/05-new-lesson TITLE="..." TITLE_FA="..."

SHELL  := /bin/bash
PYTHON ?= python3
CURRICULUM := scripts/curriculum.py

.DEFAULT_GOAL := help

.PHONY: help list test test-all run wave env check-i18n clean new install-tools

help:
	@echo "vhdl-tutor"
	@echo ""
	@echo "  make list                    course inventory and progress"
	@echo "  make list-verbose            every lesson with its status"
	@echo "  make test                    run every written lesson"
	@echo "  make test-all                run every lesson that has code"
	@echo "  make test-<topic>            run one topic, e.g. make test-03-sequential"
	@echo "  make run  LESSON=<topic>/<lesson>"
	@echo "  make wave LESSON=<topic>/<lesson>"
	@echo "  make env                     check the toolchain"
	@echo "  make check-i18n              verify every doc has its Persian counterpart"
	@echo "  make install-tools           install GHDL/GTKWave (asks for sudo)"
	@echo "  make clean                   remove every build/ directory"
	@echo ""
	@echo "Inside a lesson folder: make, make wave, make vcd, make synth, make help"

list:
	@$(PYTHON) $(CURRICULUM) list

list-verbose:
	@$(PYTHON) $(CURRICULUM) list -v

test:
	@$(PYTHON) $(CURRICULUM) test --status done,draft

test-all:
	@$(PYTHON) $(CURRICULUM) test --status all

test-%:
	@$(PYTHON) $(CURRICULUM) test --status all --topic $*

run:
	@test -n "$(LESSON)" || { echo "usage: make run LESSON=<topic>/<lesson>"; exit 2; }
	@$(PYTHON) $(CURRICULUM) run --lesson "$(LESSON)" $(if $(RUN_ARGS),--run-args '$(RUN_ARGS)')

wave:
	@test -n "$(LESSON)" || { echo "usage: make wave LESSON=<topic>/<lesson>"; exit 2; }
	@$(PYTHON) $(CURRICULUM) run --lesson "$(LESSON)" --wave

env:
	@scripts/check-env.sh

check-i18n:
	@scripts/check-i18n.sh

install-tools:
	@scripts/install-tools.sh

new:
	@test -n "$(TOPIC)" || { echo 'usage: make new TOPIC=<topic>/<NN-slug> TITLE="..." TITLE_FA="..."'; exit 2; }
	@scripts/new-lesson.sh "$(TOPIC)" "$(TITLE)" "$(TITLE_FA)"

clean:
	@find . -type d -name build -prune -exec rm -rf {} +
	@echo "removed all build/ directories"
