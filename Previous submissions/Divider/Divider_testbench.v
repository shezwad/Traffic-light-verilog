
//divider timescale 1ms/1us
//divider timescale 1ns/1ps

//timescale 1ms / 1us
`timescale 1ns/1ps
`include "Divider.v"

module Divider_testbench;
  
  reg clk;
  reg divider_reset;
  wire Hz1_enable;

  Divider t1 (clk, divider_reset, Hz1_enable);
    
  initial begin
    
    $dumpfile("Divider.vcd");
    $dumpvars(0,Divider_testbench);
    
    clk = 0;
    //divider_reset = 1;
    //#100
    divider_reset = 0;
    
    #4000
    divider_reset = 1;
    
    #100 $finish();
  end
  
  initial begin 
    forever #1 clk =~ clk; 
  end
  
endmodule