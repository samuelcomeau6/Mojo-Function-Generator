/*
124 Timing Errors @ 200MHz
*/
module saw (
    input clk,  // clock
    input rst,  // reset
    input [26 : 0] div,
    output [5:0] fnc
  );
  
  //parameter clk_freq=27'd100_000_000;
  //reg [26 : 0] div;
  reg [26 : 0] counter; //therefore countermax is 26'
  reg [20 : 0] min_div;
  reg [5 : 0] fnc_d,fnc_q;
  assign fnc=fnc_q;
   
  initial begin
    //div=clk_freq/freq; //div max is 26bits
  end
  
  /* Combinational Logic */
  always @* begin
    min_div=div>>6;
    fnc_d = fnc_q+1;
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
      counter <= 27'b0;
      fnc_q <= 5'b0;
    end else if(counter>=min_div) begin
      counter <= 27'd0;
      fnc_q <= fnc_d;
    end else if(&fnc_q==1) begin
      fnc_q <=6'b0;
    end else begin
      // Add flip-flop q <= d statements here
      counter <= counter+1'b1;
      
    end
  end
  
endmodule