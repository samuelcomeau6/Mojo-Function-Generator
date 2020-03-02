/*
This module takes user input from a rotary encoder or a serial connection 
and returns a serial output or change in mode or frequency value
TODO:
-Fix button implementation
  -Latch or delay mode switch
  -Change mode to a state change so there is serial output
-Return a frequency value

*/
module user_interface (
    input clk,
    input rst,
    output [7:0] tx_data,
    output reg new_tx_data,
    input tx_busy,
    input [7:0] rx_data,
    input new_rx_data,
    input enc_sw,
    input enc_a,
    input enc_b,
    output [31:0] freq,
    output [1:0] mode
  );
  
  localparam STATE_SIZE = 8;
  localparam IDLE = 0,
    SQUARE_WAVE = 1,
    SINE_WAVE = 2,
    TRIANGLE_WAVE = 3,
    SAW_WAVE = 4,
    UP_FREQ = 5,
    DOWN_FREQ = 6,
    RESET_FREQ = 7,
    SET_1 = 8,
    SET_10 = 9,
    SET_100 = 10,
    SET_1_000 = 11,
    SET_10_000 = 12,
    SET_100_000 = 13,
    SET_1_000_000 =14,
    SET_10_000_000 = 15,
    DOUB_FREQ = 16,
    HALF_FREQ = 17;
  
  localparam MESSAGE_LEN = 14;
  
  reg [STATE_SIZE-1:0] state_d, state_q;
  
  reg [3:0] addr_d, addr_q;
  reg [1:0] mode_q=0, mode_d;
  reg [31:0] freq_q=32'd2147483, freq_d;
  wire enc_p, enc_d, enc_s;
  
  transmit_rom message_rom (
    .clk(clk),
    .addr(addr_q),
    .data(tx_data),
    .mess(state_q)
  );

 rot rot1 (
    .clk(clk),
    .rst(rst),
    .enc_a(enc_a),
    .enc_b(enc_b),
    .enc_sw(enc_sw),
    .enc_p(enc_p),
    .enc_d(enc_d),
    .enc_s(enc_s)
    );

  assign mode = mode_q;
  assign freq = freq_q;
  
  always @(*) begin
    state_d = state_q; // default values
    addr_d = addr_q;   // needed to prevent latches
    mode_d = mode_q;
    freq_d = freq_q;
    new_tx_data = 1'b0;
    
    case (state_q)
      IDLE: begin
        addr_d = 4'd0;
        if (enc_p && enc_d) state_d = UP_FREQ;
        if (enc_p && ~enc_d) state_d = DOWN_FREQ;
        
        if (new_rx_data && rx_data == "s")
          state_d = SQUARE_WAVE;
        if (new_rx_data && rx_data == "i")
          state_d = SINE_WAVE;
        if (new_rx_data && rx_data == "t")
          state_d = TRIANGLE_WAVE;
        if (new_rx_data && rx_data == "a")
          state_d = SAW_WAVE;
        if (new_rx_data && rx_data == "=")
          state_d = UP_FREQ;
        if (new_rx_data && rx_data == "-")
          state_d = DOWN_FREQ;
        if (new_rx_data && rx_data == "u")
          state_d = DOUB_FREQ;
        if (new_rx_data && rx_data == "d")
          state_d = HALF_FREQ;
        if (new_rx_data && rx_data == "r")
          state_d = RESET_FREQ;
        if (new_rx_data && rx_data == "1")
          state_d = SET_1;
        if (new_rx_data && rx_data == "2")
          state_d = SET_10;
        if (new_rx_data && rx_data == "3")
          state_d = SET_100;
        if (new_rx_data && rx_data == "4")
          state_d = SET_1_000;
        if (new_rx_data && rx_data == "5")
          state_d = SET_10_000;
        if (new_rx_data && rx_data == "6")
          state_d = SET_100_000;
        if (new_rx_data && rx_data == "7")
          state_d = SET_1_000_000;
        if (new_rx_data && rx_data == "8")
          state_d = SET_10_000_000;
        
      end
      SQUARE_WAVE: begin
        mode_d = 2'b00;
      end
      SINE_WAVE: begin
        mode_d = 2'b01;
      end
      TRIANGLE_WAVE: begin
        mode_d = 2'b10;
      end
      SAW_WAVE: begin
        mode_d = 2'b11;
      end
      DOUB_FREQ: begin
        if ((addr_q == MESSAGE_LEN-1)&(!tx_busy)) freq_d = freq_q>>1;
      end
      UP_FREQ: begin
        if ((addr_q == MESSAGE_LEN-1)&(!tx_busy)) freq_d = freq_q-(freq>>4);
      end
      HALF_FREQ: begin
        if ((addr_q == MESSAGE_LEN-1)&(!tx_busy)) freq_d = freq_q<<1;
      end
      DOWN_FREQ: begin
        if ((addr_q == MESSAGE_LEN-1)&(!tx_busy)) freq_d = freq_q+(freq>>4);
      end
      RESET_FREQ: begin
        freq_d = 32'd2147483;
      end
      SET_1: begin
        freq_d = 32'd4294967296;
      end
      SET_10: begin
        freq_d = 32'd429496729;
      end
      SET_100: begin
        freq_d = 32'd42949672;
      end
      SET_1_000: begin
        freq_d = 32'd4294967;
      end
      SET_10_000: begin
        freq_d = 32'd429496;
      end
      SET_100_000: begin
        freq_d = 32'd42949;
      end
      SET_1_000_000: begin
        freq_d = 32'd4294;
      end
      SET_10_000_000: begin
        freq_d = 32'd429;
      end
      default: state_d = IDLE;
    endcase
    if ((!tx_busy)&(state_d!=IDLE)) begin
      new_tx_data = 1'b1;
      addr_d = addr_q + 1'b1;
      if (addr_q == MESSAGE_LEN-1)
        state_d = IDLE;
    end
  end
  
  always @(posedge clk) begin
    if (rst) begin
      state_q <= IDLE;
      mode_q<=2'b00;
      freq_q<=32'd2147483;
    end else begin
      state_q <= state_d;
      if (enc_s) mode_q <= mode_q+1; //TODO: Latch this signal, clean up implementation
      else mode_q <= mode_d;
      freq_q <= freq_d;
    end
    addr_q <= addr_d;
  end
  
endmodule