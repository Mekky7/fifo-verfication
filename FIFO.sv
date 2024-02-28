////////////////////////////////////////////////////////////////////////////////
// Author: flfl_04
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////

import first_pack ::*;
`define SIM

module FIFO(FIFO_if.DUT filo);

	`ifdef SIM
		always_comb begin
		//RESET FUNCTIONALITY CHECK		
			if(!filo.rst_n) begin
				P1: assert final(filo.full === 0);
				P2: assert final(filo.empty === 1);
				P3: assert final (filo.almostfull === 0);
				P4: assert final (filo.almostempty === 0);
				P5: assert final (filo.overflow === 0);
				P6: assert final (filo.underflow === 0);
				P7: assert final (filo.wr_ack ===0 );
			end
		//COMPINATIONAL FLAGS CHECK & Counter	
			else begin
		
				if(filo.count == FIFO_DEPTH)
					P8: assert final (filo.full===1);
				if(filo.count == 0)
					P9: assert final (filo.empty === 1);
				if(filo.count == (FIFO_DEPTH-1))
					P10: assert final (filo.almostfull === 1);
				if(filo.count == 1)
					P11: assert final (filo.almostempty === 1);
				
					
			end	
			

		end	
		property over_flow;
			@(posedge filo.clk) disable iff(!filo.rst_n) (filo.wr_en && filo.full) |=> filo.overflow ;
		endproperty	

		property under_flow;
			@(posedge filo.clk) disable iff(!filo.rst_n) (filo.rd_en && filo.empty) |=> filo.underflow ;
		endproperty	

		property write_ack;
			@(posedge filo.clk) disable iff(!filo.rst_n) (filo.wr_en && !filo.full) |=> filo.wr_ack ;
		endproperty	

		property write_op;
			@(posedge filo.clk) disable iff(!filo.rst_n || filo.full) (filo.wr_en && !filo.rd_en) |=> (mem[$past(wr_ptr)] === $past(filo.data_in)) ;
		endproperty

		property write_pt_inc;
			@(posedge filo.clk) disable iff(!filo.rst_n || filo.full) (filo.wr_en && !filo.rd_en) |=> (wr_ptr === ($past(wr_ptr)+3'b001)) ;
		endproperty	
			
		property read_op ;	
			@(posedge filo.clk) disable iff(!filo.rst_n || filo.empty) (!filo.wr_en && filo.rd_en) |=> (filo.data_out) === mem[$past(rd_ptr)] ;
		endproperty

		property read_pt_inc;	
			@(posedge filo.clk) disable iff(!filo.rst_n || filo.empty) (!filo.wr_en && filo.rd_en) |=> (rd_ptr === ($past(rd_ptr) + 3'b001)) ;
		endproperty	

		property no_read_op ;
			@(posedge filo.clk) disable iff(!filo.rst_n || filo.empty || filo.full) (!filo.rd_en ) |=> $stable(filo.data_out);
		endproperty 

		P12: assert property (over_flow) ;
		P13: assert property (under_flow);
		P14: assert property (write_ack);
		P15: assert property (write_op)	;
		P16: assert property (write_pt_inc);
		P17: assert property (read_op);
		P18: assert property (read_pt_inc);
		P19: assert property (no_read_op);

		C12: cover property (over_flow) ;
		C13: cover property (under_flow) ;
		C14: cover property (write_ack) ;
		C15: cover property (write_op) ;
		C16: cover property (write_pt_inc) ;
		C17: cover property (read_op) ;
		C18: cover property (read_pt_inc) ;
		C19: cover property (no_read_op) ;

	`endif 	

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;


always @(posedge filo.clk or negedge filo.rst_n) begin
	if (!filo.rst_n) begin
		wr_ptr <= 0;
		filo.wr_ack <=0;
		filo.overflow <=0;
	end
	else if (filo.wr_en && filo.count !== FIFO_DEPTH  ) begin
		filo.overflow <= 0;
		mem[wr_ptr] <= filo.data_in;
		filo.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		filo.wr_ack <= 0; 
		if (filo.full && filo.wr_en)
			filo.overflow <= 1;
		else
			filo.overflow <= 0;
	end
end

always @(posedge filo.clk or negedge filo.rst_n) begin
	if (!filo.rst_n) begin
		rd_ptr <= 0;
		filo.underflow <= 0;
	end
	else if (filo.rd_en && filo.count !== 0 ) begin

		filo.underflow <= 0;
		filo.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin  
		if (filo.empty && filo.rd_en)
			filo.underflow <= 1;
		else
			filo.underflow <= 0;
	end
end

always @(posedge filo.clk or negedge filo.rst_n) begin
	if (!filo.rst_n) begin
		filo.count <= 0;
	end
	else begin
		case({filo.wr_en ,filo.rd_en})

			2'b01 : if(!filo.empty)
						filo.count <=filo.count -1 ;
			2'b10 : if(!filo.full)
						filo.count <= filo.count+1 ;
			2'b11: if(filo.full)
						filo.count <= filo.count-1 ;
					else if(filo.empty)
						filo.count<= filo.count+1 ;


		endcase
	end
end

assign filo.full = (filo.count == FIFO_DEPTH)? 1 : 0;
assign filo.empty = (filo.count == 0)? 1 : 0;
assign filo.almostfull = (filo.count == FIFO_DEPTH-1)? 1 : 0; 
assign filo.almostempty = (filo.count == 1)? 1 : 0;

endmodule