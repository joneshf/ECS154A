module onefourbusdecode(input logic [1:0] addr,
								input logic CS,
								output logic status,
								output logic intmask,
								output logic datareg,
								output logic baudratedivisor);
	always_comb begin
		status = 1'b0;
		intmask = 1'b0;
		datareg = 1'b0;
		baudratedivisor = 1'b0;
		if(CS) begin
			case(addr)
				2'b00: status = 1'b1;
				2'b01: intmask = 1'b1;
				2'b10: datareg = 1'b1;
				2'b11: baudratedivisor = 1'b1;
			endcase
		end
	end
		
endmodule
