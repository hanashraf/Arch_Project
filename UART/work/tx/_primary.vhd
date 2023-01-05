library verilog;
use verilog.vl_types.all;
entity tx is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        trans_en        : in     vl_logic;
        trans_data      : in     vl_logic_vector(7 downto 0);
        trans_busy      : out    vl_logic;
        txd             : out    vl_logic
    );
end tx;
