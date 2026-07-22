SIM_DIR     = sim
COV_DIR     = $(SIM_DIR)/cov
SRC_DIR     = src
TB_DIR      = tb
SCRIPT_DIR  = script

TEST        = axi_test
SEED        = random
LOG_FILE    = sim.log

RTL_SRC     = $(wildcard $(SRC_DIR)/*.v)
UVM_SRC     = $(wildcard $(TB_DIR)/*.sv)

.PHONY: all clean compile run gui

all: run

compile: $(SIM_DIR)/.compile_rtl $(SIM_DIR)/.compile_tb

$(SIM_DIR)/.compile_rtl: $(RTL_SRC)
	@mkdir -p $(SIM_DIR)
	vlib $(SIM_DIR)/work
	vmap work $(SIM_DIR)/work
	vlog -work work -incr $(RTL_SRC)
# 	@touch $@

$(SIM_DIR)/.compile_tb: $(SIM_DIR)/.compile_rtl $(UVM_SRC)
	vlog -work work -incr +incdir+$(TB_DIR) +define+UVM_NO_DEPRECATED -L uvm $(UVM_SRC)
# 	@touch $@

# CLI
run: compile
# 	@mkdir -p $(COV_DIR)
	cd $(SIM_DIR) && vsim -c -do "set argv [list $(TEST) $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)

# GUI
gui: compile
# 	@mkdir -p $(COV_DIR)
	cd $(SIM_DIR) && vsim -do "set argv [list $(TEST) $(SEED) 0]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)

clean:
	rm -rf $(SIM_DIR)/* vsim.wlf transcript modelsim.ini

regress: compile
	@mkdir -p $(SIM_DIR)/axi_test
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test

	@mkdir -p $(SIM_DIR)/axi_test_error_dec
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test_error_dec $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test_error_dec
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test_error_dec
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test_error_dec
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test_error_dec

	@mkdir -p $(SIM_DIR)/axi_test_error_slv
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test_error_slv $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test_error_slv
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test_error_slv
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test_error_slv
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test_error_slv

	@mkdir -p $(SIM_DIR)/axi_test_data_first
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test_data_first $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test_data_first
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test_data_first
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test_data_first
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test_data_first
	
	@mkdir -p $(SIM_DIR)/axi_test_together
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test_together $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test_together
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test_together
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test_together
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test_together
	
	@mkdir -p $(SIM_DIR)/axi_test_quickly_bready_data_addr
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test_quickly_bready_data_addr $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test_quickly_bready_data_addr
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test_quickly_bready_data_addr
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test_quickly_bready_data_addr
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test_quickly_bready_data_addr
	
	@mkdir -p $(SIM_DIR)/axi_test_quickly_bready_addr
	cd $(SIM_DIR) && vsim -c -do "set argv [list axi_test_quickly_bready_addr $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)
	@mv $(SIM_DIR)/coverage_results_rd.log $(SIM_DIR)/axi_test_quickly_bready_addr
	@mv $(SIM_DIR)/coverage_results_wr.log $(SIM_DIR)/axi_test_quickly_bready_addr
	@mv $(SIM_DIR)/scrb_results.log $(SIM_DIR)/axi_test_quickly_bready_addr
	@mv $(SIM_DIR)/sim.log $(SIM_DIR)/axi_test_quickly_bready_addr