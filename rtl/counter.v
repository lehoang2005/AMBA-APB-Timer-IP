module counter (
	input wire	 clk,
	input wire	 rst_n,
	input wire	 cnt_en,
	input wire 	 cnt_clr,
	input wire [7:0] tdr01_byte_sel,
	input wire [31:0]wdata,

	output reg [63:0]cnt
);
reg[63:0] cnt_pre;

always @(*) begin
	cnt_pre = cnt;
	if (cnt_clr == 1'b1)
		cnt_pre = 64'h0;
	else if (tdr01_byte_sel != 8'h0) begin
		if (tdr01_byte_sel[0] == 1) 
			cnt_pre[7:0] = wdata[7:0];
		if (tdr01_byte_sel[1] == 1) 
			cnt_pre[15:8] = wdata[15:8];
		if (tdr01_byte_sel[2] == 1) 
			cnt_pre[23:16] = wdata[23:16];
		if (tdr01_byte_sel[3] == 1) 
			cnt_pre[31:24] = wdata[31:24];
		if (tdr01_byte_sel[4] == 1) 
			cnt_pre[39:32] = wdata[7:0];
		if (tdr01_byte_sel[5] == 1) 
			cnt_pre[47:40] = wdata[15:8];
		if (tdr01_byte_sel[6] == 1) 
			cnt_pre[55:48] = wdata[23:16];
		if (tdr01_byte_sel[7] == 1) 
			cnt_pre[63:56] = wdata[31:24];
	end
	else if (cnt_en == 1'b1)
		cnt_pre = cnt + 1; 
		end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
	       cnt <= 64'h0;
	else 
		cnt <= cnt_pre;	
end

endmodule
