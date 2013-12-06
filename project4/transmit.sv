module transmit(	input logic clk,
						input logic [7:0] datain,
						input logic en,
						input logic tfin,
						output logic [127:0] a,
						output logic tbnfout,
						output logic [3:0] countout);
						
	logic [127:0] qu;
	logic [3:0] count = 4'b0;

	always_ff@(posedge clk)
	begin
		if(en)
			qu <= {qu[119:0],datain};

		if(tfin)
			count <= 4'b0;
		else if(count != 4'b1111)
			count <= count + 1'b1;
	end
	
	assign a = qu;
	assign countout = count;
	
	assign tbnfout = ~(count[3] & count[2] & count[1] & count[0]);

endmodule