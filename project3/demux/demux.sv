module demux(input logic [15:0] datain,
				  input logic select,
				  output logic [15:0] d0,
				  output logic [15:0] d1);
	   always_comb
		if (select == 0){
			d0 <= datain;
			d1 <= 16'bz;
		}
		else if (select == 1){
			d1 <= datain;
			d0 <= 16'bz;
		}
endmodule
