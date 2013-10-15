library verilog;
use verilog.vl_types.all;
entity project_01_vlg_sample_tst is
    port(
        X0              : in     vl_logic;
        X1              : in     vl_logic;
        X2              : in     vl_logic;
        Y0              : in     vl_logic;
        Y1              : in     vl_logic;
        Y2              : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end project_01_vlg_sample_tst;
