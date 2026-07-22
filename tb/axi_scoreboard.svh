`uvm_analysis_imp_decl(_wr_i)
`uvm_analysis_imp_decl(_wr_o)
`uvm_analysis_imp_decl(_rd_i)
`uvm_analysis_imp_decl(_rd_o)

class axi_scrb extends uvm_scoreboard;
  `uvm_component_utils(axi_scrb)

  uvm_analysis_imp_wr_i #(axi_sequence_item, axi_scrb) axi_ap_wr_i;
  uvm_analysis_imp_wr_o #(axi_sequence_item, axi_scrb) axi_ap_wr_o;

  uvm_analysis_imp_rd_i #(axi_sequence_item, axi_scrb) axi_ap_rd_i;
  uvm_analysis_imp_rd_o #(axi_sequence_item, axi_scrb) axi_ap_rd_o;

  axi_sequence_item item_queue_wr_i[$];
  axi_sequence_item item_queue_wr_o[$];

  axi_sequence_item item_queue_rd_i[$];
  axi_sequence_item item_queue_rd_o[$];

  localparam OKAY 		 = 2'b00;
  localparam SLVERR 	 = 2'b10;
  localparam DECERR 	 = 2'b11;
  
  int log_file_h;

  extern function new(string name = "axi_scrb", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  // Writing in file
  extern function void connect_phase(uvm_phase phase);
  extern function void final_phase(uvm_phase phase);

  extern function void write_wr_i(axi_sequence_item item_wr);
  extern function void write_wr_o(axi_sequence_item item_wr);
  extern function void processing_wr();

  extern function void write_rd_i(axi_sequence_item item_rd);
  extern function void write_rd_o(axi_sequence_item item_rd);
  extern function void processing_rd();

  extern function void golden_model_wr(axi_sequence_item item_wr); 
  extern function void golden_model_rd(axi_sequence_item item_rd);  
endclass

function axi_scrb::new(string name = "axi_scrb", uvm_component parent);
  super.new(name, parent);
endfunction

function void axi_scrb::build_phase(uvm_phase phase);
  axi_ap_wr_i = new("axi_ap_wr_i", this); 
  axi_ap_wr_o = new("axi_ap_wr_o", this);

  axi_ap_rd_i = new("axi_ap_rd_i", this); 
  axi_ap_rd_o = new("axi_ap_rd_o", this); 
endfunction

// Creating and writing in scrb_result (../sim_uvm/*)
function void axi_scrb::connect_phase(uvm_phase phase);
  log_file_h = $fopen("scrb_results.log", "w");
  
  this.set_report_default_file(log_file_h);
  this.set_report_severity_action(UVM_INFO, UVM_LOG);
  this.set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
endfunction

// Closing the file
function void axi_scrb::final_phase(uvm_phase phase);
  $fclose(log_file_h);
endfunction

function void axi_scrb::write_wr_i(axi_sequence_item item_wr);
  item_queue_wr_i.push_back(item_wr);
endfunction

function void axi_scrb::write_wr_o(axi_sequence_item item_wr);
  item_queue_wr_o.push_back(item_wr);
  processing_wr();
endfunction

function void axi_scrb::write_rd_i(axi_sequence_item item_rd);
  item_queue_rd_i.push_back(item_rd);
endfunction

function void axi_scrb::write_rd_o(axi_sequence_item item_rd);
  item_queue_rd_o.push_back(item_rd);
  processing_rd();
endfunction

function void axi_scrb::golden_model_wr(axi_sequence_item item_wr);
  case(item_wr.awaddr)
    32'h0   : item_wr.bresp = OKAY;
    32'h4   : item_wr.bresp = SLVERR;
    32'h8   : item_wr.bresp = OKAY;
    32'hC   : item_wr.bresp = SLVERR;
    default : item_wr.bresp = DECERR;
  endcase
endfunction

function void axi_scrb::golden_model_rd(axi_sequence_item item_rd);
  case(item_rd.awaddr)
    32'h0   : item_rd.bresp = OKAY;
    32'h4   : item_rd.bresp = OKAY;
    32'h8   : item_rd.bresp = OKAY;
    32'hC   : item_rd.bresp = OKAY;
    default : item_rd.bresp = DECERR;
  endcase
endfunction

function void axi_scrb::processing_wr();
  axi_sequence_item item_wr_i;
  axi_sequence_item item_wr_o;
  string data_str_wr;

  item_wr_i = item_queue_wr_i.pop_front();
  golden_model_wr(item_wr_i);

  item_wr_o = item_queue_wr_o.pop_front();
  item_wr_o.awaddr = item_wr_i.awaddr; 
  item_wr_o.wstrb  = item_wr_i.wstrb; 

  data_str_wr = {
    "\n", "Write:",
    "\n", "actual:    ", item_wr_i.convert2string_wr(),
    "\n", "predicted: ", item_wr_o.convert2string_wr()
  };

  if(!item_wr_i.compare(item_wr_o))
    `uvm_error("FAIL", data_str_wr)
  else
    `uvm_info("PASS", data_str_wr, UVM_NONE)
endfunction

function void axi_scrb::processing_rd();
  axi_sequence_item item_rd_i;
  axi_sequence_item item_rd_o;
  string data_str_rd;

  item_rd_i = item_queue_rd_i.pop_front();
  golden_model_rd(item_rd_i);

  item_rd_o = item_queue_rd_o.pop_front();
  item_rd_o.araddr = item_rd_i.araddr;

  data_str_rd = {
    "\n", "Read:",
    "\n", "actual:    ", item_rd_i.convert2string_rd(),
    "\n", "predicted: ", item_rd_o.convert2string_rd()
  };

  if(!item_rd_i.compare(item_rd_o))
    `uvm_error("FAIL", data_str_rd)
  else
    `uvm_info("PASS", data_str_rd, UVM_NONE)
endfunction

