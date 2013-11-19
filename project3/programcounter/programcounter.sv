module programcounter(input logic clk,
							 input logic en,
							 input logic [15:0]next_instr,
							 output logic [15:0]curr_instr);
							 
	flopen procount(clk, en, next_instr, curr_instr);
endmodule
	