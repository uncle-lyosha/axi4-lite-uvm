package axi_package;

  import uvm_pkg::*;
	`include "uvm_macros.svh"

  `include "axi_sequence_item.svh"

  `include "axi_reg.svh"
  `include "axi_reg_block.svh"

  typedef uvm_sequencer #(axi_sequence_item) axi_sequencer_wr;
  typedef uvm_sequencer #(axi_sequence_item) axi_sequencer_rd;

  `include "axi_driver.svh"
  `include "axi_sequence.svh"

  typedef uvm_analysis_port #(axi_sequence_item) axi_ap;
  `include "axi_monitor.svh"

  `include "axi_scoreboard.svh"
  `include "axi_coverage.svh"

  `include "axi_agent.svh"

  `include "axi_env.svh"

  `include "axi_test.svh"

endpackage