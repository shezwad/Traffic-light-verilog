
`timescale 1ns/1ps
`include "LED_lights.v"

module LED_lights_test;
  
  reg [6:0] LEDs;
  wire Rm;
  wire Ym;
  wire Gm;
  wire Rs;
  wire Ys;
  wire Gs;
  wire Walk;
  
  LED_lights t1 (LEDs, Rm,Ym,Gm,Rs,Ys,Gs,Walk);
  
  initial begin
     
    $dumpfile("LED_lights.vcd");
    $dumpvars(0,LED_lights_test);
    
    LEDs = 0;
    #100;
    
    LEDs = 7'b1000000;
    #50;
    LEDs = 7'b0100000;
    #50;
    LEDs = 7'b0010000;
    #50;
    LEDs = 7'b0001000;
    #50;
    LEDs = 7'b0000100;
    #50;
    LEDs = 7'b0000010;
    #50;
    LEDs = 7'b0000001;
    
    #20 $finish();
    
  end
endmodule
  