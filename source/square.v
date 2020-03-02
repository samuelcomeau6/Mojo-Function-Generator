/*
90 Timing Errors @200MHz
TODO:
-Eliminate Logic gates output to fnc
-implement a duty cycle
-Move the f to gen_driver component
*/
module square #(parameter duty=2) (
    input clk,  // clock
    input rst,  // reset
    input [26:0] div, //Fraction
    output [5:0] fnc
  );
  
  reg [26 : 0] counter; //therefore countermax is 26'
  reg [32 : 0] f; //f max is 26' by 7' = 33'
  //reg [63 : 0] div; //max is 27 by 20 = 37'
  
  initial begin

  end
  
  assign fnc[5:0] = {6{(counter>=f)}};
  
  /* Combinational Logic */
  always @* begin
    f=div*duty>>2; //Move to the Function Gen
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
      counter <= 27'b0;
    end else if(counter>=div) begin
      counter<=27'd0;
    end else begin
      // Add flip-flop q <= d statements here
      counter <= counter+1'b1;
    end
  end
  
endmodule