task run_test();
reg[31:0] task_rdata;
reg[63:0] cnt;
reg reg_err;

begin
	$display("====================================================");
	$display("==============Test Case: check Interrupt ===========");
	$display("====================================================");

	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;
	test_bench.apb_write (ADDR_TCMP0, 32'hff, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP1, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TIER, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);

	repeat (256+3) @(posedge clk);

	if (tim_int == 1'b1) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: Interrupt is asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: Interrupt does not asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	test_bench.apb_write (ADDR_TCR, 32'h0, 4'hf, reg_err);

	$display("*****Check interrupt status is 1");
	test_bench.apb_read(ADDR_TISR, task_rdata);
	test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
	test_bench.apb_write(ADDR_TISR, 32'h1, 4'hf, reg_err);

	test_bench.apb_write (ADDR_TDR0, 32'hffff_ffff, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP1, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TIER, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);

	repeat (1+5) @(posedge clk);

	if (tim_int == 1'b1) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: Interrupt is asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: Interrupt does not asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	
	
	$display("*****Manual condition when setting TDR0/1");
	test_bench.apb_write (ADDR_TCR, 32'h0, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR0, 32'h0, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP0, 32'h5, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP1, 32'h0, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TIER, 32'h0, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);

	repeat (10) @(posedge clk);

	if (tim_int == 1'b0) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: Interrupt is not asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: Interrupt is asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

	$display("*****Check W1C function of TISR");
	test_bench.apb_write (ADDR_TCR, 32'h0, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR0, 32'hffff_ff00, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP1, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TIER, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);

	repeat (256+5) @(posedge clk);

	if (tim_int == 1'b1) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: Interrupt is asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: Interrupt is not asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	
	test_bench.apb_read(ADDR_TISR, task_rdata);
	test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
	
	test_bench.apb_write(ADDR_TISR, 32'h0, 4'hf, reg_err);
	test_bench.apb_read(ADDR_TISR, task_rdata);
	test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);

	test_bench.apb_write(ADDR_TISR, 32'h1, 4'hf, reg_err);
	test_bench.apb_read(ADDR_TISR, task_rdata);
	test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff);

	$display("*****Check masking and unmasking");
	test_bench.apb_write (ADDR_TCR, 32'h0, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR0, 32'hffff_ff00, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TDR1, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP0, 32'h0, 4'hF, reg_err);
	test_bench.apb_write (ADDR_TCMP1, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TIER, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);

	repeat (256+5) @(posedge clk);
	if (tim_int == 1'b1) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: Interrupt is asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: Interrupt is not asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end
	
	test_bench.apb_read(ADDR_TISR, task_rdata);
	test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
	
	test_bench.apb_write(ADDR_TIER, 32'h0, 4'hf, reg_err);
	test_bench.apb_read(ADDR_TISR, task_rdata);
	test_bench.cmp_data(ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
	if (tim_int == 1'b0) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: tim_int is not asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: tim_int is asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

	test_bench.apb_write(ADDR_TIER, 32'h1, 4'hf, reg_err);
	if (tim_int == 1'b1) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: tim_int is asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: tim_int is not asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

	$display("******Check counter still count when interrupt");
	repeat(255) @(posedge clk);
	test_bench.apb_read(ADDR_TDR0, task_rdata);
	cnt[31:0] = task_rdata;
	test_bench.apb_read(ADDR_TDR1, task_rdata);
	cnt[63:32] = task_rdata;	
	if (cnt[63:32] == 1 && cnt[31:0] < 32'h120) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: Counter=%16h  is still countinig  \033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: Counter= %16h is not counting\033[0m]", $time, cnt);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

	$display("******Change TCMP when still counting");
	test_bench.apb_write(ADDR_TISR, 32'h1, 4'hf, reg_err);
	test_bench.apb_write(ADDR_TCR, 32'h0, 4'hf, reg_err);
	test_bench.apb_write(ADDR_TCMP0, 32'hffff_ffff, 4'hf, reg_err);
	test_bench.apb_write(ADDR_TCR, 32'h1, 4'hf, reg_err);
	repeat(100) @(posedge clk);
	test_bench.apb_write(ADDR_TCMP0, 32'h50, 4'hf, reg_err);

	if (tim_int == 1'b0) begin     
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;32m PASSED: tim_int is not asserted \033[0m]", $time);
		  $display ("-------------------------------------------------");
	end
	else begin
		  $display ("-------------------------------------------------");
		  $display ("t = %10d [\033[0;31m FAILED: tim_int is asserted\033[0m]", $time);
		  $display ("-------------------------------------------------");
		  err = err+1;
	end

end
endtask
