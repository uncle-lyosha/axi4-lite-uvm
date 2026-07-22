//----------------------------------------------------------------------
//    WRITE
//----------------------------------------------------------------------
class axi_monitor_wr extends uvm_monitor;
  `uvm_component_utils(axi_monitor_wr)

  virtual axi_intf intf;

  axi_ap axi_ap_i;
  axi_ap axi_ap_o;

  axi_reg_block reg_model;

  axi_sequence_item item_i;
  axi_sequence_item item_o;

  extern function new(string name = "axi_monitor_wr", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task monitoring_wr(axi_sequence_item item_i, axi_sequence_item item_o);
  extern task wait_addr_wr(axi_sequence_item item_i);
  extern task wait_data_wr(axi_sequence_item item_i);
  extern task wait_response_wr(axi_sequence_item item_o);
  
  extern task read_register(axi_sequence_item item_i, axi_sequence_item item_o);
endclass

function axi_monitor_wr::new(string name = "axi_monitor_wr", uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_monitor_wr::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual axi_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in monitor_wr")
  if(!uvm_config_db#(axi_reg_block)::get(null, "", "reg_model", reg_model)) `uvm_fatal("BFM", "Failed to get reg_model in seq")
  axi_ap_i = new("axi_ap_i", this);
  axi_ap_o = new("axi_ap_o", this);
endfunction

task axi_monitor_wr::run_phase(uvm_phase phase);
  forever begin
    item_i = axi_sequence_item::type_id::create("item_i_wr");
    item_o = axi_sequence_item::type_id::create("item_o_wr");

    item_i.kind = WRITE;
    item_o.kind = WRITE;

    monitoring_wr(item_i, item_o);
  end
endtask

task axi_monitor_wr::monitoring_wr(axi_sequence_item item_i, axi_sequence_item item_o);
  fork
    wait_addr_wr(item_i);
    wait_data_wr(item_i);
    wait_response_wr(item_o);
  join
    read_register(item_i, item_o);
    axi_ap_i.write(item_i);
    axi_ap_o.write(item_o);
endtask

task axi_monitor_wr::wait_addr_wr(axi_sequence_item item_i);
  @(posedge intf.aclk);
  wait(intf.awready && intf.awvalid);
  item_i.awaddr = intf.awaddr;
  @(posedge intf.aclk);
endtask

task axi_monitor_wr::wait_data_wr(axi_sequence_item item_i);
  @(posedge intf.aclk);
  wait(intf.wready && intf.wvalid);
  item_i.wdata = intf.wdata;
  item_i.wstrb = intf.wstrb;
  @(posedge intf.aclk);
endtask

task axi_monitor_wr::wait_response_wr(axi_sequence_item item_o);
  @(posedge intf.aclk);
  wait(intf.bready && intf.bvalid);
  item_o.bresp = intf.bresp;
  @(posedge intf.aclk);
endtask

task axi_monitor_wr::read_register(axi_sequence_item item_i, axi_sequence_item item_o);
  bit [31:0] reg_val;
  uvm_status_e status;

  // if (reg_model == null) `uvm_error("REG", "Reg model is null")

  if(item_i.awaddr == 'h0) reg_model.ctrl.peek(status, reg_val);
  if(item_i.awaddr == 'h4) reg_model.status.peek(status, reg_val);
  if(item_i.awaddr == 'h8) reg_model.data_in.peek(status, reg_val);
  if(item_i.awaddr == 'hC) reg_model.data_out.peek(status, reg_val);

  item_o.wdata = reg_val;
endtask

//----------------------------------------------------------------------
//    READ
//----------------------------------------------------------------------
class axi_monitor_rd extends uvm_monitor;
  `uvm_component_utils(axi_monitor_rd)

  virtual axi_intf intf;

  axi_ap axi_ap_i;
  axi_ap axi_ap_o;

  axi_reg_block reg_model;

  axi_sequence_item item_i;
  axi_sequence_item item_o;

  extern function new(string name = "axi_monitor_rd", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task monitoring_rd(axi_sequence_item item_i, axi_sequence_item item_o);
  extern task wait_addr_rd(axi_sequence_item item_i);
  extern task wait_data_rd(axi_sequence_item item_o);

  extern task read_register(axi_sequence_item item_i);
endclass

function axi_monitor_rd::new(string name = "axi_monitor_rd", uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_monitor_rd::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual axi_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in monitor_rd")
  if(!uvm_config_db#(axi_reg_block)::get(null, "", "reg_model", reg_model)) `uvm_fatal("BFM", "Failed to get reg_model in seq")
  axi_ap_i = new("axi_ap_i", this);
  axi_ap_o = new("axi_ap_o", this);
endfunction

task axi_monitor_rd::run_phase(uvm_phase phase);
  forever begin
    item_i = axi_sequence_item::type_id::create("item_i_rd");
    item_o = axi_sequence_item::type_id::create("item_o_rd");

    item_i.kind = READ;
    item_o.kind = READ;

    monitoring_rd(item_i, item_o);
  end
endtask

task axi_monitor_rd::monitoring_rd(axi_sequence_item item_i, axi_sequence_item item_o);
  fork
    wait_addr_rd(item_i);
    wait_data_rd(item_o);
  join
    axi_ap_i.write(item_i);
    axi_ap_o.write(item_o);
endtask

task axi_monitor_rd::wait_addr_rd(axi_sequence_item item_i);
  read_register(item_i);
  @(posedge intf.aclk);
  wait(intf.arready && intf.arvalid);
  item_i.araddr = intf.araddr;
  @(posedge intf.aclk);  
endtask

task axi_monitor_rd::wait_data_rd(axi_sequence_item item_o);
  @(posedge intf.aclk);
  wait(intf.rready && intf.rvalid);
  item_o.rdata = intf.rdata;
  item_o.rresp = intf.rresp;
  @(posedge intf.aclk);
endtask

task axi_monitor_rd::read_register(axi_sequence_item item_i);
  bit [31:0] reg_val;
  uvm_status_e status;

  // if (reg_model == null) `uvm_error("REG", "Reg model is null")

  if(intf.araddr == 'h0) reg_model.ctrl.peek(status, reg_val);
  if(intf.araddr == 'h4) reg_model.status.peek(status, reg_val);
  if(intf.araddr == 'h8) reg_model.data_in.peek(status, reg_val);
  if(intf.araddr == 'hC) reg_model.data_out.peek(status, reg_val);

  item_i.rdata = reg_val;
endtask