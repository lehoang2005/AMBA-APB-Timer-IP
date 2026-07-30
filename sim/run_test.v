task run_test();
reg [31:0] task_rdata;
reg reg_err;
reg [63:0] cnt;

begin
	$display("====================================================");
	$display("==============Test Case: check Halt Mode ===========");
	$display("====================================================");
	
	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;
	
	$display("*****Check stop and resume of halted mode");
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);
	repeat(100) @(posedge clk);
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;

	if (cnt[63:0] > 100 && cnt[63:0] < 110) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: cnt =%16h  match expected value \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: cnt =%16h  not match expect value \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

	$display("Assert dbg_mode & halt_req");
	dbg_mode = 1'b1;
	test_bench.apb_write (ADDR_THCSR, 32'h1, 4'hf, reg_err);
	repeat(100) @(posedge clk);
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	if (cnt[63:0] == 113) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: cnt =%16h is halted \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: cnt =%16h is not halted \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

	$display("Check halt_ack");
	test_bench.apb_read (ADDR_THCSR, task_rdata);
	test_bench.cmp_data (ADDR_THCSR, task_rdata, 32'h3, 32'hffff_ffff);
	
	$display("Resume counting after Halted mode");
	test_bench.apb_write (ADDR_THCSR, 32'h0, 4'hf, reg_err);
	repeat (50) @(posedge clk);
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;

	if (cnt[63:0] > 160 && cnt[63:0] < 170) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: cnt =%16h counts correct after halted \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: cnt =%16h counts wrong after halted \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	test_bench.apb_write(ADDR_TCR, 32'h0, 4'hf, reg_err);

	$display("*****Check TDR access while halted");
	test_bench.apb_write(ADDR_TCR, 32'h0, 4'hf, reg_err);
	test_bench.apb_write(ADDR_TCR, 32'h1, 4'hf, reg_err);

	test_bench.apb_write (ADDR_THCSR, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR0, 32'hffff, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'hffff_0000, 4'hf, reg_err);
	repeat (50) @(posedge clk);	
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'hffff, 32'hffff_ffff);

	test_bench.apb_read (ADDR_TDR1, task_rdata);
	test_bench.cmp_data (ADDR_TDR1, task_rdata, 32'hffff_0000, 32'hffff_ffff);

end
endtask
