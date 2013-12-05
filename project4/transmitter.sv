module transmitter(	input logic clk,
							input logic tf,
							input logic [3:0] framesize,
							input logic [127:0] framebits,
							input logic [7:0] crc,
							input logic [7:0] baudrate,
							output logic TXI,
							output logic TX);

	logic startbit = 1'b1;
	logic stopbit = 1'b0;
	//logic [7:0] counter1, counter2, counter3, counter4, counter5 = 8'b0;
	//logic [2:0] statemachine = 3'b0;
	
	initial begin
		TXI = 1'b1;
	end
						
	always@(posedge clk, posedge tf) begin
		if(tf & (framesize != 4'b0)) begin
			TXI <= 1'b0;
			
			for(int i = 0; i < baudrate; ++i) {
				TX <= startbit;
			}
			for(int jj = 3; jj >= 0; --jj) {
				for(int j = 0; j < baudrate; ++j) {
					TX <= framesize[jj];
				}
			}
			for(int kk = 0; kk < framesize; ++kk) {
				for(int kkj = 7; kkj >= 0; --kkj) {
					for(int k = 0; k < baudrate; ++k) {
						TX <= framebits[(kk * 8) + kkj];
					}
				}
			}
			for(int l = 7; l >= 0; --l) {
				for(int ll = 0; ll < baudrate; ++ll) {
					TX <= crc[l];
				}
			}
			for(int m = 0; m < baudrate; ++m) {
				TX <= startbit;
			}
			
			TXI <= 1'b1;
		end
	end
endmodule
		