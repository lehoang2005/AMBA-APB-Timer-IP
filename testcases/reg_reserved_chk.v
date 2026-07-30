task run_test();
reg [31:0] prdata;
integer i;
reg reg_err;

begin
	$display("====================================================");
	$display("==============Test Case: check Reserved=============");
	$display("====================================================");
	i = 0;
	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	$display("Write to 0x2309_2005");
	test_bench.apb_write (32'h2309_2005, 32'hFFFF_FFFF, 4'hF, reg_err);
	test_bench.apb_read (32'h2309_2005, prdata);
	test_bench.cmp_data (32'h2309_2005, prdata, 32'h0, 32'hFFFF_FFFF);	

	$display("Write to begin of reserved address");
	test_bench.apb_write (ADDR_THCSR+1, 32'hFFFF_FFFF, 4'hF, reg_err);
	test_bench.apb_read (ADDR_THCSR+1, prdata);
	test_bench.cmp_data (ADDR_THCSR+1, prdata, 32'h0, 32'hFFFF_FFFF);	

	for (i = 5; i < 12; i = i+1) begin
	test_bench.apb_write(1 << i, 32'hFFFF_FFFF, 4'hF, reg_err);
	test_bench.apb_read (1 << i, prdata);
	test_bench.cmp_data (1 << i, prdata, 32'h0, 32'hFFFF_FFFF);	
	end

end
endtask
