module registers(input logic clk,
						input logic[2:0]a_index, b_index, c_index 		//selector bits (3-bits)
						input logic 	 we, 				//write enable
						input logic [15:0]d_input,		//16-bit bus input
						output logic [15:0]a_output	//16-bit bus output
						output logic [15:0]b_output   //16-bit bus output
						);
	logic [15:0]temp;
	flopen R0,R1,R2,R3,R4,R5,R6,R7 (clk, 1'b1, 16'b0, temp);
	
	always_comb
	if (we)
	begin
		case(c_index)
			3'b000: R0 (clk, 1'b1, d_input, temp)
			3'b001: R1 (clk, 1'b1, d_input, temp)
			3'b010: R2 (clk, 1'b1, d_input, temp)
			3'b011: R3 (clk, 1'b1, d_input, temp)
			3'b100: R4 (clk, 1'b1, d_input, temp)
			3'b101: R5 (clk, 1'b1, d_input, temp)
			3'b110: R6 (clk, 1'b1, d_input, temp)
			3'b111: R7 (clk, 1'b1, d_input, temp)
		endcase
	end
	
	case(a_index)
		3'b000: R0 (clk, 1'b0, temp, a_output)
		3'b001: R1 (clk, 1'b0, temp, a_output)
		3'b010: R2 (clk, 1'b0, temp, a_output)
		3'b011: R3 (clk, 1'b0, temp, a_output)
		3'b100: R4 (clk, 1'b0, temp, a_output)
		3'b101: R5 (clk, 1'b0, temp, a_output)
		3'b110: R6 (clk, 1'b0, temp, a_output)
		3'b111: R7 (clk, 1'b0, temp, a_output)
	endcase
		
	case(b_index)
		3'b000: R0 (clk, 1'b0, temp, b_output)
		3'b001: R1 (clk, 1'b0, temp, b_output)
		3'b010: R2 (clk, 1'b0, temp, b_output)
		3'b011: R3 (clk, 1'b0, temp, b_output)
		3'b100: R4 (clk, 1'b0, temp, b_output)
		3'b101: R5 (clk, 1'b0, temp, b_output)
		3'b110: R6 (clk, 1'b0, temp, b_output)
		3'b111: R7 (clk, 1'b0, temp, b_output)
	endcase
		
endmodule