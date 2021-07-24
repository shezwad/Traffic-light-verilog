`timescale 1ns/1ps



module TimeParameters(selector, interval, Prog_Sync,time_value, value, clk, Reset);
	 
  
    input clk, Reset;
	input[1:0] selector;
	input[3:0] Prog_Sync;
	input[1:0] interval;
    input[3:0] time_value;
    output reg[3:0] value;
	
	parameter BASE_ADD = 2'b00;
	parameter EXTD_ADD = 2'b01;
	parameter YELL_ADD = 2'b10;
	
	parameter BASE_DEFAULT = 4'd6;
	parameter EXTD_DEFAULT = 4'd3;
	parameter YELL_DEFAULT = 4'd2;
	
	reg[3:0] BASE_VALUE = BASE_DEFAULT;
	reg[3:0] EXTD_VALUE = EXTD_DEFAULT;
	reg[3:0] YELL_VALUE = YELL_DEFAULT;
		

	always @ (posedge clk)
	begin
      if(Reset)
			begin
				BASE_VALUE = BASE_DEFAULT;
				EXTD_VALUE = EXTD_DEFAULT;
				YELL_VALUE = YELL_DEFAULT;
			end
			
      else if(Prog_Sync)
			begin
			
				case(selector)
				
					BASE_ADD: BASE_VALUE = (Prog_Sync !== 4'd0) ? Prog_Sync : BASE_DEFAULT;
					EXTD_ADD: EXTD_VALUE = (Prog_Sync !== 4'd0) ? Prog_Sync : EXTD_DEFAULT;
					YELL_ADD: YELL_VALUE = (Prog_Sync !== 4'd0) ? Prog_Sync : YELL_DEFAULT;
					
					default:														
						begin
							BASE_VALUE = BASE_DEFAULT;			
							EXTD_VALUE = EXTD_DEFAULT;
							YELL_VALUE = YELL_DEFAULT;
						end
				endcase
				
			end
			
		else
			begin
			
				case(interval)
					BASE_ADD: value <= BASE_VALUE;
					EXTD_ADD: value <= EXTD_VALUE;
					YELL_ADD: value <= YELL_VALUE;
				
					default:
						value <= 4'd15;										
				endcase																	
			
			end
	end
	
endmodule
