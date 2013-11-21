module twotoonebusmux
	#(parameter width = 16)
				(input logic [width-1:0] d0,d1,
				 input logic s,
				 output logic [width-1:0] y);
							 
	assign y = s ? d0:d1;
endmodule