`timescale 1ns/1ps
`include "timer.v"

module timer_testbench;
  
  reg Hz1_enable, start_timer, clk, Reset; 
  reg [3:0] value;
  wire expired;
  wire divider_reset;
  
  timer t1(Hz1_enable, value, start_timer, Reset, expired, clk, divider_reset);
  
  initial begin
    $dumpfile("timer.vcd");
    $dumpvars(0,timer_testbench);
    
    
    Hz1_enable = 0;
    Reset = 1;
    start_timer = 0;
    value = 4'b0110;
    
    #4 Reset = 0;
    #2 start_timer = 1;
    #3 start_timer = 0;
    
    #20
    value = 4'b0010;
    start_timer = 1;
    #2 start_timer = 0;
    
    #20 $finish();
  end
    
    initial forever #1 Hz1_enable =~ Hz1_enable;
    
  
endmodule