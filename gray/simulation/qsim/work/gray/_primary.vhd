library verilog;
use verilog.vl_types.all;
entity gray is
    port(
        G0              : out    vl_logic;
        B0              : in     vl_logic;
        B1              : in     vl_logic;
        G1              : out    vl_logic;
        B2              : in     vl_logic;
        G2              : out    vl_logic;
        B3              : in     vl_logic;
        G3              : out    vl_logic
    );
end gray;
