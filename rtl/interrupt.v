module interrupt (
	input wire [63:0] cnt,
	input wire [63:0] cmp_cnt,
	input wire	  int_en,
	input wire	  int_st,

	output wire int_trigger,
	output wire tim_int
);
assign int_trigger = (cnt == cmp_cnt);
assign tim_int 	   = int_en & int_st;
endmodule
