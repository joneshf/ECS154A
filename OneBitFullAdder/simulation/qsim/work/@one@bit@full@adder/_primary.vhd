library verilog;
use verilog.vl_types.all;
entity OneBitFullAdder is
    port(
        S               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C_IN            : in     vl_logic;
        C_OUT           : out    vl_logic
    );
end OneBitFullAdder;
