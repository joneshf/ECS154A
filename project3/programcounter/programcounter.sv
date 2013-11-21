module programcounter(input logic clk,
							 input logic en,
							 input logic [15:0]next_addr,
							 output logic [15:0]curr_addr);
	
	logic [15:0] temp = 16'b0;
	flopen procount(clk, en, temp, curr_addr);
	
	always_ff@(posedge en)
	temp <= next_addr;
endmodule
	