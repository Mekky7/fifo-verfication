import first_pack ::*;

interface FIFO_if(input bit clk);
	
	
	logic wr_en,rd_en,rst_n,full,empty,almostfull,almostempty,wr_ack,overflow,underflow,test_finished;
	logic [FIFO_WIDTH-1:0]  data_in,data_out ;
	logic [max_fifo_addr:0] count;

	modport DUT (input data_in,clk, rst_n, wr_en, rd_en,
	 			output data_out,full,almostfull,empty,almostempty,overflow,underflow,wr_ack,count);

	modport TEST (output rst_n,data_in,wr_en,rd_en,test_finished,
				 input clk,full );

	modport MONITOR (input clk,rst_n,data_in,wr_en,rd_en,test_finished,full,empty,
					almostfull,almostempty,overflow,underflow,wr_ack,data_out,count);

endinterface 	

