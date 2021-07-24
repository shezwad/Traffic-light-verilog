`timescale 1ns/1ps
`include "synchronizer.v"

module synchronizer_testbench;
  
  reg clk, Reprogram, Walk_Request, Sensor, Reset;
  wire Reset_Sync, Sensor_Sync, WR_Sync, Prog_Sync;
  
  synchronizer t1 (clk, Reprogram, Walk_Request, Sensor, Reset, Reset_Sync, Sensor_Sync, WR_Sync, Prog_Sync);
  
  initial begin
    
    $dumpfile("synchronizer.vcd");
    $dumpvars(0,synchronizer_testbench);
    
    clk = 0;
    Reset = 0;
    Sensor = 0;
    Walk_Request = 0;
    Reprogram = 0;
    
    
    #2 Reset = 1;
    #3 Reset = 0;
    
    #3 Walk_Request = 1;
    #5 Walk_Request = 0;
    
    #3 Sensor = 1 ;
    #6 Sensor = 0 ;
    
    #2 Reprogram = 1;
    #3 Reprogram = 0;
    
    #8 $finish();
    
  end
  
  initial forever #3 clk =~ clk; 
    
endmodule