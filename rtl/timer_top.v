module timer_top (
	input wire        sys_clk,
	input wire        sys_rst_n,
	input wire        tim_psel,
	input wire        tim_pwrite,
	input wire        tim_penable,
	input wire [11:0] tim_paddr,
	input wire [31:0] tim_pwdata,
	input wire [3:0]  tim_pstrb,
	input wire	  dbg_mode,

	output wire[31:0] tim_prdata,
	output wire	  tim_pready,
	output wire	  tim_pslverr,
	output wire	  tim_int
);
wire wr_en, rd_en;
wire error;
wire cnt_en, cnt_clr;
wire [63:0] cnt;
wire [63:0] cmp_cnt;
wire int_trigger, int_en, int_st;
wire halt_ack, halt_req;
wire timer_en;
wire [3:0] div_val;
wire div_en;
wire [31:0] wdata;
wire [7:0] byte_sel;

apb_slave apb (
		.clk	(sys_clk),
		.rst_n	(sys_rst_n),
		.psel	(tim_psel),
		.penable(tim_penable),
		.pwrite	(tim_pwrite),
		.error	(error),
		.pready	(tim_pready),
		.wr_en 	(wr_en),
		.rd_en	(rd_en),
		.pslverr(tim_pslverr)
	);

register u_register(
	.clk		 (sys_clk),
	.rst_n 		 (sys_rst_n),
	.paddr		 (tim_paddr),
	.pwdata		 (tim_pwdata),
	.pstrb		 (tim_pstrb),
	.wr_en		 (wr_en),
	.rd_en		 (rd_en),
	.cnt		 (cnt),
	.int_trigger	 (int_trigger),
	.halt_ack	 (halt_ack),
	
	.error		 (error),
	.timer_en	 (timer_en),
	.div_en		 (div_en),
	.div_val	 (div_val),
	.wdata		 (wdata),
	.tdr01_byte_sel	 (byte_sel),
	.cmp_cnt	 (cmp_cnt),
	.int_en		 (int_en),
	.int_st		 (int_st),
	.halt_req	 (halt_req),
	.prdata		 (tim_prdata)
);

counter_control u_control (
	.clk 		(sys_clk),
	.rst_n		(sys_rst_n),
	.timer_en	(timer_en),
	.div_en		(div_en),
	.div_val	(div_val),
	.halt_req	(halt_req),
	.dbg_mode	(dbg_mode),
	
	.halt_ack	(halt_ack),
	.cnt_en		(cnt_en),
	.cnt_clr	(cnt_clr)
);

counter u_counter (
	.clk		(sys_clk),
	.rst_n		(sys_rst_n),
	.cnt_en		(cnt_en),
	.cnt_clr	(cnt_clr),
	.tdr01_byte_sel	(byte_sel),
	.wdata		(wdata),

	.cnt		(cnt)
);

interrupt u_int (
	.cnt		(cnt),
	.cmp_cnt	(cmp_cnt),
	.int_en		(int_en),
	.int_st		(int_st),

	.int_trigger	(int_trigger),
	.tim_int	(tim_int)
);
endmodule
