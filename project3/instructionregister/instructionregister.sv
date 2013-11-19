module instructionregister(input logic clk,
									input logic re,  					//read enable
									input logic [15:0]curr_addr,	//current address from program counter
									output logic [15:0]curr_instr); //outputs current instruction
							 
	flopen instreg(clk, re, curr_addr, curr_instr);
endmodule