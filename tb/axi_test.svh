class axi_test extends uvm_test;
  `uvm_component_utils(axi_test)

  seq_wr_addr_first axi_sequence_wr;
  seq_rd_addr_first axi_sequence_rd;
  axi_env env;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function axi_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test::build_phase(uvm_phase phase);
  env = axi_env::type_id::create("env", this);
  axi_sequence_wr = seq_wr_addr_first::type_id::create("axi_sequence_wr");
  axi_sequence_rd = seq_rd_addr_first::type_id::create("axi_sequence_rd");
endfunction

task axi_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
    fork
      axi_sequence_wr.start(env.agent_wr.seqr_wr);
      axi_sequence_rd.start(env.agent_rd.seqr_rd);
    join
  phase.drop_objection(this);
endtask


//========================================================================
class axi_test_error_dec extends axi_test;
  `uvm_component_utils(axi_test_error_dec)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function axi_test_error_dec::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test_error_dec::build_phase(uvm_phase phase);
  super.build_phase(phase);

  seq_wr_addr_first::type_id::set_type_override(seq_wr_err_dec::get_type());
  seq_rd_addr_first::type_id::set_type_override(seq_rd_err_dec::get_type());
endfunction


//========================================================================
class axi_test_error_slv extends axi_test;
  `uvm_component_utils(axi_test_error_slv)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function axi_test_error_slv::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test_error_slv::build_phase(uvm_phase phase);
  super.build_phase(phase);

  seq_wr_addr_first::type_id::set_type_override(seq_wr_err_slv::get_type());
  seq_rd_addr_first::type_id::set_type_override(seq_rd_err_dec::get_type());
endfunction


//========================================================================
class axi_test_data_first extends axi_test;
  `uvm_component_utils(axi_test_data_first)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function axi_test_data_first::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test_data_first::build_phase(uvm_phase phase);
  super.build_phase(phase);

  seq_wr_addr_first::type_id::set_type_override(seq_wr_data_first::get_type());
  seq_rd_addr_first::type_id::set_type_override(seq_rd_data_first::get_type());
endfunction


//========================================================================
class axi_test_together extends axi_test;
  `uvm_component_utils(axi_test_together)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function axi_test_together::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test_together::build_phase(uvm_phase phase);
  super.build_phase(phase);

  seq_wr_addr_first::type_id::set_type_override(seq_data_addr_together::get_type());
endfunction


//========================================================================
class axi_test_quickly_bready_data_addr extends axi_test;
  `uvm_component_utils(axi_test_quickly_bready_data_addr)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function axi_test_quickly_bready_data_addr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test_quickly_bready_data_addr::build_phase(uvm_phase phase);
  super.build_phase(phase);

  seq_wr_addr_first::type_id::set_type_override(seq_quickly_bready_data_addr::get_type());
  seq_rd_addr_first::type_id::set_type_override(seq_quickly_rready::get_type());
endfunction


//========================================================================
class axi_test_quickly_bready_addr extends axi_test;
  `uvm_component_utils(axi_test_quickly_bready_addr)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function axi_test_quickly_bready_addr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_test_quickly_bready_addr::build_phase(uvm_phase phase);
  super.build_phase(phase);

  seq_wr_addr_first::type_id::set_type_override(seq_quickly_bready_addr_data::get_type());
  seq_rd_addr_first::type_id::set_type_override(seq_rd_data_first::get_type());
endfunction