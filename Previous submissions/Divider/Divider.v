//divider timescale 1ms/1us
//divider timescale 1ns/1ps

//`timescale 1ms /1us
`timescale 1ns/1ps

module Divider(clk, divider_reset, Hz1_enable);
  
  input clk,divider_reset;
  output reg Hz1_enable = 0;
  
  //reg [9:0] count = 10'b0;
  reg [29:0] count = 30'b0;

  always @ (posedge clk)
    begin
      if (divider_reset == 1)
        //count = 10'b0;
        count = 30'b0;
      else
        count = count + 1;
      //Hz1_enable = count[9];
        Hz1_enable = count[29];
    end
  
endmodule
  