# Run from the project's top directory (where tb.sv and design/ are).

VCS        ?= vcs
URG        ?= urg
OUT_DIR    ?= work
SIM        := $(OUT_DIR)/simv
LOG_DIR    := $(OUT_DIR)/logs
COV_DIR    := $(OUT_DIR)/regression.vdb
RPT_DIR    := $(OUT_DIR)/urgReport
TOP_FILE   ?= tb.sv
TOP_MODULE ?= tb

TESTNAME   ?= ro_test
VERBOSITY  ?= UVM_MEDIUM
SEED       ?= random
ITER       ?= 1
WAVES      ?= 0
GUI        ?= 0
LICWAIT    ?= 10

# tb.sv includes apb_interface.sv and apb_pkg.sv, so compile the top only
# (compiling them again as separate files gives "previously declared" errors).
# apb_pkg.sv includes the agent, RAL, adapter, subscriber, env, sequences and tests.

DESIGN_SRCS := design/apb_pkt_pkg.sv \
               design/pkt_generator.sv \
               design/pkt_switch.sv \
               design/apb_pkt_switch.sv

SV_SRCS  := $(TOP_FILE)

INC_OPTS := +incdir+. +incdir+design +incdir+apb_registers

VCS_OPTS := -sverilog -full64 -ntb_opts uvm -timescale=1ns/1ns -licwait $(LICWAIT) \
            -Mdir=$(OUT_DIR)/csrc -o $(SIM) -top $(TOP_MODULE)
COV_OPTS := -cm line+cond+fsm+tgl+branch+assert
SIM_OPTS :=

ifeq ($(WAVES),1)
  VCS_OPTS += -debug_access+all +define+DUMP_WAVES
endif

ifeq ($(GUI),1)
  VCS_OPTS += -debug_access+all
  SIM_OPTS += -gui
endif

# Tests run by "make regression". Override: make regression TEST_LIST="ro_test rw_test"
TEST_LIST ?= ro_test rw_test lock_test gen_pkt_cfg_test switch_ctrl_test \
             gen_ctrl_test irq_test err_test soft_rst_test

.PHONY: all help setup compile run regression summary report clean show-sources

all: run

help:
	@echo "APB packet switch UVM RAL verification with Synopsys VCS"
	@echo "  make compile                          Compile DUT and UVM testbench"
	@echo "  make run                              Compile and run the default test"
	@echo "  make run TESTNAME=lock_test SEED=1234"
	@echo "  make run WAVES=1                      Compile with debug access and DUMP_WAVES"
	@echo "  make run GUI=1                        Launch the simulator GUI (if supported)"
	@echo "  make regression ITER=3                Run every test in TEST_LIST three times, then summary + coverage report"
	@echo "  make summary                          Show regression PASS/FAIL totals"
	@echo "  make report                           Generate the URG coverage report"
	@echo "  make show-sources                     Print the configured source lists"
	@echo "  make clean                            Remove generated simulation files"

setup:
	@mkdir -p $(OUT_DIR) $(OUT_DIR)/csrc $(LOG_DIR)

show-sources:
	@echo "DUT sources:"
	@printf '%s\n' $(DESIGN_SRCS)
	@echo "Testbench top:"
	@printf '%s\n' $(SV_SRCS)
	@echo "Test list:"
	@printf '%s\n' $(TEST_LIST)

compile: setup
	@echo "Compiling APB DUT and UVM testbench..."
	$(VCS) $(VCS_OPTS) $(INC_OPTS) $(COV_OPTS) -cm_dir $(COV_DIR) $(DESIGN_SRCS) $(SV_SRCS) -l $(OUT_DIR)/compile.log

run: compile
	@set -e; \
	if [ "$(SEED)" = "random" ]; then \
	  RUN_SEED=$$(awk 'BEGIN { srand(); print int(rand()*2147483646)+1 }'); \
	else \
	  RUN_SEED="$(SEED)"; \
	fi; \
	LOG_FILE="$(LOG_DIR)/$(TESTNAME)_$${RUN_SEED}.log"; \
	echo "Running UVM test $(TESTNAME), seed=$${RUN_SEED}"; \
	$(SIM) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY) +ntb_random_seed=$${RUN_SEED} \
	  $(COV_OPTS) -cm_dir $(COV_DIR) -cm_name $(TESTNAME)_$${RUN_SEED} $(SIM_OPTS) \
	  -l "$${LOG_FILE}"; \
	echo "Simulation log: $${LOG_FILE}"

regression: compile
	@set +e; \
	rm -f $(OUT_DIR)/regr_status.txt; \
	COUNTER=0; \
	for test in $(TEST_LIST); do \
	  i=1; \
	  while [ $$i -le $(ITER) ]; do \
	    COUNTER=$$((COUNTER+1)); \
	    NOW=$$(date +%s); \
	    CURRENT_SEED=$$((NOW + COUNTER)); \
	    LOG_FILE="$(LOG_DIR)/$${test}_$${CURRENT_SEED}.log"; \
	    echo "Running $${test} (iteration $$i/$(ITER), seed=$${CURRENT_SEED})"; \
	    $(SIM) +UVM_TESTNAME=$${test} +UVM_VERBOSITY=$(VERBOSITY) +ntb_random_seed=$${CURRENT_SEED} \
	      $(COV_OPTS) -cm_dir $(COV_DIR) -cm_name $${test}_$${CURRENT_SEED} $(SIM_OPTS) \
	      -l "$${LOG_FILE}"; \
	    SIM_RC=$$?; \
	    if [ $$SIM_RC -eq 0 ] && grep -q 'UVM Report Summary' "$${LOG_FILE}" && \
	       grep -Eq '^UVM_ERROR[[:space:]]*:[[:space:]]*0[[:space:]]*$$' "$${LOG_FILE}" && \
	       grep -Eq '^UVM_FATAL[[:space:]]*:[[:space:]]*0[[:space:]]*$$' "$${LOG_FILE}"; then \
	      echo "$${test} $${CURRENT_SEED} PASS" >> $(OUT_DIR)/regr_status.txt; \
	    else \
	      echo "$${test} $${CURRENT_SEED} FAIL" >> $(OUT_DIR)/regr_status.txt; \
	    fi; \
	    i=$$((i+1)); \
	  done; \
	done; \
	$(MAKE) summary; \
	$(MAKE) report

summary:
	@echo ""
	@echo "Regression Summary"
	@echo "TESTNAME SEED STATUS"
	@if [ -f $(OUT_DIR)/regr_status.txt ]; then \
	  cat $(OUT_DIR)/regr_status.txt; \
	  echo "------------------------------"; \
	  TOTAL=$$(wc -l < $(OUT_DIR)/regr_status.txt); \
	  PASSED=$$(grep -c ' PASS$$' $(OUT_DIR)/regr_status.txt || true); \
	  FAILED=$$(grep -c ' FAIL$$' $(OUT_DIR)/regr_status.txt || true); \
	  echo "Total: $$TOTAL | Passed: $$PASSED | Failed: $$FAILED"; \
	else \
	  echo "No regression data found. Run make regression first."; \
	fi

report:
	@echo "Generating coverage report from $(COV_DIR)..."
	$(URG) -dir $(COV_DIR) -format both -report $(RPT_DIR)
	@echo "Coverage report: $(RPT_DIR)/dashboard.html  (text: $(RPT_DIR)/dashboard.txt)"

clean:
	rm -rf $(OUT_DIR) csrc simv simv.daidir *.log *.vpd *.fsdb *.vdb urgReport DVEfiles vc_hdrs.h ucli.key .vlogansetup.args
