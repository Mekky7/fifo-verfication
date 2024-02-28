import first_pack ::*;
import shared_pkg::*;

module testbench (FIFO_if.TEST filo);

	localparam TESTS_no =10000;
	
	FIFO_transaction obj=new() ;

	initial begin
		filo.rst_n =0 ;

	
		repeat (TESTS_no) begin
				
			@(negedge filo.clk);

			#2;
			assert(obj.randomize());

			update_interface();
		end

		

		test_finished=1;
	end
	task update_interface();
		filo.rst_n= obj.rst_n;
		filo.rd_en=obj.rd_en;
		filo.wr_en=obj.wr_en;
		filo.data_in=obj.data_in;
	endtask		

endmodule