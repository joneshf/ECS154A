module statemachine(	input logic reset,
							input logic clk,
							output logic [1:0] state);
	typedef enum logic [1:0] {fetch, decode, execute, store} statetype;
	statetype current, next;
	logic [1:0] statevalue = 2'b0;
	
	always_ff@(posedge clk)
		if(reset) current <= store; // we go to store, since we want to increment PC // when the noop
		else current <= next;
		
	always_comb
		case(current)
			fetch:
				begin
					next <= decode;
					statevalue <= 2'b0;
				end
			decode:
				begin
					next <= execute;
					statevalue <= 2'b1;
				end
			execute:
				begin
					next <= store;
					statevalue <= 2'b10;
				end
			store:
				begin
					next <= fetch;
					statevalue <= 2'b11;
				end
		endcase
		
	assign state = statevalue;
	
endmodule
