`timescale 1ns/1ps

module timer (Hz1_enable, value, start_timer, Reset, expired, clk, divider_reset);
  
  input[3:0] value;
  input Hz1_enable, start_timer, clk, Reset;  
  output expired, divider_reset;
  reg expired, divider_reset;

  reg start_flag;
  reg [3:0] counter;

  
  always @(posedge Hz1_enable, Reset)
    begin 
     if (Reset == 1)
      begin
       expired = 0;
       divider_reset = 1;
       counter = 4'b0000;
       start_flag = 0;
      end
    else if (counter == value)
      begin
    	expired = 1;
      	counter = 4'b0000;
      	start_flag = 0;
      end
    else if (start_timer == 1) 
      begin
      	start_flag = 1;
        divider_reset = 1;
      end
    else if (start_flag == 1) 
      begin
      	counter = counter + 4'b0001;
      end 
    else 
      begin
      expired = 0;
      end 
  end

endmodule