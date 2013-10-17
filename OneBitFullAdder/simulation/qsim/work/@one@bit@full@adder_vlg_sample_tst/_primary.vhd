library verilog;
use verilog.vl_types.all;
entity OneBitFullAdder_vlg_sample_tst is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        C_IN            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end OneBitFullAdder_vlg_sample_tst;
