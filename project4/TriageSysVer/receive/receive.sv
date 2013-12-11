module receive(input logic clk,
					input logic rx,
					input logic [7:0] baudrate,
					output logic dr, nf, over, fe,
					output logic [7:0] dataout);
	
	logic [127:0] qu;
	//logic [255:0] crazycookie;
	logic [7:0] clkcount = 8'b0;  //internal clk count
	logic [7:0] ones, zeros;
	initial begin
		nf = 1'b0;
	end
	
	always@(posedge clk)
	begin
		if(clkcount < baudrate)
		begin
			if(rx == 1'b0)
				zeros = zeros + 1'b1;
			else
				ones = ones + 1'b1;
			clkcount <= clkcount + 1'b1;
		end
		
		if(zeros < ones)
		begin
			qu <= {qu[126:0],1'b1};
			if(zeros > 2'b10)
				nf <= 1'b1;
		end
		else if(ones < zeros)
		begin
			qu <= {qu[126:0],1'b0};
			if(ones > 2'b10)
				nf <= 1'b1;
		end
	end
	
	
	
					
endmodule