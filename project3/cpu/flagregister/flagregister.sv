/*
	This is the flag register.
	It requires a clock, 8-bits for the flags, 5-bits for the instruction,
	2-bits for the selector on LDFI, and a value for LDIF/MOVF instructions.
	The output is 8-bits of the flags.

	The flags are:
	flag | bit | description
	--------------
	Z    - 0   - Zero
	O    - 1   - Overflow
	N    - 2   - Negative
	C    - 3   - Carry
	I    - 4   - Interrupt
	A    - 5   - Always
	x    - 6   - empty
	x    - 7   - empty
*/

module flagregister(input logic clk,
						  input logic [7:0]f,	  //flag bits
						  input logic [4:0]i,	  //instruction bits
						  input logic [2:0]s,	  //flag selector bits
						  input logic val,		  //LSB for LDIF/MOVF
						  output logic [7:0]q);	  //output flag bits

	logic en = 1'b1;
	logic [7:0]tflags;
	flopen flagreg(clk, en, tflags, q);

	always

	begin
		// Enable it!
		en = 1'b1;
		// Reload the old values.
		tflags = q;
		// Ensure the A flag is 1.
		tflags[5] = 1'b1;

		case (i)
			5'h00: tflags[3:0] = f[3:0]; 	// ADD  CNOZ
			5'h01: tflags[3:0] = f[3:0]; 	// SUB  CNOZ
			5'h02: tflags[3:0] = f[3:0]; 	// ADDI CNOZ
			5'h03: begin 					// AND   N Z
					tflags[2] = f[2];
					tflags[0] = f[0];
				end
			5'h04: begin 					// OR    N Z
					tflags[2] = f[2];
					tflags[0] = f[0];
				end
			5'h05: begin 					// XOR   N Z
					tflags[2] = f[2];
					tflags[0] = f[0];
				end
			5'h06: begin 					// NOT   N Z
					tflags[2] = f[2];
					tflags[0] = f[0];
				end
			5'h07: begin 					// INV   N Z
					tflags[2] = f[2];
					tflags[0] = f[0];
				end
			5'h08: begin 					// ROR  CN Z
					tflags[3:2] = f[3:2];
					tflags[0] = f[0];
				end
			5'h09: begin 					// ROL  CN Z
					tflags[3:2] = f[3:2];
					tflags[0] = f[0];
				end
			5'h0A: begin 					// SHR  CN Z
					tflags[3:2] = f[3:2];
					tflags[0] = f[0];
				end
			5'h0B: begin 					// SHL  CN Z
					tflags[3:2] = f[3:2];
					tflags[0] = f[0];
				end
			5'h19:							// LDFI
				case (s)
					3'h0: tflags[0] = val;	// Z
					3'h1: tflags[1] = val;	// O
					3'h2: tflags[2] = val;	// N
					3'h3: tflags[3] = val;	// C
					3'h4: tflags[4] = val;	// I
					default: ; // Don't do anything
				endcase
			5'h1A: if(val == 1'b0) begin 	// MOVF
					tflags = f;
					// Reset the A flag just in case.
					tflags[5] = 1'b1;
				end
			default: ; // Don't do anything
		endcase
	end
endmodule
