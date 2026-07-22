module axi4_lite(
	// Global
		input         aclk
	, input         aresetn

	//-------WRITE----------
	// Write Address
	, input [31:0]  awaddr
	, input         awvalid
	, output        awready

	// Write Data
	, input [31:0]  wdata
	, input [3:0]   wstrb
	, input         wvalid
	, output        wready

	// Write Response
	, output [1:0]  bresp
	, output        bvalid
	, input         bready

	//-------READ----------
	// Read Address 
	, input [31:0]  araddr
	, input         arvalid
	, output        arready

	// Read Data
	, output [31:0] rdata
	, output [1:0]  rresp
	, output        rvalid
	, input         rready
);

//-----------------------------------------
//    Parameter declaration
//-----------------------------------------
localparam IDLE      = 0;

localparam WRITE     = 1;
localparam RESPONSE  = 2;

localparam READ_ADDR = 1;
localparam READ_DATA = 2;

localparam OKAY 		 = 2'b00;
localparam SLVERR 	 = 2'b10;
localparam DECERR 	 = 2'b11;

// Write reg
reg [31:0] awaddr_r;
reg [31:0] wdata_r;
reg [3:0]  wstrb_r;
reg [1:0]  bresp_r;

// Read reg
reg [31:0] araddr_r;
reg [31:0] rdata_r;
reg [1:0]  rresp_r;

// State of FSM
reg [1:0] next_w, next_r;
reg [1:0] state_w, state_r;

// State memory map
reg [1:0] state_bresp;

// Handshake
reg hsh_aw;
reg hsh_w;
reg hsh_ar;
reg hsh_r;

// Write reg (handshake)
reg awready_r;
reg wready_r;
reg bvalid_r;
reg arready_r;
reg rvalid_r;

reg one_ready_wr;
reg one_ready_rd;
// Erorrs
// reg err_slv;


//-----------------------------------------
//		Memory map													
//-----------------------------------------
//	ADDR	| 		REG		  |		Function		|
//	0x00	| 	CTRL		  |			W/R				|	
//	0x04	| 	STATUS	  |			 R				|		
//	0x08	|  	DATA_IN	  |			W/R				|
//	0x0C	| 	DATA_OUT 	|			 R				|
//-----------------------------------------

reg [31:0] control_reg;
reg [31:0] status_reg;
reg [31:0] data_in_reg;
reg [31:0] data_out_reg;

function reg [31:0] data_with_strb (input reg [31:0] current_reg, input reg [31:0] data, input reg [3:0] strb);
	begin
		data_with_strb = current_reg;
		if (strb[0]) data_with_strb[7:0]   = data[7:0];
		if (strb[1]) data_with_strb[15:8]  = data[15:8];
		if (strb[2]) data_with_strb[23:16] = data[23:16];
		if (strb[3]) data_with_strb[31:24] = data[31:24];
	end
endfunction

always @(posedge aclk) begin
	if (!aresetn) begin
		control_reg  <= 32'b0;
		status_reg   <= 32'b0;
		data_in_reg  <= 32'b0;
		data_out_reg <= 32'b0;
		state_bresp  <= OKAY;
		rdata_r			 <= 32'b0;
		rresp_r			 <= 2'b0;
	end else begin

		// 		WRITE		//
		if ((state_w == WRITE) && hsh_aw && hsh_w)
			case (awaddr_r)
				32'h0 : begin
					control_reg <= data_with_strb(control_reg, wdata_r, wstrb_r);
					state_bresp <= OKAY;
				end 
				32'h4 : begin
					state_bresp <= SLVERR;
				end
				32'h8 : begin
					data_in_reg = data_with_strb(data_in_reg, wdata_r, wstrb_r);
					state_bresp <= OKAY;
				end
				32'hC : begin
					state_bresp <= SLVERR;
				end
				default: begin
					state_bresp <= DECERR;
				end
			endcase

		// 		READ 		//
		if ((state_r == READ_DATA) && (rready && rvalid))
			case (araddr_r)
				32'h0 : begin
					rdata_r <= control_reg;
					rresp_r <= 2'b00;
				end
				32'h4 : begin
					rdata_r <= status_reg;
					rresp_r <= 2'b00;
				end
				32'h8 : begin
					rdata_r <= data_in_reg;
					rresp_r <= 2'b00;
				end
				32'hC : begin
					rdata_r <= data_out_reg;
					rresp_r <= 2'b00;
				end
				default : begin
					rresp_r <= 2'b00;
					rdata_r <= 32'b0;
				end
			endcase
	end
