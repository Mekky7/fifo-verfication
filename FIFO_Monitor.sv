import first_pack ::*;
import second_pack ::*;
import third_pack ::*;
import shared_pkg::*;


module monitor(FIFO_if.MONITOR filo);

	FIFO_transaction trans=new();
	FIFO_coverage coverage=new();
	FIFO_scoreboard scoreboard=new() ;

	//initial begin
		always @(negedge filo.clk) begin
		
			trans.wr_en =filo.wr_en;
			trans.rd_en =filo.rd_en;
			trans.rst_n =filo.rst_n;
			trans.data_in =filo.data_in;
			trans.data_out =filo.data_out;
			trans.full =filo.full;
			trans.empty=filo.empty;
			trans.almostfull=filo.almostfull;
			trans.almostempty= filo.almostempty;
			trans.wr_ack =filo.wr_ack;
			trans.overflow=filo.overflow;
			trans.underflow=filo.underflow;
			

			fork
				begin
					coverage.sample_data(trans);
				end
				begin
					scoreboard.check_data(trans);
				end
			join

			if(test_finished)begin
				$display("========TEST COMPLETED ========\n WITH ERRORS=%d & WITH CORRECT=%d ",error_count,correct_count);
				$stop;
			end	

	//	end

	end
endmodule	