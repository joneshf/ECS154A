module programcounter(input logic clk,
							 input logic en,
							 input logic [15:0]next_addr,
							 output logic [15:0]curr_addr);
							 
	flopen procount(clk, en, next_addr, curr_addr);
endmodule
	