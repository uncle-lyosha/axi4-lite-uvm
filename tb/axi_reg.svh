class ctrl_reg extends uvm_reg;
  `uvm_object_utils(ctrl_reg)

  rand uvm_reg_field data;

  function new(string name = "ctrl");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  // Конфигурация (родитель, ширина линии, доступ, изменчивость, rst, рандомизация, индивид. доступ)
  virtual function void build();
    data = uvm_reg_field::type_id::create("ctrl");
    data.configure(this, 32, 0, "RW", 1, 'h0, 1, 0, 1);     
  endfunction
endclass


class status_reg extends uvm_reg;
  `uvm_object_utils(status_reg)

  rand uvm_reg_field data;

  function new(string name = "status");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    data = uvm_reg_field::type_id::create("status");
    data.configure(this, 32, 0, "RO", 1, 'h0, 1, 0, 1);     
  endfunction
endclass


class data_in_reg extends uvm_reg;
  `uvm_object_utils(data_in_reg)

  rand uvm_reg_field data;

  function new(string name = "data_in");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    data = uvm_reg_field::type_id::create("data_in");
    data.configure(this, 32, 0, "RW", 1, 'h0, 1, 0, 1);     
  endfunction
endclass


class data_out_reg extends uvm_reg;
  `uvm_object_utils(data_out_reg)

  rand uvm_reg_field data;

  function new(string name = "data_out");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    data = uvm_reg_field::type_id::create("data_out");
    data.configure(this, 32, 0, "RO", 1, 'h0, 1, 0, 1);     
  endfunction
endclass
