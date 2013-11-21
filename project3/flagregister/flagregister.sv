module flagregister(input logic clk,
						  input logic [7:0]f,	  //flag bits
						  input logic [4:0]i,	  //instruction bits
						  input logic [2:0]s,	  //flag selector bits
						  input logic val,	  //LSB for LDIF/MOVF
						  output logic [7:0]q);	  //output flag bits
	always_ff@(posedge clk)

	case (i)
		5'h00: q[3:0] = f[3:0]; // ADD  CNOZ
		5'h01: q[3:0] = f[3:0]; // SUB  CNOZ
		5'h02: q[3:0] = f[3:0]; // ADDI CNOZ
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
				q[2:1] = f[2:1];
				q[0] = f[0];
			end
		5'h09: begin 				// ROL  CN Z
				q[2:1] = f[2:1];
				q[0] = f[0];
			end
		5'h0A: begin 				// SHR  CN Z
				q[2:1] = f[2:1];
				q[0] = f[0];
			end
		5'h0B: begin 				// SHL  CN Z
				q[2:1] = f[2:1];
				q[0] = f[0];
			end
		5'h19:						// LDIF
			case (s)
				3'h0: q[0] = val;
				3'h1: q[1] = val;
				3'h2: q[2] = val;
				3'h3: q[3] = val;
				3'h4: q[4] = val;
				3'h5: q[5] = val;
				3'h6: q[6] = val;
			endcase
		5'h1A: if(val == 1'b0) q = f; // MOVF
	endcase

endmodule
