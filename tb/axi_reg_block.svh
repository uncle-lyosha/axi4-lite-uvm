class axi_reg_block extends uvm_reg_block;
  `uvm_object_utils(axi_reg_block)

  ctrl_reg     ctrl;
  status_reg   status;
  data_in_reg  data_in;
  data_out_reg data_out;

  uvm_reg_map axi_map;
  
  extern function new(string name = "axi_reg_block");
  extern function void build();
endclass

function axi_reg_block::new(string name = "axi_reg_block");
  super.new(name, UVM_NO_COVERAGE);
endfunction

function void axi_reg_block::build();
  ctrl = ctrl_reg::type_id::create("ctrl");
  ctrl.configure(this, null, "");
  ctrl.build();
  ctrl.add_hdl_path_slice("control_reg", 0, 32);

  status = status_reg::type_id::create("status");
  status.configure(this, null, "");
  status.build();
  status.add_hdl_path_slice("status_reg", 0, 32);

  data_in = data_in_reg::type_id::create("data_in");
  data_in.configure(this, null, "");
  data_in.build();
  data_in.add_hdl_path_slice("data_in_reg", 0, 32);

  data_out = data_out_reg::type_id::create("data_out");
  data_out.configure(this, null, "");
  data_out.build();
  data_out.add_hdl_path_slice("data_out_reg", 0, 32);

  // Create map dont use in backdor operation
  axi_map = create_map("AXI_map", 'h0, 4, UVM_LITTLE_ENDIAN);
  axi_map.add_reg(ctrl, 32'h0000_0000, "RW");
  axi_map.add_reg(status, 32'h0000_0004, "RO");
  axi_map.add_reg(data_in, 32'h0000_0008, "RW");
  axi_map.add_reg(data_out, 32'h0000_000C, "RO");

  add_hdl_path("axi_tb_top.axi4_lite_inst", "RTL");
  lock_model();
endfunction