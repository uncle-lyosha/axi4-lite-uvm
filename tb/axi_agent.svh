//----------------------------------------------------------------------
//    WRITE
//----------------------------------------------------------------------
class axi_agent_wr extends uvm_agent;
  `uvm_component_utils(axi_agent_wr)

  axi_sequencer_wr seqr_wr;
  axi_driver_wr    driver_wr;
  axi_monitor_wr   monitor_wr;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

function axi_agent_wr::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void axi_agent_wr::build_phase(uvm_phase phase);
  seqr_wr    = uvm_sequencer#(axi_sequence_item)::type_id::create("seqr_wr", this);
  driver_wr  = axi_driver_wr::type_id::create("driver_wr", this);
  monitor_wr = axi_monitor_wr::type_id::create("monitor_wr", this);
endfunction

function void axi_agent_wr::connect_phase(uvm_phase phase);
  driver_wr.seq_item_port.connect(seqr_wr.seq_item_export);
endfunction


//----------------------------------------------------------------------
//    READ
//----------------------------------------------------------------------
class axi_agent_rd extends uvm_agent;
  `uvm_component_utils(axi_agent_rd)

  axi_sequencer_rd seqr_rd;
  axi_driver_rd    driver_rd;
  axi_monitor_rd   monitor_rd;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

function axi_agent_rd::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void axi_agent_rd::build_phase(uvm_phase phase);
  seqr_rd    = uvm_sequencer#(axi_sequence_item)::type_id::create("seqr_rd", this);
  driver_rd  = axi_driver_rd::type_id::create("driver_rd", this);
  monitor_rd = axi_monitor_rd::type_id::create("monitor_rd", this);
endfunction

function void axi_agent_rd::connect_phase(uvm_phase phase);
  driver_rd.seq_item_port.connect(seqr_rd.seq_item_export);
endfunction
