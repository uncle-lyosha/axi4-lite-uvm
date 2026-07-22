typedef enum {READ, WRITE} axi_kind;

typedef enum {WR_ADDR_FIRST, 
              WR_DATA_FIRST, 
              DATA_ADDR_TOGETHER, 
              QUICKLY_BREADY_DATA_ADDR,
              QUICKLY_BREADY_ADDR_DATA, 
              WR_ERR_DEC, 
              WR_ERR_SLV } scenarios_wr;

typedef enum {RD_ADDR_FIRST, 
              RD_DATA_FIRST, 
              RD_ERR_DEC, 
              QUICKLY_RREADY } scenarios_rd;
              
class axi_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(axi_sequence_item)

  // Global
  rand axi_kind kind;
  randc int delay;
  randc int delay_1;
  randc int delay_2;
  randc int rst_delay;

  // Register
  rand bit [31:0] register;

  // Write
  rand scenarios_wr mode_wr;

  rand  bit [31:0] awaddr;
  randc bit [31:0] wdata;
  randc bit [3:0]  wstrb;
        bit [1:0]  bresp;

  // Read
  rand scenarios_rd mode_rd;

  rand bit [31:0] araddr;
  bit [31:0] rdata;
  bit [1:0]  rresp;

  constraint delay_c {
    delay     inside {[0:250]};
    delay_1   inside {[0:100]};
    delay_2   inside {[0:100]};
    rst_delay inside {[300:1000]};
  }

  constraint scenarios_c {
    soft mode_wr == WR_ADDR_FIRST;
    soft mode_rd == RD_ADDR_FIRST;
  }

  constraint addr_wr_c {
    solve mode_wr before awaddr;
    if (mode_wr == WR_ERR_DEC) {
      awaddr inside {[32'hD:$]};
    } else if (mode_wr == WR_ERR_SLV) {
      awaddr inside {32'h04, 32'h0C};
    } else {
      awaddr inside {32'h00, 32'h08};
    }
  }

  constraint addr_c {
    solve mode_rd before araddr;
    if (mode_rd == RD_ERR_DEC) {
      araddr inside {[32'hD:$]};
    } else {
      araddr inside {32'h00, 32'h04, 32'h08, 32'h0C};
    }
  }

  extern function new(string name = "axi_sequence_item");
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string_wr();
  extern function string convert2string_rd();

endclass

function axi_sequence_item::new(string name = "axi_sequence_item");
  super.new(name);
endfunction

function string axi_sequence_item::convert2string_wr(); // Просто функция для конвертирования значения в тип string 
  string s;
  s = $sformatf("awaddr = %h, wdata = %h, wstrb = %b, bresp = %b", awaddr, wdata, wstrb, bresp);
  return s;
endfunction

function string axi_sequence_item::convert2string_rd(); // Просто функция для конвертирования значения в тип string 
  string s;
  s = $sformatf("araddr = %h, rdata = %h, rresp = %b", araddr, rdata, rresp);
  return s;
endfunction

function bit axi_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  axi_sequence_item rhs_;

  if (!$cast(rhs_, rhs)) begin
    `uvm_error("COMP_MISTMATCH", "Error type of the comparing obkect")
    return 0;
  end else begin
    if (kind == WRITE) return((super.do_compare(rhs, comparer)) && (awaddr == rhs_.awaddr)
                                                                && ((bresp == 2'b0) ? ((wstrb[0] ? (wdata[7:0]   == rhs_.wdata[7:0])   : 1)
                                                                                   && (wstrb[1] ? (wdata[15:8]  == rhs_.wdata[15:8])  : 1)
                                                                                   && (wstrb[2] ? (wdata[23:16] == rhs_.wdata[23:16]) : 1)
                                                                                   && (wstrb[3] ? (wdata[31:24] == rhs_.wdata[31:24]) : 1)) : 1)
                                                                && (wstrb == rhs_.wstrb)
                                                                && (bresp == rhs_.bresp));
    if (kind == READ)  return((super.do_compare(rhs, comparer)) && (araddr == rhs_.araddr)
                                                                && (rdata == rhs_.rdata)
                                                                && (rresp == rhs_.rresp));
  end
endfunction