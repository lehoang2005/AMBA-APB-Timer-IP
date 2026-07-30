task run_test();

reg [31:0] prdata;
integer i;
reg [31:0] patterns [0:4];
reg [31:0] raw_wdata;
reg reg_err;

begin
	$display("====================================================");
	$display("==============Test Case: check Reg RW ==============");
	$display("====================================================");
	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	patterns[0] = 32'h0000_0000;
	patterns[1] = 32'hFFFF_FFFF;
	patterns[2] = 32'haaaa_aaaa;
	patterns[3] = 32'h5555_5555;
	patterns[4] = 32'h5AA5_A55A;
	
	$display("****Verify TCR R/W****");
	test_bench.apb_write (ADDR_TCR, patterns[0], 4'hF, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0000, 32'hffff_ffff);	
	
	test_bench.apb_write (ADDR_TCR, patterns[1], 4'hF, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0000, 32'hffff_ffff);

	test_bench.apb_write (ADDR_TCR, patterns[2], 4'hF, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0000, 32'hffff_ffff);	

	test_bench.apb_write (ADDR_TCR, patterns[3], 4'hf, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0501, 32'hffff_ffff);

	test_bench.apb_write (ADDR_TCR, patterns[4], 4'hf, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0501, 32'hffff_ffff);

	$display("div_val check");
	$display("clear to all = 0");
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	$display("Write div_val = 8");
	test_bench.apb_write (ADDR_TCR, 32'h0000_0800, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0800, 32'hffff_ffff);


	$display("Write div_val = 9");
	test_bench.apb_write (ADDR_TCR, 32'h0000_0900, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0800, 32'hffff_ffff);


	$display("Write div_val = 7");
	test_bench.apb_write (ADDR_TCR, 32'h0000_0700, 4'hf, reg_err);
	test_bench.apb_read (ADDR_TCR, prdata);
	test_bench.cmp_data (ADDR_TCR, prdata, 32'h0000_0700, 32'hffff_ffff);


	$display("****Verify TDR0 R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write (ADDR_TDR0, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_TDR0, prdata);
	test_bench.cmp_data (ADDR_TDR0, prdata, raw_wdata, 32'hFFFF_FFFF);	
	end

	$display("****Verify TDR1 R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write (ADDR_TDR1, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_TDR1, prdata);
	test_bench.cmp_data (ADDR_TDR1, prdata, raw_wdata, 32'hFFFF_FFFF);	
	end

	$display("****Verify TCMP0 R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write(ADDR_TCMP0, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_TCMP0, prdata);
	test_bench.cmp_data (ADDR_TCMP0, prdata, raw_wdata, 32'hFFFF_FFFF);	
	end
	       
	$display("****Verify TCMP1 R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write(ADDR_TCMP1, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_TCMP1, prdata);
	test_bench.cmp_data (ADDR_TCMP1, prdata, raw_wdata, 32'hFFFF_FFFF);	
	end
	
	$display("****Verify TIER R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write(ADDR_TIER, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_TIER, prdata);
	test_bench.cmp_data (ADDR_TIER, prdata, raw_wdata, 32'h1);	
	end
	
	$display("clear to all = 0");
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;

	$display("****Verify TISR R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write (ADDR_TISR, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_TISR, prdata);
	test_bench.cmp_data (ADDR_TISR, prdata, 32'h0, 32'hffff_ffff);	
	end

	$display("****Verify THCSR R/W****");
	for (i = 0; i < 5; i = i+1) begin
	raw_wdata = patterns[i];
	test_bench.apb_write(ADDR_THCSR, raw_wdata, 4'hF, reg_err);
	test_bench.apb_read (ADDR_THCSR, prdata);
	test_bench.cmp_data (ADDR_THCSR, prdata, raw_wdata, 32'h0000_0001);	
	end
end
endtask
