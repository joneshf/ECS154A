module flagregister(input logic clk,
						  input logic [7:0]f,	  //flag bits
						  input logic [4:0]i,	  //instruction bits
						  input logic [2:0]s,	  //flag selector bits
						  input logic val,		  //LSB for LDIF/MOVF
						  output logic [7:0]q);	  //output flag bits

	always_ff@(posedge clk)

	begin
		// Ensure the A flag is 1.
		q[5] = 1'b1;

		case (i)
			5'h00: q[3:0] = f[3:0]; 	// ADD  CNOZ
			5'h01: q[3:0] = f[3:0]; 	// SUB  CNOZ
			5'h02: q[3:0] = f[3:0]; 	// ADDI CNOZ
			5'h03: begin 				// AND   N Z
					q[2] = f[2];
					q[0] = f[0];
				end
			5'h04: begin 				// OR    N Z
					q[2] = f[2];
					q[0] = f[0];
				end
			5'h05: begin 				// XOR   N Z
					q[2] = f[2];
					q[0] = f[0];
				end
			5'h06: begin 				// NOT   N Z
					q[2] = f[2];
					q[0] = f[0];
				end
			5'h07: begin 				// INV   N Z
					q[2] = f[2];
					q[0] = f[0];
				end
			5'h08: begin 				// ROR  CN Z
					q[3:2] = f[3:2];
					q[0] = f[0];
				end
			5'h09: begin 				// ROL  CN Z
					q[3:2] = f[3:2];
					q[0] = f[0];
				end
			5'h0A: begin 				// SHR  CN Z
					q[3:2] = f[3:2];
					q[0] = f[0];
				end
			5'h0B: begin 				// SHL  CN Z
					q[3:2] = f[3:2];
					q[0] = f[0];
				end
			5'h19:						// LDFI
				case (s)
					3'h0: q[0] = val;	// Z
					3'h1: q[1] = val;	// O
					3'h2: q[2] = val;	// N
					3'h3: q[3] = val;	// C
					3'h4: q[4] = val;	// I
				endcase
			5'h1A: if(val == 1'b0) begin // MOVF
					q = f;
					// Reset the A flag just in case.
					q[5] = 1'b1;
				end
		endcase
	end
endmodule
