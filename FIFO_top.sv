module FIFO_TOP();
	bit clk ;

	initial begin
		forever #10 clk=~clk;
	end

	FIFO_if filo(clk) ;

	FIFO dut(filo);

	testbench tb(filo);

	monitor m1(filo);

endmodule 	