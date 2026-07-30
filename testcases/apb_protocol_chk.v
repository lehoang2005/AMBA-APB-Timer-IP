task run_test();
reg [31:0] task_rdata;
reg reg_err;
reg [31:0] expected_data;
integer i;
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

	$display("Check penable does not assert");
	apb_err_penable = 1;
	test_bench.apb_write (ADDR_TDR0, 32'h5555_5555, 4'hf, reg_err);
	apb_err_penable = 0;
	
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

	apb_err_penable = 1;
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h0, 32'hffff_ffff);
	apb_err_penable = 0;


	$display("Check psel does not assert");
	apb_err_psel = 1;
	test_bench.apb_write (ADDR_TDR0, 32'h7777_7777, 4'hf, reg_err);
	apb_err_psel = 0;
	
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

	apb_err_psel = 1;
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h0, 32'hffff_ffff);
	apb_err_psel = 0;

	test_bench.apb_write (ADDR_TDR0, 32'h9999_9999, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, 32'h9999_9999, 32'hffff_ffff);

	$display("Check tim_pslverr");
	$display("Check prohibit div_val");
	test_bench.apb_write (ADDR_TCR, 32'h0000_0900, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h0000_0a00, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h0000_0d00, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h0000_0f00, 4'hf, reg_err);
	
	$display("Check div_en change when timer_en H");
	test_bench.apb_write (ADDR_TCR, 32'h1, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h2, 4'hf, reg_err);

	$display("Check div_val change when timer_en H");
	test_bench.apb_write (ADDR_TCR, 32'h0000_0900, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h0000_0a00, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h0000_0d00, 4'hf, reg_err);
	test_bench.apb_write (ADDR_TCR, 32'h0000_0f00, 4'hf, reg_err);
	
	test_bench.apb_write (ADDR_TCR, 32'h0000_0000, 4'hf, reg_err);

	$display ("Check pstrb");
	test_bench.apb_write (ADDR_TDR0, 32'h0000_0000, 4'hf, reg_err);
	
	for (i = 0; i < 16; i = i+1) begin       
	test_bench.apb_write (ADDR_TDR0, 32'h3333_3333, i, reg_err);
	expected_data[7:0] = (i[0]) ? 8'h33 : 8'h00;
	expected_data[15:8] = (i[1]) ? 8'h33 : 8'h00;
	expected_data[23:16] = (i[2]) ? 8'h33 : 8'h00;
	expected_data[31:24] = (i[3]) ? 8'h33 : 8'h00;

	test_bench.apb_read (ADDR_TDR0, task_rdata);
	test_bench.cmp_data (ADDR_TDR0, task_rdata, expected_data, 32'hffff_ffff);
	test_bench.apb_write (ADDR_TDR0, 32'h0000_0000, 4'hf, reg_err);
	end
end
endtask
