module crc (
        input logic clk,
        input logic [11:0] datain,
        output logic [7:0] dataout
    );

    // Our polynomial is x^8 + x^4 + x^3 + x^2 + 1
    // This algorithm is borrowed from
    // http://en.wikipedia.org/wiki/Computation_of_CRC#Implementation
    logic [8:0] polynomial = 9'b100011101;
    logic [8:0] remainder = 9'b0;
    always_ff@(posedge clk) begin
        for (int i = 11; i > 0; --i) begin
            remainder = remainder ^ (datain[i] << 8);
            if(remainder[8] == 1'b1)
                remainder = (remainder << 1) ^ polynomial;
            else
                remainder = remainder << 1;
        end
        dataout = remainder[7:0];
    end
endmodule
