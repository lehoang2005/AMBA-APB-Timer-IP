task run_test();
reg[31:0] task_rdata;
reg[63:0] cnt;
reg reg_err;
begin
	$display("====================================================");
	$display("=====Test Case: check counter counting check =======");
	$display("====================================================");

	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	$display("**********Check at boundary of TDR0");
	test_bench.apb_write (ADDR_TDR0, 32'hFFFF_FF00, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h1,	4'hF, reg_err);
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
	test_bench.apb_write (ADDR_TCR , 32'h0,	4'hF, reg_err);

	
	$display("**********Check at boundary of TDR1");
	test_bench.apb_write (ADDR_TDR0, 32'hFFFF_FF00, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'hFFFF_FFFF,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h1,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:32] == 0 && cnt[31:0] < 5) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h0,	4'hF, reg_err);


	$display("**********Check at writing to counter when counting");
	$display("A: check TDR0");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h1,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] > 255 && cnt[63:0] < 260) begin     
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
	test_bench.apb_write (ADDR_TDR0, 32'hffff_ff00,	4'hF, reg_err);
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
	test_bench.apb_write (ADDR_TCR , 32'h0,	4'hF, reg_err);



	$display("**********Check at writing to counter when counting");
	$display("B: check TDR1");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h1,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] > 255 && cnt[63:0] < 260) begin     
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
	test_bench.apb_write (ADDR_TDR0, 32'hffff_ff00,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'hffff_ffff,	4'hF, reg_err);
	repeat (253) @(posedge clk); //latency of protocol
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:32] == 0 && cnt[31:0] < 5) begin     
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
	test_bench.apb_write (ADDR_TCR , 32'h0,	4'hF, reg_err);


	$display("**********Check counter does not count when timer_en = 0");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h0,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] == 0) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: cnt =%16h  does not count \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: cnt =%16h  still count when timer_en = 0 \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	test_bench.apb_write (ADDR_TCR , 32'h0,	4'hF, reg_err);


	$display("**********Check counter clear when timer_en H -> L");
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0,	4'hF, reg_err);
	test_bench.apb_write (ADDR_TCR , 32'h1,	4'hF, reg_err);
	repeat (256) @(posedge clk);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	// check 
	if (cnt[63:0] > 255  && cnt[63:0] < 260) begin     
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
	test_bench.apb_write(ADDR_TCR, 32'h0, 4'hF, reg_err);
	repeat (5) @(posedge clk);
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read (ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;
	if (cnt[63:0] == 0) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: cnt =%16h  is clear when timer_en H->L \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: cnt =%16h  not clear \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
end
endtask
