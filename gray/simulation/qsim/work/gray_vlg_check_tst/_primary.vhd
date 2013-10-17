library verilog;
use verilog.vl_types.all;
entity gray_vlg_check_tst is
    port(
        G0              : in     vl_logic;
        G1              : in     vl_logic;
        G2              : in     vl_logic;
        G3              : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end gray_vlg_check_tst;
