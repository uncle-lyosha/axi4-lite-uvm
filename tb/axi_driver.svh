//----------------------------------------------------------------------
//    WRITE
//----------------------------------------------------------------------
class axi_driver_wr extends uvm_driver #(axi_sequence_item);
  `uvm_component_utils(axi_driver_wr)

  virtual axi_intf intf;

  axi_sequence_item item;

  extern function new(string name = "axi_driver_wr", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  
  extern task driver_wr(axi_sequence_item item);

  extern task drvr_addr_first(axi_sequence_item item);
  extern task drvr_data_first(axi_sequence_item item);
  extern task drvr_data_addr_together(axi_sequence_item item);
  extern task drvr_quickly_bready_addr_data(axi_sequence_item item);
  extern task drvr_quickly_bready_data_addr(axi_sequence_item item);

  extern task write_addr(axi_sequence_item item);
  extern task write_data(axi_sequence_item item);
  extern task write_response(axi_sequence_item item);
  extern task default_values_wr();
endclass

function axi_driver_wr::new(string name = "axi_driver_wr", uvm_component parent);
	super.new(name, parent);
endfunction

function void axi_driver_wr::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual axi_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in drv_wr")
endfunction

task axi_driver_wr::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(item);

      default_values_wr();
      driver_wr(item);

    seq_item_port.item_done();
  end
endtask

task axi_driver_wr::driver_wr(axi_sequence_item item);
  case(item.mode_wr)
    WR_ADDR_FIRST            : drvr_addr_first(item);
    WR_DATA_FIRST            : drvr_data_first(item);
    DATA_ADDR_TOGETHER       : drvr_data_addr_together(item);
    QUICKLY_BREADY_DATA_ADDR : drvr_quickly_bready_addr_data(item);
    QUICKLY_BREADY_ADDR_DATA : drvr_quickly_bready_data_addr(item);
    WR_ERR_DEC               : drvr_addr_first(item);
    WR_ERR_SLV               : drvr_addr_first(item);
  endcase
endtask

task axi_driver_wr::drvr_addr_first(axi_sequence_item item);
  repeat(item.delay) @(posedge intf.aclk);
  write_addr(item);
  repeat(item.delay_1) @(posedge intf.aclk);
  write_data(item);
  repeat(item.delay_2) @(posedge intf.aclk);
  write_response(item);
endtask

task axi_driver_wr::drvr_data_first(axi_sequence_item item);
  repeat(item.delay) @(posedge intf.aclk);
  write_data(item);
  repeat(item.delay_1) @(posedge intf.aclk);
  write_addr(item);
  repeat(item.delay_2) @(posedge intf.aclk);
  write_response(item);
endtask

task axi_driver_wr::drvr_data_addr_together(axi_sequence_item item);
  repeat(item.delay) @(posedge intf.aclk);
  fork
    write_data(item);
    write_addr(item);
  join  
    write_response(item);
endtask

task axi_driver_wr::drvr_quickly_bready_addr_data(axi_sequence_item item);
  repeat(item.delay) @(posedge intf.aclk);
  intf.bready = 1'b1;
  write_addr(item);
  repeat(item.delay_1) @(posedge intf.aclk);
  write_data(item);
  repeat(item.delay_2) @(posedge intf.aclk);
  write_response(item);
endtask

task axi_driver_wr::drvr_quickly_bready_data_addr(axi_sequence_item item);
  repeat(item.delay) @(posedge intf.aclk);
  intf.bready = 1'b1;
  write_data(item);
  repeat(item.delay_1) @(posedge intf.aclk);
  write_addr(item);
  repeat(item.delay_2) @(posedge intf.aclk);
  write_response(item);
endtask

task axi_driver_wr::write_addr(axi_sequence_item item);
  intf.awvalid = 1'b1; 
  intf.awaddr  = item.awaddr;
  @(posedge intf.aclk);
  wait(intf.awready && intf.awvalid);
  @(posedge intf.aclk);
  intf.awvalid = 1'b0;
endtask

task axi_driver_wr::write_data(axi_sequence_item item);
  intf.wvalid = 1'b1;
  intf.wdata  = item.wdata;
  intf.wstrb  = item.wstrb;
  @(posedge intf.aclk);
  wait(intf.wvalid && intf.wready);
  @(posedge intf.aclk);
  intf.wvalid = 1'b0;
endtask

task axi_driver_wr::write_response(axi_sequence_item item);
  intf.bready = 1'b1;
  @(posedge intf.aclk);
  wait(intf.bready && intf.bvalid);
  @(posedge intf.aclk);
  intf.bready = 1'b0;
endtask

task axi_driver_wr::default_values_wr();
  intf.awvalid = 1'b0;
  intf.wvalid  = 1'b0;
  intf.bready  = 1'b0;
  intf.wdata   = 32'b0; 
  intf.awaddr  = 32'b0; 
  intf.wstrb   = 4'b0;
endtask


//----------------------------------------------------------------------
//    READ
//----------------------------------------------------------------------
class axi_driver_rd extends uvm_driver #(axi_sequence_item);
  `uvm_component_utils(axi_driver_rd)

  virtual axi_intf intf;

  axi_sequence_item item;

  extern function new(string name = "axi_driver_rd", uvm_component parent);
  extern task run_phase(uvm_phase phase);
  extern function void build_phase(uvm_phase phase);

  extern task driver_rd(axi_sequence_item item);
  extern task drvr_rd_addr_first(axi_sequence_item item);
  extern task drvr_rd_data_first(axi_sequence_item item);
  extern task drvr_rd_err_dec(axi_sequence_item item);
  extern task drvr_rd_quickly_rready(axi_sequence_item item);

  extern task read_addr(axi_sequence_item item);
  extern task read_data(axi_sequence_item item);
  extern task default_values_rd();
