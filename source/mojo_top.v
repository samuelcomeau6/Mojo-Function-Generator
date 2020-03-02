module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    input enc_sw,
    input enc_a,
    input enc_b,
    output [5:0]fnc
  );
 
  wire rst = ~rst_n; // make reset active high
 
  assign led = 8'b0;
 
  wire [7:0] tx_data;
  wire new_tx_data;
  wire tx_busy;
  wire [7:0] rx_data;
  wire new_rx_data;
  wire [1:0] mode;
  wire [31:0] freq;
  wire dclk;
  wire sclk;
  clk_wiz_v3_6 cgclk (.CLK_IN1(clk),.CLK_OUT1(dclk),.CLK_OUT2(sclk),.RESET(rst));
  parameter D_CLK=200000000;
  parameter S_CLK=50000000;
  
  avr_interface #(.CLK_FREQ(50000000)) avr_interface (
    .clk(sclk),
    .rst(rst),
    .cclk(cclk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_ss(spi_ss),
    .spi_channel(spi_channel),
    .tx(avr_rx), // FPGA tx goes to AVR rx
    .rx(avr_tx),
    .channel(4'd15), // invalid channel disables the ADC
    .new_sample(),
    .sample(),
    .sample_channel(),
    .tx_data(tx_data),
    .new_tx_data(new_tx_data),
    .tx_busy(tx_busy),
    .tx_block(avr_rx_busy),
    .rx_data(rx_data),
    .new_rx_data(new_rx_data)
  );
 
  user_interface mode_selector (
    .clk(sclk),
    .rst(rst),
    .tx_data(tx_data),
    .new_tx_data(new_tx_data),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .new_rx_data(new_rx_data),
    .freq(freq),
    .enc_sw(enc_sw),
    .enc_a(enc_a),
    .enc_b(enc_b),
    .mode(mode)
  );

  gen_driver #(.CLK_FREQ(D_CLK)) gen_driver (
    .clk(dclk),
    .sclk(sclk),
    .rst(rst),
    .mode(mode),
    .freq(freq),
    .out(fnc)
   );
endmodule
