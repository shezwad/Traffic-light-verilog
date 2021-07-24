module LED_lights (LEDs, Rm,Ym,Gm,Rs,Ys,Gs,Walk);
  
  input[6:0] LEDs;
  output Rm,Ym,Gm,Rs,Ys,Gs,Walk;
  
  reg Rm,Ym,Gm,Rs,Ys,Gs,Walk;
  
  always @ (LEDs)
    begin
      Rm <= LEDs[6:6]; 
      Ym <= LEDs[5:5];
      Gm <= LEDs[4:4];
      Rs <= LEDs[3:3];
      Ys <= LEDs[2:2];
      Gs <= LEDs[1:1];
      Walk <= LEDs[0:0];
    end
endmodule
