package third_pack ;
	
	import first_pack::*;
	import shared_pkg::*;


	class FIFO_scoreboard;

		

		logic [FIFO_WIDTH-1:0] data_out_ref;
		logic full_ref,empty_ref,almostfull_ref,almostempty_ref,overflow_ref,underflow_ref,wr_ack_ref ;
		logic [max_fifo_addr-1:0] rd_ptr_exp,wr_ptr_exp;
		logic [max_fifo_addr:0] count_exp ;


		reg [FIFO_WIDTH-1:0] memo_expected [FIFO_DEPTH-1:0] ;

		function void check_data(FIFO_transaction obj );
			
			refrence_model(obj);

			if(data_out_ref!== obj.data_out || full_ref!==obj.full || empty_ref!==obj.empty 
				|| almostfull_ref!==obj.almostfull ||overflow_ref!==obj.overflow
				||underflow_ref!==obj.underflow ||wr_ack_ref!==obj.wr_ack) begin

				if(data_out_ref!== obj.data_out) begin
					$display("ERROR IN DATA OUT AT TIME:%t ---EXPECTED: %h ---ACTUAL:%h",$time,data_out_ref,obj.data_out);
					error_count=error_count+1;
				end 
				if(full_ref!==obj.full)begin
					$display("ERROR IN FULL FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,full_ref,obj.full);
					error_count=error_count+1;
				end
				if(empty_ref!==obj.empty)begin
					$display("ERROR IN EMPTY FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,empty_ref,obj.empty);
					error_count=error_count+1;
				end	
				if(almostfull_ref!==obj.almostfull)begin
					$display("ERROR IN ALMOST FULL FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,almostfull_ref,obj.almostfull);
					error_count=error_count+1;
				end
				if(almostempty_ref!==obj.almostempty)begin
					$display("ERROR IN ALMOST EMPTY FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,almostempty_ref,obj.almostempty);
					error_count=error_count+1;
				end
				if(overflow_ref!==obj.overflow)begin
					$display("ERROR IN OVERFLOW FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,overflow_ref,obj.overflow);
					error_count=error_count+1;
				end
				if(underflow_ref!==obj.underflow)begin
					$display("ERROR IN UNDERFLOW FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,underflow_ref,obj.underflow);
					error_count=error_count+1;
				end
				if(wr_ack_ref!==obj.wr_ack)begin
					$display("ERROR IN WR_ACK FLAG AT TIME:%t ---EXPECTED: %b ---ACTUAL:%b",$time,wr_ack_ref,obj.wr_ack);
					error_count=error_count+1;
				end
			end	
			else 
				correct_count=correct_count+1;

		endfunction

		function void refrence_model(FIFO_transaction obj);

			if(!obj.rst_n) begin
				wr_ptr_exp=0;
				rd_ptr_exp=0;
				count_exp=0;
				wr_ack_ref =0 ;
				overflow_ref =0;
				underflow_ref =0;

			end
			else begin
				fork
					begin 
						//writing operation block
						if(obj.wr_en) begin
							if(count_exp<8) begin
								memo_expected[wr_ptr_exp]=obj.data_in ;
								wr_ptr_exp=wr_ptr_exp+1;
								overflow_ref =0;
								wr_ack_ref=1;
							end
							else begin
								overflow_ref=1;
								wr_ack_ref =0 ;
							end
						end
						else begin
							overflow_ref =0;
							wr_ack_ref=0;
						end
					end

					begin
						//reading operation block
						if(obj.rd_en)begin
							if(count_exp>0) begin
								data_out_ref= memo_expected[rd_ptr_exp] ;
								rd_ptr_exp=rd_ptr_exp+1;
								underflow_ref =0;
							end
							else 
								underflow_ref=1;
						end
						else begin
							underflow_ref=0;
						end	
					end	

					begin
						//Count update block
						case({obj.wr_en ,obj.rd_en})

							2'b01 : if(!empty_ref)
								count_exp=count_exp-1;
							2'b10 : if(!full_ref)
								count_exp=count_exp+1;
							2'b11: if(full_ref)
								count_exp=count_exp-1;
									else if(empty_ref)
								count_exp=count_exp+1;

						endcase
					end
				join
			end
				//Expected flags assignments

				if(count_exp==FIFO_DEPTH)
					full_ref=1;
				else 
					full_ref=0;

				if(count_exp==0)
					empty_ref=1;
				else 
					empty_ref=0;

				if(count_exp==FIFO_DEPTH-1)
					almostfull_ref=1;
				else 
					almostfull_ref=0;

				if(count_exp==1)
					almostempty_ref=1;
				else 
					almostempty_ref=0;

		endfunction 

		function new() ;
			error_count =0;
			correct_count =0 ;
		endfunction

	endclass
endpackage 				