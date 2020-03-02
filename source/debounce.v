/*
This component takes a binary signal and averages it over
specified number of cycles, then outputs the average value
*/
module debounce #(
  parameter cycles=500 ) (
    input clk,  // clock
    input rst,  // reset
    input in,
    output out
  );
  reg [32:0] delay_q,delay_d;
  reg [32:0] buffer_q, buffer_d;
  reg out_r;
  assign out=out_r;
  /* Combinational Logic */
  always @* begin
    delay_d = delay_q+1;
    buffer_d = buffer_q+in;
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
    end else begin
      // Add flip-flop q <= d statements here
      if(delay_q==cycles) begin
        if(buffer_q>=cycles/2) out_r<=1;
        else out_r<=0;
        delay_q<=0;
        buffer_q<=0;
      end else begin
        delay_q<=delay_d;
        buffer_q<=buffer_d;
      end
    end
  end
  
endmodule
