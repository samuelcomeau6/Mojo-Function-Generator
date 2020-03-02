/*
338 Timing Errors @ 200MHz
TODO:
-Create arbitrary wave form function
*/
module gen_driver #(parameter CLK_FREQ = 50000000,S_CLK_FREQ = 50000000)(
    input clk,  // clock
    input sclk,
    input rst,  // reset
    input [1:0] mode,
    input [31:0] freq,
    output [5:0] out
  );
  wire [5:0] saw_out;
  wire [5: 0] sine_out;
  wire [5: 0] square_out;
  wire [5: 0] triangle_out;
  reg [5 : 0] gen_out;
  wire [127 : 0] div;
  reg [127 : 0] div_q,div_d;
  wire [127 : 0] s_div;
  reg [127 : 0] s_div_q,s_div_d;
  //reg [26:0] counter_r;
  //wire [26 :0] counter;
  //assign counter=counter_r;
  assign out=gen_out;
  assign div=div_q;
  assign s_div=s_div_q;
  square square_fnc (.clk(clk),.rst(rst),.div(div),.fnc(square_out));
  sine sine_fnc (.clk(clk),.rst(rst),.div(div),.fnc(sine_out));
  triangle triangle_fnc (.clk(clk),.rst(rst),.div(div),.fnc(triangle_out));
  saw saw_fnc (.clk(clk),.rst(rst),.div(div),.fnc(saw_out));
  
  /* Combinational Logic */
  always @* begin
    div_d<=div_q;
    s_div_d<=s_div_q;
    div_d<=CLK_FREQ*freq>>32;
    s_div_d<=S_CLK_FREQ*freq>>32;
    case(mode)
      2'b00:gen_out<=square_out;
      2'b01:gen_out<=sine_out;
      2'b10:gen_out<=triangle_out;
      2'b11:gen_out<=saw_out;
    endcase
  end
  
  /* Sequential Logic */
  always @(posedge sclk) begin
    if (rst) begin
    // Add flip-flop reset values here
    //counter_r<=27'b0;
    //end else if(counter_r==div) begin
    //counter_r<=27'b0;
    end else begin
      // Add flip-flop q <= d statements here
      div_q<=div_d;
      s_div_q<=s_div_d;
      //counter_r<=counter_r+1'b1;
    end
  end
  
endmodule