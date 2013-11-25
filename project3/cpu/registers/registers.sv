module registers(input logic clk,
						input logic[2:0] a_index, b_index, c_index,		//selector bits (3-bits)
						input logic we, 											//write enable
						input logic [15:0] d_input,							//16-bit bus input
						output logic [15:0] a_output,							//16-bit bus output
						output logic [15:0] b_output,							//16-bit bus output
						output logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7);	//16-bit debug registers
	
	logic [15:0] R01, R02, R03, R04, R05, R06, R07, R08;
	
	always_ff@(posedge clk)
		if(we)
			begin
				case(c_index)
					3'b000: R01 <= d_input;
					3'b001: R02 <= d_input;
					3'b010: R03 <= d_input;
					3'b011: R04 <= d_input;
					3'b100: R05 <= d_input;
					3'b101: R06 <= d_input;
					3'b110: R07 <= d_input;
					3'b111: R08 <= d_input;
				endcase
			end

	always_comb
		begin
			case(a_index)
				3'b000: a_output = R01;
				3'b001: a_output = R02;
				3'b010: a_output = R03;
				3'b011: a_output = R04;
				3'b100: a_output = R05;
				3'b101: a_output = R06;
				3'b110: a_output = R07;
				3'b111: a_output = R08;
			endcase

			case(b_index)
				3'b000: b_output = R01;
				3'b001: b_output = R02;
				3'b010: b_output = R03;
				3'b011: b_output = R04;
				3'b100: b_output = R05;
				3'b101: b_output = R06;
				3'b110: b_output = R07;
				3'b111: b_output = R08;
			endcase
		end

	assign r0 = R01;
	assign r1 = R02;
	assign r2 = R03;
	assign r3 = R04;
	
	assign r4 = R05;
	assign r5 = R06;
	assign r6 = R07;
	assign r7 = R08;
endmodule
