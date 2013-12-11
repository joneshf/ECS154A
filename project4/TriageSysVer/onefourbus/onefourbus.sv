module onefourbus(input logic [7:0] in,
								input logic [1:0] addr,
								input logic CS,
								output logic [7:0] status,
								output logic [7:0] intmask,
								output logic [7:0] data,
								output logic [7:0] baudratedivisor);
	always_comb begin
		status = 8'bz;
		intmask = 8'bz;
		data = 8'bz;
		baudratedivisor = 8'bz;
		if(CS) begin
			case(addr)
				2'b00: status = in;
				2'b01: intmask = in;
				2'b10: data = in;
				2'b11: baudratedivisor = in;
			endcase
		end
	end
		
endmodule