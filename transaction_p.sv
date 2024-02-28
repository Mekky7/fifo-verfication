
package first_pack;

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);
	

	class FIFO_transaction ;

		rand logic wr_en,rd_en,rst_n;
		rand logic [FIFO_WIDTH-1:0]  data_in;
		
		logic [FIFO_WIDTH-1:0] data_out ;
		logic full,empty,almostfull,almostempty,wr_ack,overflow,underflow;
		integer count ;


		integer WR_EN_ON_DIST =70;
		integer RD_EN_ON_DIST =30;

		constraint rst_c 
		{
			rst_n dist {0:=3, 1:=97};
		}

		constraint write_more
		{
			wr_en dist {0:=(100-WR_EN_ON_DIST) , 1:= WR_EN_ON_DIST} ;
		}
		
		
		constraint read_less
		{
			rd_en dist {0:=(100-RD_EN_ON_DIST), 1:= RD_EN_ON_DIST} ;
		}
		
	endclass
endpackage 		