library verilog;
use verilog.vl_types.all;
entity EightBitRot_vlg_sample_tst is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        \ROL\           : in     vl_logic;
        \ROR\           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end EightBitRot_vlg_sample_tst;
