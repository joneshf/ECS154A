module demux(input logic [15:0] datain,
				  input logic select,
				  output logic [15:0] d0,
				  output logic [15:0] d1);
	always_comb
		begin
			case (select)
				1'b0:
					begin
						d0 = datain;
						d1 = 16'bz;
					end
				1'b1:
					begin
						d0 = 16'bz;
						d1 = datain;
					end
			endcase
		end
endmodule
