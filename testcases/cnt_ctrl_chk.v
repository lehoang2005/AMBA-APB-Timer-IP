task run_test();
reg[31:0] task_rdata;
reg[63:0] cnt;
reg reg_err;
	
begin
	$display("====================================================");
	$display("=====Test Case: check counter control mode =========");
	$display("====================================================");

	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	$display("**********Check init div_val");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0003,	4'h1, reg_err);
	repeat (100) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] > 50 && cnt[63:0] < 55) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h2,	4'h1, reg_err);

	$display("**********Check div_en = 0");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0501,	4'hF, reg_err);
	repeat (120) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] < 130 && cnt[63:0] > 120) begin     
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
	test_bench.apb_write (ADDR_TCR, 32'h0, 4'h1, reg_err);

	$display("**********Check all different div_val");
	$display("--- div_val = 0 ---");
	test_bench.apb_write (ADDR_TDR0, 32'hffff_ff00, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0003,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:32] == 1 && cnt[31:0] < 5) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h2,	4'h1, reg_err);
	
	$display("---div_val = 1 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0103,	4'hF, reg_err);
	repeat (100) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] > 50 && cnt[63:0] < 55) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h102, 4'hF, reg_err);

	$display("---div_val = 2 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0203,	4'hF, reg_err);
	repeat (200) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 50) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h202, 4'h1, reg_err);



	$display("---div_val = 3 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0303,	4'hF, reg_err);
	repeat (400) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 50) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h302, 4'h1, reg_err);


	$display("---div_val = 4 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0403,	4'hF, reg_err);
	repeat (160) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 10) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h402, 4'h1, reg_err);

	$display("---div_val = 5 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0503,	4'hF, reg_err);
	repeat (160) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 5) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h202, 4'h1, reg_err);


	$display("---div_val = 6 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0603,	4'hF, reg_err);
	repeat (320) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 5) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h602, 4'h1, reg_err);

	$display("---div_val = 7 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0703,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 2) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h702, 4'h1, reg_err);

	$display("---div_val = 8 ---");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0803,	4'hF, reg_err);
	repeat (512) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 2) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h802, 4'h1, reg_err);

	$display("**********Check prescalar reset");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h23092005,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0803,	4'hF, reg_err);
	repeat (100) @(posedge clk);

	test_bench.apb_write (ADDR_TCR , 32'h0000_0802,	4'h1, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0000_0803,	4'h1, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 1) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: cnt =%16h | The prescalar works correct \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: cnt =%16h  not match expect value \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	test_bench.apb_write (ADDR_TCR , 32'h202, 4'h1, reg_err);
end
endtask
