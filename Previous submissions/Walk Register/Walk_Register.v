`timescale 1ns/1ps

module Walk_Register(clk, WR_Reset, Reset_Sync, WR_Sync, WR_Status);
  
  input clk, WR_Reset, Reset_Sync, WR_Sync;
  output reg WR_Status = 0 ;
  
  
  always @ (posedge clk)
    
    begin
      
      WR_Status <= (WR_Reset ||Reset_Sync) ? 0: WR_Status ? WR_Status : WR_Sync;
  
    end
  
  
endmodule