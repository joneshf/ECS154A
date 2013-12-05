module transmit(	input logic [7:0] datain,
						input logic en,
						input logic tfin,
						output logic [127:0] a,
						output logic tbnfout,
						output logic [3:0] countout);
						
	logic [127:0] qu;
	logic [3:0] count = 4'b0;

	always@(posedge en)
	begin
		qu <= {qu[119:0],datain};
		count <= count + 1'b1;
	end
	
	assign a = qu;
	assign countout = count;
	
	always_comb
	begin
	if (count != 4'b1111)
		tbnfout <= 1'b1;
	else
		tbnfout <= 1'b0;
	end
	//set the count back to zero
endmodule