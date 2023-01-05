library verilog;
use verilog.vl_types.all;
entity uart_controller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        sel             : in     vl_logic_vector(1 downto 0);
        wen             : in     vl_logic_vector(1 downto 0);
        address         : in     vl_logic_vector(3 downto 0);
        wdata           : in     vl_logic_vector(7 downto 0);
        trans_en        : in     vl_logic;
        rxd             : in     vl_logic;
        rate_bd         : in     vl_logic_vector(31 downto 0);
        trans_data      : in     vl_logic_vector(7 downto 0);
        rdata           : out    vl_logic_vector(7 downto 0);
        ack             : out    vl_logic_vector(1 downto 0);
        trans_busy      : out    vl_logic;
        txd             : out    vl_logic;
        rec_data_out    : out    vl_logic_vector(7 downto 0);
        rec_valid_out   : out    vl_logic;
        clk_bd          : out    vl_logic
    );
end uart_controller;
