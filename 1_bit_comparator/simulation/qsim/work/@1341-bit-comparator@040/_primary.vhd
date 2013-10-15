library verilog;
use verilog.vl_types.all;
entity \1-bit-comparator\ is
    port(
        E               : out    vl_logic;
        X               : in     vl_logic;
        Y               : in     vl_logic;
        N               : out    vl_logic
    );
end \1-bit-comparator\;
