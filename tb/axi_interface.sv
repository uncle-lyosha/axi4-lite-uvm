interface axi_intf(input bit aclk, input bit aresetn);
	//-------WRITE----------
	// Write Address
	logic [31:0] awaddr;
	logic        awvalid;
	logic        awready;

	// Write Data
	logic [31:0] wdata;
	logic [3:0]  wstrb;
	logic        wvalid;
	logic        wready;

	// Write Response
	logic [1:0]  bresp;
	logic        bvalid;
	logic        bready;

	//-------READ----------
	// Read Address 
	logic [31:0] araddr;
	logic        arvalid;
	logic        arready;

	// Read Data
	logic [31:0] rdata;
	logic [1:0]  rresp;
	logic        rvalid;
	logic        rready;
endinterface