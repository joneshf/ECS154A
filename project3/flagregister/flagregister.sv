module flagregister(input logic clk,
						  input logic [7:0]f,	  //flag bits
						  input logic [2:0]s,     //selector bits
						  output logic [7:0]q);	  //output flag bits
	always_ff@(posedge clk)
	if (s[2])			 //if MSB is set to 1, copy all input flags to output flags
		begin
			q[0] = f[0]; //copy zero flag input to zero flag output
			q[1] = f[1]; //copy negative flag input to neg flag output
			q[2] = f[2]; //copy carry flag input to carry flag output
			q[3] = f[3]; //copy overflow flag input to overflow flag output
			q[4] = f[4]; //copy interrupt flag input to interrupt flag output
			q[5] = f[5]; //copy always flag input to always flag output
			q[6] = f[6]; //not used, but quartus gave a warning
			q[7] = f[7]; //not used, but quartus gave a warning
			
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