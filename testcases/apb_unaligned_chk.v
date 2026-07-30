task run_test();
reg [31:0] task_rdata;
reg reg_err;

begin
	$display("====================================================");
	$display("==============Test Case: check Protocol Test========");
	$display("====================================================");
	
	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;
	
	test_bench.apb_write (ADDR_TDR0, 32'h3333_3333, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

	$display("Address unaligned offset 0x1");
	test_bench.apb_write(ADDR_TDR0+1, 32'h4444_4444, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TDR0+1, task_rdata);
	test_bench.cmp_data (ADDR_TDR0+1, task_rdata, 32'h0, 32'hffff_ffff);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

	$display("Address unaligned offset 0x2");
	test_bench.apb_write(ADDR_TDR0+2, 32'h4444_4444, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TDR0+2, task_rdata);
	test_bench.cmp_data (ADDR_TDR0+2, task_rdata, 32'h0, 32'hffff_ffff);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

	$display("Address unaligned offset 0x3");
	test_bench.apb_write(ADDR_TDR0+3, 32'h4444_4444, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TDR0+3, task_rdata);
	test_bench.cmp_data (ADDR_TDR0+3, task_rdata, 32'h0, 32'hffff_ffff);

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);
end
endtask
