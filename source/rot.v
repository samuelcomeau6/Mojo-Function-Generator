module rot (
    input clk,  // clock
    input rst,  // reset
    input enc_a,
    input enc_b,
    input enc_sw,
    output reg enc_p,
    output reg enc_d,
    output reg enc_s
  );
  
  reg last_enc_a;
  reg [7:0] delay_d, delay_q;
  wire enc_a_db, enc_b_db, enc_sw_db;
  debounce a_db (.clk(clk),.rst(rst),.in(enc_a),.out(enc_a_db));
  debounce b_db (.clk(clk),.rst(rst),.in(enc_b),.out(enc_b_db));
  debounce s_db (.clk(clk),.rst(rst),.in(enc_sw),.out(enc_s_db));
  /* Combinational Logic */
  always @* begin
    enc_s=~enc_s_db;
    delay_d=delay_q+1'b1;
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
    // Add flip-flop reset values here
    end else begin
      // Add flip-flop q <= d statements here
      
      if(~enc_a_db && last_enc_a) begin
        if(enc_b_db) enc_d<=0;
        else enc_d<=1;
        enc_p<=1;
      end else begin
        delay_q<=delay_d;
        if(&delay_q) begin
          enc_p<=0;
          delay_q<=3'b0;
        end
      end
      last_enc_a<=enc_a_db;
    end
  end
endmodule