`timescale 1ns/1ps
`include "Walk_Register.v"

module Walk_Register_testbench;
  
  reg clk;
  reg WR_Sync;
  reg WR_Reset;
  reg Reset_Sync;
  
  wire WR_Status;
  
  Walk_Register t1 (clk, WR_Reset, Reset_Sync, WR_Sync, WR_Status);
  
  initial begin
    
    $dumpfile("Walk_Register.vcd");
    $dumpvars(0,Walk_Register_testbench);
    
    WR_Sync = 0;
    clk = 0;
    WR_Reset = 0;
    Reset_Sync = 0;
    
    #2 WR_Reset = 1;
    
    #2 WR_Sync = 1;
    
    #4
   
    WR_Reset = 0;
    WR_Sync = 1;
    
    #2 WR_Sync = 0;
    
    #2 WR_Reset = 1;
    
    #5 $finish();
    
  end
  
  initial begin
    
    forever #1 clk =~ clk;
    
  end
  
endmodule
  