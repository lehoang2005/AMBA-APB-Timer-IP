task run_test();
parameter TCR_DEF   = {20'h0, 4'h1, 8'b0};
parameter TDR0_DEF  = {32'h0};
parameter TDR1_DEF  = {32'h0};
parameter TCMP0_DEF = {32'hFFFF_FFFF};
parameter TCMP1_DEF = {32'hFFFF_FFFF};
parameter TIER_DEF  = {32'h0};
parameter TISR_DEF  = {32'h0};
parameter THCSR_DEF = {32'h0};

reg [31:0] prdata;

begin
	$display("====================================================");
	$display("==============Test Case: check Init Value===========");
	$display("====================================================");
	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	$display("Verify TCR default value");
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, TCR_DEF, 32'hFFFF_FFFF);

	$display("Verify TDR0 default value");
	test_bench.apb_read (ADDR_TDR0, prdata);
	test_bench.cmp_data (ADDR_TDR0, prdata, TDR0_DEF, 32'hFFFF_FFFF);

	$display("Verify TDR1 default value");
	test_bench.apb_read (ADDR_TDR1, prdata);
	test_bench.cmp_data (ADDR_TDR1, prdata, TDR1_DEF, 32'hFFFF_FFFF);

	$display("Verify TCMP0 default value");
	test_bench.apb_read (ADDR_TCMP0, prdata);
	test_bench.cmp_data (ADDR_TCMP0, prdata, TCMP0_DEF, 32'hFFFF_FFFF);

	$display("Verify TCMP1 default value");
	test_bench.apb_read (ADDR_TCMP1, prdata);
	test_bench.cmp_data (ADDR_TCMP1, prdata, TCMP1_DEF, 32'hFFFF_FFFF);

	$display("Verify TIER default value");
	test_bench.apb_read (ADDR_TIER, prdata);
	test_bench.cmp_data (ADDR_TIER, prdata, TIER_DEF, 32'hFFFF_FFFF);

	$display("Verify TISR default value");
	test_bench.apb_read (ADDR_TISR, prdata);
	test_bench.cmp_data (ADDR_TISR, prdata, TISR_DEF, 32'hFFFF_FFFF);

	$display("Verify THCSR default value");
	test_bench.apb_read (ADDR_THCSR, prdata);
	test_bench.cmp_data (ADDR_THCSR, prdata, THCSR_DEF, 32'hFFFF_FFFF);

end
endtask
