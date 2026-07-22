class axi_sequence extends uvm_sequence #(axi_sequence_item);
  `uvm_object_utils(axi_sequence)

  axi_sequence_item item;

  axi_reg_block reg_model;
  uvm_status_e status;

  function new(string name = "axi_sequence");
    super.new(name);
  endfunction

  task body();
    item = axi_sequence_item::type_id::create("item");

    if(!uvm_config_db#(axi_reg_block)::get(null, "", "reg_model", reg_model)) `uvm_fatal("BFM", "Failed to get reg_model in seq")

    random_equal();
  endtask

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize());

      finish_item(item);
    end
  endtask
endclass

//----------------------------------------------------------------------
//    WRITE
//----------------------------------------------------------------------
class seq_wr_addr_first extends axi_sequence;
  `uvm_object_utils(seq_wr_addr_first)

  function new(string name = "seq_wr_addr_first");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == WR_ADDR_FIRST;});

      finish_item(item);
    end
  endtask
endclass

class seq_wr_data_first extends axi_sequence;
  `uvm_object_utils(seq_wr_data_first)

  function new(string name = "seq_wr_data_first");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == WR_DATA_FIRST;});

      finish_item(item);
    end
  endtask
endclass

class seq_data_addr_together extends axi_sequence;
  `uvm_object_utils(seq_data_addr_together)

  function new(string name = "seq_data_addr_together");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == DATA_ADDR_TOGETHER;});

      finish_item(item);
    end
  endtask
endclass

class seq_quickly_bready_data_addr extends axi_sequence;
  `uvm_object_utils(seq_quickly_bready_data_addr)

  function new(string name = "seq_quickly_bready_data_addr");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == QUICKLY_BREADY_DATA_ADDR;});

      finish_item(item);
    end
  endtask
endclass

class seq_quickly_bready_addr_data extends axi_sequence;
  `uvm_object_utils(seq_quickly_bready_addr_data)

  function new(string name = "seq_quickly_bready_addr_data");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == QUICKLY_BREADY_ADDR_DATA;});

      finish_item(item);
    end
  endtask
endclass

class seq_wr_err_dec extends axi_sequence;
  `uvm_object_utils(seq_wr_err_dec)

  function new(string name = "seq_wr_err_dec");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == WR_ERR_DEC;});

      finish_item(item);
    end
  endtask
endclass

class seq_wr_err_slv extends axi_sequence;
  `uvm_object_utils(seq_wr_err_slv)

  function new(string name = "seq_wr_err_slv");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == WRITE; item.mode_wr == WR_ERR_SLV;});

      finish_item(item);
    end
  endtask
endclass


//----------------------------------------------------------------------
//    READ
//----------------------------------------------------------------------
class seq_rd_addr_first extends axi_sequence;
  `uvm_object_utils(seq_rd_addr_first)

  function new(string name = "seq_rd_addr_first");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == READ; item.mode_wr == RD_ADDR_FIRST;});
        reg_model.status.poke(status, item.register);
        reg_model.data_out.poke(status, item.register);

      finish_item(item);
    end
  endtask 
endclass

class seq_rd_data_first extends axi_sequence;
  `uvm_object_utils(seq_rd_data_first)

  function new(string name = "seq_rd_data_first");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == READ; item.mode_wr == RD_DATA_FIRST;});
        reg_model.status.poke(status, item.register);
        reg_model.data_out.poke(status, item.register);

      finish_item(item);
    end
  endtask 
endclass

class seq_rd_err_dec extends axi_sequence;
  `uvm_object_utils(seq_rd_err_dec)

  function new(string name = "seq_rd_err_dec");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == READ; item.mode_wr == RD_ERR_DEC;});
        reg_model.status.poke(status, item.register);
        reg_model.data_out.poke(status, item.register);

      finish_item(item);
    end
  endtask 
endclass

class seq_quickly_rready extends axi_sequence;
  `uvm_object_utils(seq_quickly_rready)

  function new(string name = "seq_quickly_rready");
    super.new(name);
  endfunction

  virtual task random_equal();
    repeat(2500) begin
      start_item(item);

        assert(item.randomize() with {item.kind == READ; item.mode_wr == QUICKLY_RREADY;});
        reg_model.status.poke(status, item.register);
        reg_model.data_out.poke(status, item.register);

      finish_item(item);
    end
  endtask 
endclass