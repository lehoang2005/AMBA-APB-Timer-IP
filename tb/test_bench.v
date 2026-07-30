module test_bench;
    reg clk, rst_n;
    reg psel, penable, pwrite;
    reg  [31:0] paddr;
    reg  [31:0] pwdata;
    reg  [3:0]  pstrb;
    reg 	dbg_mode;
    wire 	pready;
    wire 	pslverr;
    wire [31:0] prdata;
    wire	tim_int;

    parameter ADDR_TCR   = 12'h0;
    parameter ADDR_TDR0  = 12'h4;
    parameter ADDR_TDR1  = 12'h8;
    parameter ADDR_TCMP0 = 12'hC;
    parameter ADDR_TCMP1 = 12'h10;
    parameter ADDR_TIER  = 12'h14;
    parameter ADDR_TISR  = 12'h18;
    parameter ADDR_THCSR = 12'h1C;

    timer_top dut
    (
        .sys_clk     (   clk     ),
        .sys_rst_n   (   rst_n   ),
	.tim_psel    (	 psel	 ),
	.tim_pwrite  (	 pwrite  ),
	.tim_penable (	 penable ),
        .tim_paddr   (   paddr   ),
        .tim_pwdata  (   pwdata  ),
	.tim_pstrb   (	 pstrb   ),
	.dbg_mode    (	 dbg_mode),
        .tim_prdata  (   prdata   ),
	.tim_pready  (	 pready   ),
	.tim_pslverr (	 pslverr  ),
	.tim_int     (	 tim_int  )
    );
	
    reg apb_err_psel, apb_err_penable;
    integer err;

    initial begin 
  	  clk = 0;
  	  forever #10 clk = ~clk;
	end

  initial begin
	  dbg_mode = 0;
	  psel = 0;
	  penable = 0;
	  pwrite = 0;
	  paddr = 0;
	  pwdata = 0;
	  pstrb = 0;
	  dbg_mode = 0;
	  apb_err_psel = 0;
	  apb_err_penable = 0;
	  err = 0;	

  	  rst_n = 1'b0;
	  #25 rst_n = 1'b1;
  end

  `include "run_test.v"
  initial begin
 	#100;
	run_test();
	#100;
	check_pass_fail();
	#100;
	$finish;
  end

  task check_pass_fail();
	  if (err != 0) begin
	 	$display("TEST STATUS: FAIL");
	  end
	  else begin
	 	$display("TEST STATUS: PASS");
	  end
  endtask

  task apb_write;
	input [31:0] t_addr;
	input [31:0] t_wdata;
	input [3:0]  t_pstrb;	
	output 	     t_pslverr;

	begin
	   $display ("t=%10d [TB_WRITE]: paddr = %x | pwdata = %x | pstrb = %x", $time, t_addr, t_wdata, t_pstrb);
	   @(posedge clk);
	   #1;
	   paddr = t_addr;
	   pwdata = t_wdata;
	   pstrb = t_pstrb;
	   psel = 1 & !apb_err_psel;
	   pwrite = 1;

	   @(posedge clk);
	   #1;
	   penable = 1 & !apb_err_penable;
	   #1;
	   if (!apb_err_psel && !apb_err_penable) begin
	   wait (pready == 1'b1);
   	   end
	   else begin
	   @(posedge clk);
	   end
	   #1;
	   t_pslverr = pslverr;
	   if (t_pslverr == 1'b1) begin
	  	$display("t=%10d tim_pslverr is asserted. The data is violated", $time);
	   end
	   else begin
	  	$display("tim_pslverr is not asserted.");
	   end

	   @(posedge clk);
	   #1;
	   pwrite = 0;
	   psel = 0;
	   penable = 0;
	   paddr = 0;
	   pwdata = 0;
	   pstrb = 0;
	end
  endtask 

  task apb_read;
	  input  [31:0]  t_addr;
	  output [31:0] t_rdata;
	  begin	
	  @(posedge clk);
	  #1;
	  paddr = t_addr;
	  psel = 1 & !apb_err_psel;
	  pwrite = 0;
	  
	  @(posedge clk);
 	  #1;
	  penable = 1 & !apb_err_penable;
	  #1;
	  if (!apb_err_psel && !apb_err_penable) begin
	  wait (pready == 1'b1);
  	  end
	  else begin
	 	@(posedge clk);
	  end
	  #1;
	  t_rdata = prdata;

	  @(posedge clk);
	  #1;
	  psel = 0;
	  penable = 0;
	  pwrite = 0;
	  paddr = 0;
	  pwdata = 0;
	  
	  $display("t=%10d [TB_READ]: paddr = %x prdata = %x", $time, t_addr, t_rdata);
	  end
	endtask
 
  task cmp_data;
	  input [31:0] in_addr;
	  input [31:0] in_data;
	  input [31:0] exp_data;
	  input [31:0] mask;
	  
	  if ((in_data & mask) !== (exp_data & mask)) begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAIL: prdata is not correct \033[0m]", $time);
		  $display ("At Address: %x Exp: %x Actual: %x", in_addr, exp_data, in_data);
		  $display ("-------------------------------------------------");
		  err = err+1;
	  end else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASS: prdata 32'%x at addr %x is  correct \033[0m]", $time, in_data, in_addr);
		  $display ("-------------------------------------------------");
	  end
  endtask

  endmodule