end

//-----------------------------------------
//    Write FSM 
//-----------------------------------------
always @(posedge aclk or negedge aresetn) begin
	if (!aresetn) state_w <= IDLE;
	else          state_w <= next_w;
end

always @(*) begin
	next_w = 2'bx;
	case (state_w)
		IDLE    : next_w = WRITE;
		WRITE   : if (hsh_aw && hsh_w) 	next_w = RESPONSE;
							else               	 	next_w = WRITE;
		RESPONSE: if (bvalid && bready)	next_w = WRITE;
							else									next_w = RESPONSE;
	endcase
end

always @(posedge aclk) begin
	case (state_w)
		IDLE : begin
			awaddr_r  	 <= 32'b0;
			wdata_r   	 <= 32'b0;
			wstrb_r   	 <= 4'b0;
			hsh_aw	  	 <= 1'b0;
			hsh_w		  	 <= 1'b0;
			wready_r  	 <= 1'b0;
			awready_r 	 <= 1'b0;
			bvalid_r  	 <= 1'b0;
			bresp_r	  	 <= 2'b0;
			one_ready_wr <= 1'b0;
		end
		WRITE : begin
			bvalid_r <= 1'b0;
			if (!one_ready_wr) begin
				wready_r  	 <= 1'b1;
				awready_r 	 <= 1'b1;
				one_ready_wr <= 1'b1;
			end

			if (awvalid && awready) begin
				hsh_aw 		<= 1'b1;
				awaddr_r 	<= awaddr;
				awready_r <= 1'b0;
			end

			if (wvalid && wready) begin
				hsh_w  		<= 1'b1;
				wdata_r 	<= wdata;
				wstrb_r 	<= wstrb;
				wready_r  <= 1'b0;
			end
		end
		RESPONSE : begin
			bvalid_r  	 <= 1'b1;
			wready_r  	 <= 1'b1;
			awready_r 	 <= 1'b1;
			one_ready_wr <= 1'b0;
			if (bready && bvalid) begin
				hsh_aw 	 <= 1'b0;
				hsh_w  	 <= 1'b0;
				case (state_bresp)
					OKAY	 : bresp_r <= 2'b00;
					SLVERR : bresp_r <= 2'b10;
					DECERR : bresp_r <= 2'b11;
					default: bresp_r <= 2'b10;
				endcase
			end
		end
	endcase
end

assign awready = awready_r;
assign wready  = wready_r;
assign bvalid  = bvalid_r;
assign bresp   = bresp_r;

//-----------------------------------------
//    Read FSM 
//-----------------------------------------
always @(posedge aclk or negedge aresetn) begin
	if (!aresetn)	state_r <= IDLE;
	else 					state_r <= next_r;
end

always @(*) begin
	case (state_r)
		IDLE 			: next_r = READ_ADDR; 
		READ_ADDR : if (hsh_ar) next_r = READ_DATA;
								else 				next_r = READ_ADDR;
		READ_DATA : if (hsh_r)  next_r = READ_ADDR;
								else 				next_r = READ_DATA;
		default   : next_r = IDLE;
	endcase
end

always @(posedge aclk) begin
	case (state_r)
		IDLE 			: begin
			hsh_ar			 <= 1'b0;
			hsh_r				 <= 1'b0;
			arready_r		 <= 1'b0;
			araddr_r		 <= 32'b0;
			one_ready_rd <= 1'b0;
		end
		READ_ADDR : begin
			hsh_r <= 1'b0;
			if (!one_ready_rd) begin
				arready_r 	 <= 1'b1;
				one_ready_rd <= 1'b1;
			end

			if (arready && arvalid) begin
				hsh_ar 		<= 1'b1;
				araddr_r 	<= araddr;
				arready_r <= 1'b0;
			end
		end
		READ_DATA : begin
			rvalid_r 		 <= 1'b1;
			hsh_ar 	 		 <= 1'b0;
			arready_r 	 <= 1'b1;
			one_ready_rd <= 1'b0;
			if (rready && rvalid) begin
				hsh_r 	 <= 1'b1;
				rvalid_r <= 1'b0;
			end
		end
	endcase
end

assign arready = arready_r;
assign rvalid  = rvalid_r;
assign rresp 	 = rresp_r;
assign rdata 	 = rdata_r;

endmodule