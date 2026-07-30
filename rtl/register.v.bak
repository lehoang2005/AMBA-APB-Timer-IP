module register(
	input wire	  clk,
	input wire	  rst_n,
	input wire [11:0] paddr,
	input wire [31:0] pwdata,
	input wire [3:0]  pstrb,
	input wire	  wr_en,
	input wire	  rd_en,
	input wire [63:0] cnt,
	input wire 	  int_trigger,
	input wire 	  halt_ack,
	
	output wire 	  error,
	output reg 	  timer_en,
	output reg 	  div_en,
	output reg  [3:0] div_val,
	output wire [31:0]wdata,
	output wire [7:0] tdr01_byte_sel,
	output wire [63:0]cmp_cnt,
	output reg 	  int_en,
	output reg 	  int_st,
	output reg 	  halt_req,
	output reg [31:0] prdata
);

wire err_prohibit_value, err_change_div_val, err_change_div_en;
wire safe;
wire timer_en_sel, div_en_sel, div_val_sel;
wire timer_en_pre;
wire div_en_pre;
wire [3:0] div_val_pre;
reg [31:0] tcmp0_r, tcmp1_r;
wire tcr_w, tdr0_w, tdr1_w, tcmp0_w, tcmp1_w, tier_w, tisr_w, thcsr_w;

assign tcr_w = wr_en & (paddr == 12'h00);
assign tdr0_w = wr_en & (paddr == 12'h04);
assign tdr1_w = wr_en & (paddr == 12'h08);
assign tcmp0_w = wr_en & (paddr == 12'h0C);
assign tcmp1_w = wr_en & (paddr == 12'h10);
assign tier_w = wr_en & (paddr == 12'h14);
assign tisr_w = wr_en & (paddr == 12'h18);
assign thcsr_w = wr_en & (paddr == 12'h1C);


//TCR
//=================================
//Error response
assign err_prohibit_value = tcr_w & pstrb[1] & (pwdata[11:8] > 4'b1000);
assign err_change_div_val = tcr_w & timer_en & pstrb[1] & (div_val != pwdata[11:8]);
assign err_change_div_en  = tcr_w & timer_en & pstrb[0] & (div_en  != pwdata[1]);
assign error = err_prohibit_value | err_change_div_val | err_change_div_en;
assign safe  = tcr_w &~error;

//FLIPFLOP
assign timer_en_sel = pstrb[0] & safe;
assign div_en_sel   = pstrb[0] & safe;
assign div_val_sel = pstrb[1] & safe;

assign timer_en_sel = pstrb[0] & safe;
assign div_en_sel   = pstrb[0] & safe;
assign div_val_sel = pstrb[1] & safe;

assign timer_en_pre = timer_en_sel ? pwdata[0] : timer_en;
assign div_en_pre   = div_en_sel   ? pwdata[1] : div_en;
assign div_val_pre  = div_val_sel  ? pwdata[11:8] : div_val;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		timer_en <= 0;
		div_en   <= 0;
		div_val  <= 4'b0001;
	end
	else begin 
		timer_en <= timer_en_pre;
		div_en   <= div_en_pre;
		div_val  <= div_val_pre;
	end
end
//TDR0/1
//=====================================================
assign tdr01_byte_sel[0] = tdr0_w & pstrb[0];
assign tdr01_byte_sel[1] = tdr0_w & pstrb[1];
assign tdr01_byte_sel[2] = tdr0_w & pstrb[2];
assign tdr01_byte_sel[3] = tdr0_w & pstrb[3];

assign tdr01_byte_sel[4] = tdr1_w & pstrb[0];
assign tdr01_byte_sel[5] = tdr1_w & pstrb[1];
assign tdr01_byte_sel[6] = tdr1_w & pstrb[2];
assign tdr01_byte_sel[7] = tdr1_w & pstrb[3];
assign wdata = pwdata;

//TCMP0/1
//===================================================== 
always@ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) 
		tcmp0_r <= 32'hFFFF_FFFF;
	else if (tcmp0_w == 1'b1) begin 
		 if (pstrb[0] == 1'b1) 
			 tcmp0_r[7:0] <= pwdata[7:0];
		 if (pstrb[1] == 1'b1) 
			 tcmp0_r[15:8] <= pwdata[15:8];
		 if (pstrb[0] == 1'b1) 
			 tcmp0_r[23:16] <= pwdata[23:16];
		 if (pstrb[0] == 1'b1) 
			 tcmp0_r[31:24] <= pwdata[31:24];
		 end
end

always@ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) 
		tcmp1_r <= 32'hFFFF_FFFF;
	else if (tcmp1_w == 1'b1) begin 
		 if (pstrb[0] == 1'b1) 
			 tcmp1_r[7:0] <= pwdata[7:0];
		 if (pstrb[1] == 1'b1) 
			 tcmp1_r[15:8] <= pwdata[15:8];
		 if (pstrb[0] == 1'b1) 
			 tcmp1_r[23:16] <= pwdata[23:16];
		 if (pstrb[0] == 1'b1) 
			 tcmp1_r[31:24] <= pwdata[31:24];
		 end
end

assign cmp_cnt = {tcmp1_r, tcmp0_r};
//TIER
//====================================================
always@ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		int_en <= 1'b0;
	else if (tier_w == 1'b1) begin
		if (pstrb[0] == 1'b1)
			int_en <= pwdata[0];	
	end
end

//TISR
//====================================================
always@ (posedge clk or negedge rst_n) begin 
	if (rst_n == 1'b0) 
		int_st <= 1'b0;
	else if (tisr_w  && pstrb[0] && pwdata[0])
		int_st <= 1'b0;
	else if (int_trigger == 1'b1)
		int_st <= 1'b1;
end

//THCSR
//=====================================================
always@ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) 
		halt_req <= 1'b0;
	else if (thcsr_w == 1'b1)
		if (pstrb[0] == 1'b1)
		       halt_req <= pwdata[0];	
end
//=====================================================
//READ PATH
always@ (*) begin
	if (rd_en == 1'b1) begin
		case (paddr)
			12'h00: prdata = {20'h0, div_val, 6'b0, div_en, timer_en}; 
			12'h04: prdata = {cnt[31:0]};
			12'h08: prdata = {cnt[63:32]};
			12'h0C: prdata = {tcmp0_r[31:0]};
			12'h10: prdata = {tcmp1_r[31:0]};
			12'h14: prdata = {31'h0, int_en};
			12'h18: prdata = {31'h0, int_st};
			12'h1C: prdata = {30'h0, halt_ack, halt_req};
			default: prdata = 32'h0;
		endcase	
	end
	else
		prdata = 32'h0;
	end
endmodule
