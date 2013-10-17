library verilog;
use verilog.vl_types.all;
entity compare is
    port(
        E               : out    vl_logic;
        X0              : in     vl_logic;
        Y0              : in     vl_logic;
        X1              : in     vl_logic;
        Y1              : in     vl_logic;
        X2              : in     vl_logic;
        Y2              : in     vl_logic;
        N               : out    vl_logic
    );
end compare;
