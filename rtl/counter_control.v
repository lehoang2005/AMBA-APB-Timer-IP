module counter_control (
	input wire 	 clk,
	input wire 	 rst_n,
	input wire 	 timer_en,
	input wire 	 div_en,
	input wire [3:0] div_val,
	input wire  	 halt_req,
	input wire 	 dbg_mode,
	
	output reg 	 halt_ack,
	output wire 	 cnt_en,
	output wire 	 cnt_clr
);
wire halt_ack_pre;
reg timer_en_d;
wire [7:0] threshold;
wire prescalar;
wire  [7:0] data_pre_cnt;
reg  [7:0] pre_cnt;

assign halt_ack_pre = dbg_mode & halt_req; 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) 
		halt_ack <= 1'b0;
	else 
		halt_ack <= halt_ack_pre;
end

//============================================
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		timer_en_d <= 0;
	else 
		timer_en_d <= timer_en;
end
assign cnt_clr = timer_en_d & (~timer_en);

//===========================================
assign threshold = (8'h1 << div_val) - 1;
assign prescalar = (~halt_ack) & timer_en;
assign data_pre_cnt = (cnt_clr == 1'b1) ? 8'b0 : 
		      (prescalar == 1'b0) ? pre_cnt : 
		      ((~div_en) | (pre_cnt == threshold)) ? 8'b0 : (pre_cnt + 1);

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) 
		pre_cnt <= 0;
	else 
		pre_cnt <= data_pre_cnt;
end

assign cnt_en = prescalar & ((~div_en) | (pre_cnt == threshold));

endmodule

