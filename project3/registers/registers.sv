module registers(input logic clk,
						input logic[2:0] a_index, b_index, c_index,		//selector bits (3-bits)
						input logic we, 											//write enable
						input logic [15:0] d_input,							//16-bit bus input
						output logic [15:0] a_output,							//16-bit bus output
						output logic [15:0] b_output);						//16-bit bus output

	// These are used to set up the registers.
	logic [15:0] tempin;
	logic [7:0][15:0] tempout;
	logic [7:0] en = 8'b0;

	// The internal registers of this block.
	flopen R0(clk, en[0], tempin, tempout[0]);
	flopen R1(clk, en[1], tempin, tempout[1]);
	flopen R2(clk, en[2], tempin, tempout[2]);
	flopen R3(clk, en[3], tempin, tempout[3]);

	flopen R4(clk, en[4], tempin, tempout[4]);
	flopen R5(clk, en[5], tempin, tempout[5]);
	flopen R6(clk, en[6], tempin, tempout[6]);
	flopen R7(clk, en[7], tempin, tempout[7]);

	always_ff
		begin
			// When we want to write to a register in the block,
			// we need the write enable to be set.
			if (we)
				begin
					// Load up the input and clear all of the enable bits.
					tempin = d_input;
					en = 8'b0;
					// Select the enable based on what c_index is.
					case(c_index)
						3'b000: en[0] = 1'b1;
						3'b001: en[1] = 1'b1;
						3'b010: en[2] = 1'b1;
						3'b011: en[3] = 1'b1;
						3'b100: en[4] = 1'b1;
						3'b101: en[5] = 1'b1;
						3'b110: en[6] = 1'b1;
						3'b111: en[7] = 1'b1;
					endcase
				end

			// Select the a_output based on what a_index is.
			case(a_index)
				3'b000: a_output = tempout[0];
				3'b001: a_output = tempout[1];
				3'b010: a_output = tempout[2];
				3'b011: a_output = tempout[3];
				3'b100: a_output = tempout[4];
				3'b101: a_output = tempout[5];
				3'b110: a_output = tempout[6];
				3'b111: a_output = tempout[7];
			endcase

			// Select the b_output based on what b_index is.
			case(b_index)
				3'b000: b_output = tempout[0];
				3'b001: b_output = tempout[1];
				3'b010: b_output = tempout[2];
				3'b011: b_output = tempout[3];
				3'b100: b_output = tempout[4];
				3'b101: b_output = tempout[5];
				3'b110: b_output = tempout[6];
				3'b111: b_output = tempout[7];
			endcase
		end

endmodule
