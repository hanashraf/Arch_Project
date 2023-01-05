module tx (
  input clk,
  input rst,
  input trans_en,
  input [7:0] trans_data,   //8 bits(1 byte)
  output trans_busy,
  output reg txd
);
  reg trans_busy_int;
  reg [7:0] trans_shift_reg;
  reg [3:0] trans_state;

  // controlling transmission of data 
  always @(posedge clk) 
    begin
    if (rst) 
      begin
      trans_state <= 4'b0000;
    end 
    else 
      begin
      case (trans_state)
	// idle
        4'b0000: 
  	  begin  
          if (trans_en) 
	    begin
            trans_shift_reg <= trans_data;
            trans_state <= 4'b0001;
          end
        end
	// transmitting data
        4'b0001: begin  
          txd <= trans_shift_reg[7];
          trans_shift_reg <= trans_shift_reg << 1;
          if (trans_shift_reg == 0)
	    begin
            trans_state <= 4'b0000;
          end
        end
      endcase
    end
  end

  // when the transmitter is transmitting data, set trans_busy 
  always @(posedge clk) 
    begin
    if (rst) begin
      trans_busy_int <= 1'b0;
    end else 
      begin
      trans_busy_int <= (trans_state != 4'b0000);
    end
  end

  assign trans_busy = trans_busy_int;
endmodule

module rx (
  input clk,
  input rst,
  input rxd,
  output [7:0] rec_data_out,
  output rec_valid_out
);
  reg [7:0] rec_shift;
  reg [3:0] rec_state;
  reg rec_valid;
  reg [7:0] rec_data;
  // controlling receiving of data
  always @(posedge clk) 
    begin
    if (rst) 
      begin
      rec_state <= 4'b0000;
    end else 
      begin
      case (rec_state)
        4'b0000: 
          begin  // idle state
          if (rxd) 
            begin
            rec_shift<= 8'b0;
            rec_state <= 4'b0001;
          end
        end
        4'b0001: 
          begin  // receiving data
          rec_shift <= {rec_shift[6:0], rxd};
          if (rec_shift[7]) 
            begin
            rec_state <= 4'b0000;
	    rec_data <= rec_shift; // storing received data in data register of the receiver
          end
        end
      endcase
    end
  end

  //when a complete data word has been received,set rx_valid 
  always @(posedge clk) 
    begin
    if (rst) begin
      rec_valid<= 1'b0;
    end else begin
      rec_valid<= (rec_state == 4'b0000);
    end
  end

  assign rec_data_out = rec_data;
  assign rec_valid_out = rec_valid;

endmodule

module bd_generator (
  input clk,
  input rst,
  input [31:0] rate_bd,
  output clk_bd
);
  reg [31:0] counter_bd;
  reg [3:0] state_bd;

  // generating baud rate clock
  always @(posedge clk) 
    begin
    if (rst) begin
      state_bd <= 4'b0000;
    end else 
      begin
      case (state_bd)
        4'b0000: 
          begin  // idle state
          counter_bd <= counter_bd + 1;
          if (counter_bd == rate_bd) begin
            counter_bd <= 0;
            state_bd <= 4'b0001;
          end
        end
        4'b0001: 
          begin  // asserting baud_clk
          state_bd <= 4'b0000;
        end
      endcase
    end
  end

  assign clk_bd = (state_bd == 4'b0001);
endmodule


module oversampling_clk_generator (
  input clk,
  input rst,
  input [31:0] rate_bd,
  input [4:0] oversampling_factor,
  output oversampling_clock
);
  reg [31:0] counter_bd;
  reg [3:0] state_bd;
  reg [3:0] oversampling_counter;

  // generating oversampling clock
  always @(posedge clk) 
    begin
    if (rst) 
      begin
      state_bd <= 4'b0000;
      oversampling_counter <= 4'b0000;
    end else 
      begin
      case (state_bd)
        4'b0000:
          begin  // idle
          counter_bd <= counter_bd + 1;
          if (counter_bd == rate_bd) 
            begin
            counter_bd <= 0;
            state_bd <= 4'b0001;
          end
        end
        4'b0001: 
          begin  // asserting oversampling_clk
          oversampling_counter <= oversampling_counter + 1;
          if (oversampling_counter == oversampling_factor) 
            begin
            state_bd <= 4'b0000;
            oversampling_counter <= 0;
          end
        end
      endcase
    end
  end

  assign oversampling_clock = (state_bd == 4'b0001);
endmodule


module apb_slave(
input P_clk,
input P_resetn,
input P_sel,
input P_enable,
input P_write,
input [7:0] P_address,
input [7:0] PW_data,
output [7:0] PR_data,
output reg P_ready
);

// declaring registers that hold the address and data
reg [7:0] reg_address;
reg [7:0] mem [0:255];

// assigning the value at the specified address to PRDATA1
assign PR_data = mem[reg_address];

always @(*)
begin
    // set P_ready to 0, if P_resetn is low 
    if (!P_resetn)
        P_ready = 0;
    else
    begin
        // set P_ready to 0 , if P_sel is high and P_enable and P_write are low,
        if (P_sel && !P_enable && !P_write)
            P_ready = 0;
        //  set P_ready to 1 and set the address to the value on P_address , if P_sel is high and P_enable is high and P_write is low
        else if (P_sel && P_enable && !P_write)
        begin
            P_ready = 1;
            reg_address = P_address;
        end
        //set P_ready to 0 ,if P_sel is high and P_enable is low and P_write is high
        else if (P_sel && !P_enable && P_write)
            P_ready = 0;
        // set P_ready to 1 and write the value on PW_data to the address specified by P_address, if P_sel is high and P_enable and P_write are high
        else if (P_sel && P_enable && P_write)
        begin
            P_ready = 1;
            mem[P_address] = PW_data;
        end
        else // Otherwise, set P_ready to 0
            P_ready = 0;
    end
 end  
    
endmodule



module uart_controller (
  input clk,
  input rst,
  input [1:0] sel,
  input [1:0] wen,
  input [3:0] address,
  input [7:0] wdata,
  input trans_en,
  input rxd,
  input [31:0] rate_bd,
  input [7:0] trans_data,
  output [7:0] rdata,
  output [1:0] ack,
  output trans_busy,
  output txd,
  output [7:0] rec_data_out,
  output rec_valid_out,
  output clk_bd
);
  reg [31:0] baud_rate_int;
  // instantiate transmitter, receiver, baud rate generator, and APB slave modules


  bd_generator baudrate_generator (
    .clk(clk),
    .rst(rst),
    .rate_bd(rate_bd),
    .clk_bd(clk_bd)
  );

  // instantiate oversampling clock generator
  oversampling_clk_generator oversampling_gen (
    .clk(baudrate_generator.clk_bd),
    .rst(rst),
    .rate_bd(rate_bd),  // set baud rate as desired
    .oversampling_factor(16),  // set oversampling factor to 16
    .oversampling_clock(oversampling_clock)
  );


  tx transmitter (
    .clk(baudrate_generator.clk_bd),
    .rst(rst),
    .trans_data(trans_data),
    .trans_en(trans_en),
    .trans_busy(trans_busy),
    .txd(txd)
  );
  rx receiver (
    .clk(oversampling_gen.oversampling_clock),
    .rst(rst),
    .rxd(rxd),
    .rec_data_out(rec_data_out),
    .rec_valid_out(rec_valid_out)
  );

  apb_slave slave (
    .P_clk(clk),
    .P_resetn(rst),
    .P_sel(sel),
    .P_enable(wen),
    .P_write(address[3]),
    .P_address(address[2:0]),
    .PW_data(wdata),
    .PR_data(rdata),
    .P_ready(ack)
  );

  // connect inputs and outputs of transmitter, receiver, and baud rate generator to APB slave module
  always @(posedge clk) 
    begin
    if (rst) begin
      baud_rate_int <= 0;
    end else if (sel && !wen && !address[3] && address[2:0] == 3'b000) 
      begin
      baud_rate_int <= wdata;
    end
  end

  assign rate_bd = baud_rate_int;
  assign trans_data = slave.mem[1];
  assign trans_en = slave.mem[2][0];
  assign rec_valid_out = slave.mem[4][0];
  assign rec_data_out = slave.mem[5];

endmodule
