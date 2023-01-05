module testbench_slave;
  // input signals
  reg P_clk;
  reg P_resetn;
  reg  P_sel;
  reg  P_write;
  reg [31:0] P_address;
  reg [7:0] PW_data;
  reg P_enable,
  reg P_ready

  // output signals
  reg [7:0] PR_data;


  // instantiate the apb_slave module
  apb_slave dut (
    .P_clk(P_clk),
    .P_resetn(P_resetn),
    .P_sel(P_sel),
    .P_enable(P_enable),
    .P_address(P_address),
    .PW_data(PW_data),
    .PR_data(PR_data),
    .P_ready(P_ready)
    .P_write(P_write)
  );

  // initialize the apb_slave module with a reset signal
  initial begin
    rst = 1'b1;
  end

  // write a value to the baud rate register
  initial begin
    P_clk = 1'b0;
    P_sel = 2'b00;
    P_enable = 1'b1;
    #10
    P_address = 4'b0000;
    PW_data = 8'h12;
    P_write = 1'b0;
    #10;
    P_resetn = 1'b0;
  end

  // read the value of the baud rate register
  initial begin
    #100
    P_sel = 2'b01;
    P_enable = 1'b0;
    P_address = 4'b0000;
    #10;
    #10;
    $display("baud rate = %h", PR_data);
    #10;
  end

  // clock generator
  always begin
    #5;
    clk = ~clk;
  end
endmodule

