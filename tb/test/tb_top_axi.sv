module axi4_lite_tb;

  // Parameters

  //Ports
  reg aclk;
  reg aresetn;
  reg [31:0] awaddr;
  reg awvalid;
  wire awready;
  reg [31:0] wdata;
  reg [3:0] wstrb;
  reg wvalid;
  wire wready;
  wire [1:0] bresp;
  wire bvalid;
  reg bready;
  reg [31:0] araddr;
  reg arvalid;
  wire arready;
  wire [31:0] rdata;
  wire [1:0] rresp;
  wire rvalid;
  reg rready;

  axi4_lite  axi4_lite_inst (
    .aclk(aclk),
    .aresetn(aresetn),

    .awaddr(awaddr),
    .awvalid(awvalid),
    .awready(awready),

    .wdata(wdata),
    .wstrb(wstrb),
    .wvalid(wvalid),
    .wready(wready),

    .bresp(bresp),
    .bvalid(bvalid),
    .bready(bready),
    
    .araddr(araddr),
    .arvalid(arvalid),
    .arready(arready),

    .rdata(rdata),
    .rresp(rresp),
    .rvalid(rvalid),
    .rready(rready)
  );

  initial begin
    aclk = 1'b0;
    forever #(5ns) aclk = ~aclk ;
  end

  initial begin
    aresetn = 1'b0;
    repeat (10) @(posedge aclk);
    aresetn = 1'b1;
    @(posedge aclk);
    awvalid = 1'b1;
    awaddr  = 32'h0000_0000;
    @(posedge aclk);
    wait(awready);
    @(posedge aclk);
    wvalid = 1'b1;
    wdata = 32'hAAAA_BBBB;
    wstrb = 4'b1011;
    bready = 1'b1;
    wait(wready);
    @(posedge aclk);
    wvalid = 1'b0;
    awvalid = 1'b0;
    wait(bvalid)
    repeat(10) @(posedge aclk);
    $stop();
  end
endmodule