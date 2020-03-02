/*
136 Timing Errors @ 200MHz
TODO:
-Improve high frequency response
-Eliminate 6-8 timing errors at 200MHz
*/
module sine (
    input clk,  // clock
    input rst,  // reset
    input [26 : 0] div,
    output [5:0] fnc
  );
  
  reg [5 :0] sine_rom[63:0];
  reg [26 : 0] min_div; //Sets delay in cycles for each increment
  reg [26 : 0] counter; //therefore countermax is 26'
  reg [5 : 0] add_q,add_d;
  //assign fnc={&fnc_q,next_off[0],off_addr_q[0],next_on[0],on_addr_q[0],aclk,(counter==next_off),(counter==next_on)};
  assign fnc=sine_rom[add_q];
  initial begin
    //Begin ROM, resolution: 6 bits
    sine_rom[0]=32;sine_rom[1]=35;sine_rom[2]=38;sine_rom[3]=41;sine_rom[4]=44;sine_rom[5]=47;sine_rom[6]=49;sine_rom[7]=52;
    sine_rom[8]=54;sine_rom[9]=56;sine_rom[10]=58;sine_rom[11]=60;sine_rom[12]=61;sine_rom[13]=62;sine_rom[14]=63;sine_rom[15]=63;
    sine_rom[16]=63;sine_rom[17]=63;sine_rom[18]=62;sine_rom[19]=61;sine_rom[20]=60;sine_rom[21]=59;sine_rom[22]=57;sine_rom[23]=55;
    sine_rom[24]=53;sine_rom[25]=51;sine_rom[26]=48;sine_rom[27]=45;sine_rom[28]=42;sine_rom[29]=39;sine_rom[30]=36;sine_rom[31]=33;
    sine_rom[32]=30;sine_rom[33]=27;sine_rom[34]=24;sine_rom[35]=21;sine_rom[36]=18;sine_rom[37]=15;sine_rom[38]=12;sine_rom[39]=10;
    sine_rom[40]=8;sine_rom[41]=6;sine_rom[42]=4;sine_rom[43]=3;sine_rom[44]=2;sine_rom[45]=1;sine_rom[46]=0;sine_rom[47]=0;
    sine_rom[48]=0;sine_rom[49]=0;sine_rom[50]=1;sine_rom[51]=2;sine_rom[52]=3;sine_rom[53]=5;sine_rom[54]=7;sine_rom[55]=9;
    sine_rom[56]=11;sine_rom[57]=14;sine_rom[58]=16;sine_rom[59]=19;sine_rom[60]=22;sine_rom[61]=25;sine_rom[62]=28;sine_rom[63]=31;
    //End ROM
    
  end
  
  /* Combinational Logic */
  always @* begin
    min_div=(div>>6);
    add_d=add_q+1;
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
      counter <= 0;
      add_q<= 0;
    end
    else if(counter>=min_div) begin
      counter<=27'd0;
      add_q<=add_d;
    end
    else counter <= counter+1'b1;
  end
  
endmodule