task run_test();
reg [31:0] task_rdata;
reg reg_err;
begin
	$display("====================================================");
	$display("==============Test Case: APB multiple access=============");
	$display("====================================================");

	rst_n = 1;
	#100;
	rst_n = 0;
	$display("Reseting ...");
	#100;
	rst_n = 1;
	$display("Reset done");
	#100;
	$display("Multiple APB access");
	   @(posedge clk);
	   #1;
	   paddr = ADDR_TDR0;
	   pwdata = 32'h1111_1111;
	   pstrb = 4'hf;
	   psel = 1;
	   pwrite = 1;

	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready == 1'b1);
	   #1;
	   if (pslverr == 1'b1) begin
	  	$display("t=%10d tim_pslverr is asserted. The data is violated", $time);
	   end
	   else begin
	  	$display("tim_pslverr is not asserted.");
	   end
	   
	   @(posedge clk);
	   #1;
	   penable = 0;
	   paddr = ADDR_TDR1;
	   pwdata = 32'h2222_2222;

	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready == 1'b1);
	   #1;
	   if (pslverr == 1'b1) begin
	  	$display("t=%10d tim_pslverr is asserted. The data is violated", $time);
	   end
	   else begin
	  	$display("tim_pslverr is not asserted.");
	   end

	   @(posedge clk);
	   #1;
	   pwrite = 0;
	   psel = 0;
	   penable = 0;
	   paddr = 0;
	   pwdata = 0;

	   $display("Normal read");
	   test_bench.apb_read(ADDR_TDR0, task_rdata);
	   test_bench.cmp_data(ADDR_TDR0, task_rdata, 32'h1111_1111, 32'hffff_ffff);
	   test_bench.apb_read(ADDR_TDR1, task_rdata);
	   test_bench.cmp_data(ADDR_TDR1, task_rdata, 32'h2222_2222, 32'hffff_ffff);

	   $display("Normal write");
	   test_bench.apb_write(ADDR_TDR0, 32'h3333_3333, 4'hf, reg_err);
	   test_bench.apb_write(ADDR_TDR1, 32'h4444_4444, 4'hf, reg_err);
	   
	   $display("Multiple read"); 
	   @(posedge clk);
	   #1;
	   paddr = ADDR_TDR0;
	   psel = 1;
	   pwrite = 0;
	  
	   @(posedge clk);
 	   #1;
	   penable = 1;
	   wait (pready == 1'b1);
	   #1;
	   test_bench.cmp_data (ADDR_TDR0, prdata, 32'h3333_3333, 32'hffff_ffff);
	   @(posedge clk);
	   #1;
	   penable = 0;
	   paddr = ADDR_TDR1;
	   
	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready == 1);
	   #1;
	   test_bench.cmp_data (ADDR_TDR1, prdata, 32'h4444_4444, 32'hffff_ffff);
	   @(posedge clk);
	   #1;
	   psel = 0;
	   penable = 0;
	   paddr = 0;
	   pwdata = 0;
	    
	   $display("WR TDR0 - WR TDR1");
	   @(posedge clk);
	   #1;
	   psel = 1;
	   pwrite = 1;
	   paddr = ADDR_TDR0;
	   pwdata = 32'h5555_5555;
	   pstrb = 4'hf;

	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready ==1);
	   if (pslverr == 1'b1) begin
	  	$display("t=%10d tim_pslverr is asserted. The data is violated", $time);
	   end
	   else begin
	  	$display("tim_pslverr is not asserted.");
	   end
	   
	   @(posedge clk);
	   #1;
	   penable = 0;
	   pwrite = 0;
	   pwdata = 0;
	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready ==1);
	   #1;
	   test_bench.cmp_data(ADDR_TDR0, prdata, 32'h5555_5555, 32'hffff_ffff);
	   @(posedge clk);
	   #1;
	   penable = 0;
	   pwrite = 1;
	   paddr = ADDR_TDR1;
	   pwdata = 32'h6666_6666;
	   pstrb = 4'hf;

	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready ==1);
	   if (pslverr == 1'b1) begin
	  	$display("t=%10d tim_pslverr is asserted. The data is violated", $time);
	   end
	   else begin
	  	$display("tim_pslverr is not asserted.");
	   end
	   
	   @(posedge clk);
	   #1;
	   penable = 0;
	   pwrite = 0;
	   pwdata = 0;
	   @(posedge clk);
	   #1;
	   penable = 1;
	   wait (pready ==1);
	   #1;
	   test_bench.cmp_data(ADDR_TDR1, prdata, 32'h6666_6666, 32'hffff_ffff);
	   @(posedge clk);
	   psel = 0;
	   penable = 0;
	   paddr = 0;

end
endtask
