task run_test();
reg [31:0] prdata;
integer i;
reg reg_err;
begin
	$display("====================================================");
	$display("==============Test Case: check One hot =============");
	$display("====================================================");
	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	test_bench.apb_write(ADDR_TISR, 32'h1111_1111, 4'hF, reg_err);
	test_bench.apb_write(ADDR_TCR, 32'h2222_2222, 4'hF, reg_err);
	test_bench.apb_write(ADDR_TDR0, 32'h3333_3333, 4'hF, reg_err);
	test_bench.apb_write(ADDR_TDR1, 32'h4444_4444, 4'hF, reg_err);
	test_bench.apb_write(ADDR_TCMP0, 32'h5555_5555, 4'hF, reg_err);
	test_bench.apb_write(ADDR_TCMP1, 32'h6666_6666, 4'hF, reg_err);
	test_bench.apb_write(ADDR_TIER, 32'h7777_7777, 4'hF, reg_err);
	test_bench.apb_write(ADDR_THCSR, 32'h8888_8888, 4'hF, reg_err);
	
	test_bench.apb_read (ADDR_TISR, prdata);
	test_bench.cmp_data (ADDR_TISR, prdata, 32'h0, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0202, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_TDR0, prdata);
	test_bench.cmp_data (ADDR_TDR0, prdata, 32'h3333_3333, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_TDR1, prdata);
	test_bench.cmp_data (ADDR_TDR1, prdata, 32'h4444_4444, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_TCMP0, prdata);
	test_bench.cmp_data (ADDR_TCMP0, prdata, 32'h5555_5555, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_TCMP1, prdata);
	test_bench.cmp_data (ADDR_TCMP1, prdata, 32'h6666_6666, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_TIER, prdata);
	test_bench.cmp_data (ADDR_TIER, prdata, 32'h1, 32'hFFFF_FFFF);	

	test_bench.apb_read (ADDR_THCSR, prdata);
	test_bench.cmp_data (ADDR_THCSR, prdata, 32'h0, 32'hFFFF_FFFF);	
end
endtask
