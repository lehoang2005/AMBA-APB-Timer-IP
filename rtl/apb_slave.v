module apb_slave (
	input wire        clk,
	input wire        rst_n,
	input wire 	  psel,
	input wire 	  penable,
	input wire 	  pwrite,
	input wire 	  error,
	
	output wire 	  pready,
	output wire 	  wr_en,
	output wire 	  rd_en,
	output wire 	  pslverr
);
	wire wait_state_pre;
	reg wait_state;

	assign wait_state_pre = (psel & penable) & ~wait_state; 

	always@ (posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			wait_state <= 1'b0;
		else 
			wait_state <= wait_state_pre;	
	end
	
	assign wr_en  = psel & penable & pwrite & pready;
	assign rd_en  = psel & penable & ~pwrite & pready;
	assign pready = wait_state;
	assign pslverr = wr_en & error;

endmodule
