library verilog;
use verilog.vl_types.all;
entity OneBitFullAdder_vlg_check_tst is
    port(
        C_OUT           : in     vl_logic;
        S               : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end OneBitFullAdder_vlg_check_tst;
