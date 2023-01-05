module testbench_oversampling();
  // Declare input and output signals for the MUT
  reg clk, rst;
  reg [31:0] rate_bd;
  reg [4:0] oversampling_factor;
  wire oversampling_clock;

  // Instantiate the MUT
  oversampling_clk_generator MUT (
    .clk(clk),
    .rst(rst),
    .rate_bd(rate_bd),
    .oversampling_factor(oversampling_factor),
    .oversampling_clock(oversampling_clock)
  );

  // Initialize input signals and registers
  initial begin
    clk = 0;
    rst = 1;
    rate_bd = 5000000;  // 5 MHz baud rate
    #10
    oversampling_factor = 16;  // 16x oversampling
    #10
    rst = 0;
  end

  // Apply stimuli to the MUT and observe the output responses
  always begin
    #5 clk = ~clk;
  end

  // Print out input and output signals
  initial begin
    $monitor("rate_bd=%d oversampling_factor=%d oversampling_clock=%d", rate_bd, oversampling_factor, oversampling_clock);
  end

  // Test case 1: change oversampling factor
  initial begin
    #150 oversampling_factor = 8;  // 8x oversampling
  end
endmodule


