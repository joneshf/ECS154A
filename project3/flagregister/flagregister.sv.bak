module flagregister(input logic clk,
						  input logic [7:0]f,	  //flag bits
						  input logic [2:0]s,     //selector bits
						  output logic [7:0]q);	  //output flag bits
	always_ff@(posedge clk)
	if (s[2])
		begin
			q = f;
		end
	else
		begin
			case(s)
				3'b000: q[0] = 1;  //Zero flag
				3'b001: q[1] = 1;  //Negative flag
				3'b010: q[2] = 1;  //Carry flag
				3'b011: q[3] = 1;  //Overflow flag
			endcase
		end
		
endmodule