endclass

function axi_driver_rd::new(string name = "axi_driver_rd", uvm_component parent);
	super.new(name, parent);
endfunction

function void axi_driver_rd::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual axi_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in drv_rd")
endfunction

task axi_driver_rd::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(item);

      default_values_rd();
      driver_rd(item);
      
    seq_item_port.item_done();
  end
endtask

task axi_driver_rd::driver_rd(axi_sequence_item item);
  case(item.mode_rd)
    RD_ADDR_FIRST  : drvr_rd_addr_first(item);
    RD_DATA_FIRST  : drvr_rd_data_first(item);
    RD_ERR_DEC     : drvr_rd_err_dec(item);
    QUICKLY_RREADY : drvr_rd_quickly_rready(item);
  endcase
endtask

task axi_driver_rd::drvr_rd_addr_first(axi_sequence_item item);
  repeat(item.delay) @(posedge intf.aclk);
  read_addr(item);
  repeat(item.delay_1) @(posedge intf.aclk);
  read_data(item);
  repeat(item.delay_2) @(posedge intf.aclk);
endtask

task axi_driver_rd::drvr_rd_data_first(axi_sequence_item item);
  fork
    begin
      repeat(item.delay) @(posedge intf.aclk);
      read_data(item);
      repeat(item.delay_1) @(posedge intf.aclk);
      read_addr(item);
      repeat(item.delay_2) @(posedge intf.aclk);
    end
    begin
      repeat(item.delay + item.delay_1 + item.delay_2 + 10) @(posedge intf.aclk);
    end
  join_any
    disable fork;
endtask

task axi_driver_rd::drvr_rd_err_dec(axi_sequence_item item);
  drvr_rd_addr_first(item);
endtask

task axi_driver_rd::drvr_rd_quickly_rready(axi_sequence_item item);
  // Read addr
  intf.arvalid = 1'b1; 
  intf.araddr  = item.araddr;
  @(posedge intf.aclk);
  wait(intf.arready && intf.arvalid);
  intf.rready = 1'b1;
  @(posedge intf.aclk);
  intf.arvalid = 1'b0;

  // Read data
  wait(intf.rready && intf.rvalid);
  @(posedge intf.aclk);
  intf.rready = 1'b0;
endtask

task axi_driver_rd::read_addr(axi_sequence_item item);
  intf.arvalid = 1'b1; 
  intf.araddr  = item.araddr;
  @(posedge intf.aclk);
  wait(intf.arready && intf.arvalid);
  @(posedge intf.aclk);
  intf.arvalid = 1'b0;
endtask

task axi_driver_rd::read_data(axi_sequence_item item);
  intf.rready = 1'b1;
  @(posedge intf.aclk);
  wait(intf.rready && intf.rvalid);
  @(posedge intf.aclk);
  intf.rready = 1'b0;
endtask

task axi_driver_rd::default_values_rd();
  intf.rready  = 1'b0;
  intf.arvalid = 1'b0;
  intf.araddr  = 32'b0;
  @(posedge intf.aclk);
endtask