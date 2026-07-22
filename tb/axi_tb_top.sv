module axi_tb_top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import axi_package::*;

	bit aclk, aresetn;

	axi_intf intf(aclk, aresetn);

	axi4_lite  axi4_lite_inst (
    .aclk			(intf.aclk),
    .aresetn	(intf.aresetn),

    .awaddr		(intf.awaddr),
    .awvalid	(intf.awvalid),
    .awready	(intf.awready),

    .wdata		(intf.wdata),
    .wstrb		(intf.wstrb),
    .wvalid		(intf.wvalid),
    .wready		(intf.wready),

    .bresp		(intf.bresp),
    .bvalid		(intf.bvalid),
    .bready		(intf.bready),
    
    .araddr		(intf.araddr),
    .arvalid	(intf.arvalid),
    .arready	(intf.arready),

    .rdata		(intf.rdata),
    .rresp		(intf.rresp),
    .rvalid		(intf.rvalid),
    .rready		(intf.rready)
  );

	initial begin
		forever #(5ns) aclk = ~aclk; 
	end

	initial begin
		aresetn <= 1'b0;
		repeat(10) @(posedge aclk);
		aresetn <= 1'b1;
	end

	initial begin
		uvm_config_db#(virtual axi_intf)::set(null, "*", "intf", intf);
		run_test("axi_test");
	end
endmodule