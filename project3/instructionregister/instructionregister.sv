module instructionregister(input logic clk,
									input logic [15:0] curr_instr, // data from memory
									output logic [15:0] curr_instr_out);
	logic en = 1'b0;
	flopen instreg(clk, en, curr_instr, curr_instr_out);
	
	always@(curr_instr)
		begin
			en <= 1'b1;
		end

endmodule