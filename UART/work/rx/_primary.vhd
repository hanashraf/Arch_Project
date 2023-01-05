library verilog;
use verilog.vl_types.all;
entity rx is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rxd             : in     vl_logic;
        rec_data_out    : out    vl_logic_vector(7 downto 0);
        rec_valid_out   : out    vl_logic
    );
end rx;
