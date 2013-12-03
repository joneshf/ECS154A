module transmit(	input logic [7:0] datain,
						input logic en,
						output logic a);
						
	logic [127:0] qu;
	logic [3:0] count = 4'b0;

	always @(posedge en)
	begin
		qu <= {qu[120:0],datain};
		count <= count + 1;
	end
	//we have to keep track of bytes written so we know how many come out, and when we fill FIFO, TBNF gets set low.
endmodule