`timescale 1ns/1ps

module synchronizer(clk, Reprogram, Walk_Request, Sensor, Reset, Reset_Sync, Sensor_Sync, WR_Sync, Prog_Sync);
  
  input clk, Reprogram, Walk_Request, Sensor, Reset;
  output reg  Reset_Sync, Sensor_Sync, WR_Sync, Prog_Sync;
  
  always @(posedge clk)
    
    begin
      
      Reset_Sync = Reset;
      Sensor_Sync = Sensor;
      WR_Sync = Walk_Request;
      Prog_Sync = Reprogram;
      
    end
  
endmodule