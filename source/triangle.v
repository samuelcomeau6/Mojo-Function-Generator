/*
96 Timing Errors @ 200MHz
*/
module triangle (
    input clk,  // clock
    input rst,  // reset
    input [26 : 0] div,
    output [5:0] fnc
  );
  
  //parameter clk_freq=27'd100_000_000;
  //reg [26 : 0] div;
  reg [26 : 0] counter; //therefore countermax is 26'
  reg [26 : 0] min_div; //Sets delay in cycles for each increment
  reg [5 : 0] fnc_d,fnc_q; //Accumulates fnc
  reg s_d=1,s_q=0; //Switches accumulate/decrement fnc_ff
  assign fnc[5:0]=fnc_q; //Output wire to 64pin bus
  
  initial begin
  //div=clk_freq/freq; //div max is 26bits
  end
  
  /* Combinational Logic */
  always @* begin
    s_d=~s_q; //1'ff
    min_div=(div>>7);
    if(s_q) fnc_d = fnc_q+1; //True, increment by 1 bit 
    else fnc_d = fnc_q-1; //False, decrement by 1 bit.=
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
      counter <= 27'b0;
      fnc_q <= 6'b0;
    end else if(counter==min_div) begin //Counter reaches a minor div, reset counter, increment fnc_ff
      counter <= 27'd0;
      fnc_q <= fnc_d;
    end else counter <= counter+1'b1;
    if(&fnc_q&&s_q) s_q <= s_d;  //Decrement
    else if(~|fnc_q&&~s_q) s_q <=s_d; //increment
    begin
      // Add flip-flop q <= d statements here      
    end
  end
  
endmodule