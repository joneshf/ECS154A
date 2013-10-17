library verilog;
use verilog.vl_types.all;
entity EightBitAdd_vlg_sample_tst is
    port(
        A_IN            : in     vl_logic_vector(7 downto 0);
        B_IN            : in     vl_logic_vector(7 downto 0);
        C_IN            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end EightBitAdd_vlg_sample_tst;
