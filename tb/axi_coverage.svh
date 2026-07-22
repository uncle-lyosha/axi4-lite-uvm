//----------------------------------------------------------------------
//    WRITE
//----------------------------------------------------------------------
class axi_coverage_wr extends uvm_subscriber #(axi_sequence_item);
  `uvm_component_utils(axi_coverage_wr)

  axi_sequence_item item;
  int item_cnt;
  int cov_log_file_h;
  
  covergroup cov1;
    cp_data_wr : coverpoint item.wdata {
      bins wdata_pkt_c [256] = {[0:$]};
    }
    cp_addr_wr : coverpoint item.awaddr {
      bins awaddr_pkt_c [4] = {0, 4, 8, 12};
    }
    cp_strb_wr : coverpoint item.wstrb {
      bins strb_pkt_c [4] = {0, 1, 2, 3};
    }
    cross cp_data_wr, cp_strb_wr;
    cross cp_data_wr, cp_addr_wr;
  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(axi_sequence_item t);
  extern function void connect_phase(uvm_phase phase);
  extern function void final_phase(uvm_phase phase);
endclass

function void axi_coverage_wr::connect_phase(uvm_phase phase);
  cov_log_file_h = $fopen("coverage_results_wr.log", "w");
  
  this.set_report_default_file(cov_log_file_h);
  this.set_report_severity_action(UVM_INFO, UVM_LOG);
endfunction

function void axi_coverage_wr::final_phase(uvm_phase phase);
  $fclose(cov_log_file_h);
endfunction

function axi_coverage_wr::new(string name, uvm_component parent);
  super.new(name, parent);
  cov1 = new();
endfunction

function void axi_coverage_wr::write (axi_sequence_item t);
  real current_coverage;

  item = t;
  item_cnt++;
  cov1.sample();
  current_coverage = $get_coverage();

  `uvm_info("COVERAGE", $sformatf("Write: %0d Packets sampled, Coverage = %f%% ", item_cnt, current_coverage), UVM_MEDIUM)
endfunction


//----------------------------------------------------------------------
//    READ
//----------------------------------------------------------------------
class axi_coverage_rd extends uvm_subscriber #(axi_sequence_item);
  `uvm_component_utils(axi_coverage_rd)

  axi_sequence_item item;
  int item_cnt;
  int cov_log_file_h;
  
  covergroup cov1;
    cp_data_rd : coverpoint item.rdata {
      bins ardata_pkt_c [256] = {[0:$]};
    }
    cp_addr_rd : coverpoint item.araddr {
      bins araddr_pkt_c [4] = {0, 4, 8, 12};
    }
    cross cp_data_rd, cp_addr_rd;
  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(axi_sequence_item t);
  extern function void connect_phase(uvm_phase phase);
  extern function void final_phase(uvm_phase phase);
endclass

function void axi_coverage_rd::connect_phase(uvm_phase phase);
  cov_log_file_h = $fopen("coverage_results_rd.log", "w");
  
  this.set_report_default_file(cov_log_file_h);
  this.set_report_severity_action(UVM_INFO, UVM_LOG);
endfunction

function void axi_coverage_rd::final_phase(uvm_phase phase);
  $fclose(cov_log_file_h);
endfunction

function axi_coverage_rd::new(string name, uvm_component parent);
  super.new(name, parent);
  cov1 = new();
endfunction

function void axi_coverage_rd::write (axi_sequence_item t);
  real current_coverage;

  item = t;
  item_cnt++;
  cov1.sample();
  current_coverage = $get_coverage();

  `uvm_info("COVERAGE", $sformatf("Read: %0d Packets sampled, Coverage = %f%% ", item_cnt, current_coverage), UVM_MEDIUM)
endfunction
