module registers(input logic clk,
						input logic[2:0] a_index, b_index, c_index,		//selector bits (3-bits)
						input logic we, 											//write enable
						input logic [15:0] d_input,							//16-bit bus input
						output logic [15:0] a_output,							//16-bit bus output
						output logic [15:0] b_output,							//16-bit bus output
						output logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7);	//16-bit debug registers

	// These are used to set up the registers.
	logic [15:0] tempin;
	// logic [7:0][15:0] tempout;
	logic [7:0] en = 8'b0;

	// The internal registers of this block.
	flopen R0(clk, en[0], tempin, r0);
	flopen R1(clk, en[1], tempin, r1);
	flopen R2(clk, en[2], tempin, r2);
	flopen R3(clk, en[3], tempin, r3);

	flopen R4(clk, en[4], tempin, r4);
	flopen R5(clk, en[5], tempin, r5);
	flopen R6(clk, en[6], tempin, r6);
	flopen R7(clk, en[7], tempin, r7);

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
				3'b000: a_output = r0;
				3'b001: a_output = r1;
				3'b010: a_output = r2;
				3'b011: a_output = r3;
				3'b100: a_output = r4;
				3'b101: a_output = r5;
				3'b110: a_output = r6;
				3'b111: a_output = r7;
			endcase

			// Select the b_output based on what b_index is.
			case(b_index)
				3'b000: b_output = r0;
				3'b001: b_output = r1;
				3'b010: b_output = r2;
				3'b011: b_output = r3;
				3'b100: b_output = r4;
				3'b101: b_output = r5;
				3'b110: b_output = r6;
				3'b111: b_output = r7;
			endcase
		end

endmodule
