module testbench_tx();
  // Declaring input and output signals
  reg clk, rst, trans_en;
  reg [7:0] trans_data;
  wire trans_busy;
  wire txd;

  // Instantiating the MUT
  tx MUT (
    .clk(clk),
    .rst(rst),
    .trans_data(trans_data),
    .trans_en(trans_en),
    .trans_busy(trans_busy),
    .txd(txd)
  );

  // Initializing input signals and registers
  initial begin
    clk = 0;
    rst = 1;
    trans_en = 0;
    trans_data = 0;
    #10
    rst = 0;
  end

  // Applying stimuli to the MUT in order to observe the changes
  always begin
    #5 clk = ~clk;
  end

  // Printing input and output signals
  initial begin
    $monitor("trans_data=%d trans_en=%d txd=%d trans_busy=%d", trans_data, trans_en, txd, trans_busy);
  end

  // Test case 1
 //  Transmitting a single data word
  initial begin
    trans_en = 1;
    trans_data = 8'h12;
    #100;
    trans_en = 0;
  end

  // Test case 2
  // Transmitting multiple data words
  initial begin
    #100;
    trans_en = 1;
    trans_data = 8'h34;
    #100;
    trans_data = 8'h87;
    #50;
    trans_en = 0;
  end
endmodule


