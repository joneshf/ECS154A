module fouronebusmux(input logic [7:0] zero,
							input logic [7:0] one,
							input logic [7:0] two,
							input logic [7:0] three,
							input logic [1:0] select,
							output logic [7:0] out);
							
	always_comb begin
		case(select)
			2'b00: out = zero;
			2'b01: out = one;
			2'b10: out = two;
			2'b11: out = three;
		endcase
	end
endmodule
