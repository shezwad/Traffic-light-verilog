//`timescale 1ms / 1ms

//////////////////////////////////////////////////////////////////////////////////
//////////////             E/15/335 - fulldesign                 /////////////////
//////////////     EE587 : Digital System Design and Synthesis   /////////////////
//////////////                 Assignment                        /////////////////
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////
////////       FSM        //////////////////
////////////////////////////////////////////
module FSM(Sensor_Sync, WR_Status, Prog_Sync, expired, WR_Reset, interval, start_timer, LEDs, clk, Reset_Sync);
	
    input Sensor_Sync, WR_Status, expired, clk, Reset_Sync;
	input [3:0] Prog_Sync;
	output WR_Reset, start_timer;
    output[6:0] LEDs;
	output[1:0] interval;
	
	reg WR_Reset, start_timer;
    reg[6:0] LEDs;
    reg[1:0] interval = 2'b00;
	reg[2:0] state = 3'd0;
	
	parameter START_MAIN_GREEN = 0;
	parameter CONT_MAIN_GREEN_NO_TRAFFIC = 1;
	parameter CONT_MAIN_GREEN_TRAFFIC = 2;
	parameter MAIN_YELLOW = 3;
	parameter PEDESTRIAN_WALK = 4;
	parameter START_SIDE_GREEN = 5;
	parameter CONT_SIDE_GREEN_TRAFFIC = 6;
	parameter SIDE_YELLOW = 7;

	parameter BASE_ADD = 2'b00 ;
	parameter EXT_ADD = 2'b01 ;
	parameter YEL_ADD = 2'b10 ;
	
	always @ ( posedge clk,Reset_Sync,negedge clk )
	begin
	
		start_timer = 0;					
		WR_Reset = 0;

      if ( Reset_Sync || Prog_Sync)
			begin
			start_timer = 1;
			interval <= BASE_ADD ;
			state <= START_MAIN_GREEN ;
			end
			
		else if (~ expired )
			begin
			case ( state )
				START_MAIN_GREEN, CONT_MAIN_GREEN_NO_TRAFFIC, CONT_MAIN_GREEN_TRAFFIC :
					LEDs <= 7'b0011000;	// bits represent Rm,Ym,Gm,Rs,Ys,Gs,Walk from left to right of the bits 
            
				MAIN_YELLOW :
					LEDs <= 7'b0101000;	

				PEDESTRIAN_WALK :
					LEDs <= 7'b1001001;	 

				START_SIDE_GREEN, CONT_SIDE_GREEN_TRAFFIC :
					LEDs <= 7'b1000010;	

				SIDE_YELLOW :
					LEDs <= 7'b1000100;	
			endcase
			end
		
		else
			begin
			
			start_timer = 1;

			case ( state )
				START_MAIN_GREEN :
					begin
                      if ( Sensor_Sync )
							begin
								
								interval <= EXT_ADD ;
								state <= CONT_MAIN_GREEN_TRAFFIC ;
							end
						else
							begin
								interval <= BASE_ADD ;
								state <= CONT_MAIN_GREEN_NO_TRAFFIC ;
							end
					end

				CONT_MAIN_GREEN_NO_TRAFFIC,CONT_MAIN_GREEN_TRAFFIC :
					begin
						interval <= YEL_ADD ;
						state <= MAIN_YELLOW ;
					end

				MAIN_YELLOW :
					begin
						
                      if ( WR_Status )
							begin
								
								interval <= EXT_ADD ;
								state <= PEDESTRIAN_WALK ;
							end
						else
							begin
								interval <= BASE_ADD ;
								state <= START_SIDE_GREEN ;
							end
					end

				PEDESTRIAN_WALK :
					begin
				
						interval <= BASE_ADD ;
						state <= START_SIDE_GREEN ;
						WR_Reset = 1;
					end

				START_SIDE_GREEN :
					begin
                      if ( Sensor_Sync )
							begin
								interval <= EXT_ADD ;
								state <= CONT_SIDE_GREEN_TRAFFIC ;
							end
						else
							begin
								interval <= YEL_ADD ;
								state  <= SIDE_YELLOW ;

							end
					end

				CONT_SIDE_GREEN_TRAFFIC :
					begin
						interval <= YEL_ADD ;
						state <= SIDE_YELLOW ;
					end

				SIDE_YELLOW :
					begin
						interval <= BASE_ADD ;
						state <= START_MAIN_GREEN ;
					end

			endcase
			end
			
	end
	
endmodule


////////////////////////////////////////////////////////
///////////////// LED_lights ///////////////////////////
////////////////////////////////////////////////////////

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

module Divider(clk, Hz1_enable);
  
  input clk;
  output reg Hz1_enable = 0;
  reg [9:0] counter = 10'b0;

  always @ (negedge clk, posedge clk)
  begin
      if (counter != 10'b1111101000) begin
          counter = counter + 1;
      end

      else begin
          Hz1_enable =~ Hz1_enable;
          counter = 1;
      end
  end
endmodule

////////////////////////////////////////////////////////////////
///////////////  synchronizer  /////////////////////////////////
////////////////////////////////////////////////////////////////

module synchronizer(clk, Reprogram, Walk_Request, Sensor, Reset, Reset_Sync, Sensor_Sync, WR_Sync, Prog_Sync);
  
  input clk, Reprogram, Walk_Request, Sensor, Reset;
  output reg  Reset_Sync, Sensor_Sync, WR_Sync;
  output reg [3:0] Prog_Sync;
  
  always @(posedge clk)
    
    begin
      
      Reset_Sync = Reset;
      Sensor_Sync = Sensor;
      WR_Sync = Walk_Request;
      Prog_Sync = Reprogram;
      
    end
  
endmodule


////////////////////////////////////////////////////////////////////
//////////////   TimeParameters   //////////////////////////////////
////////////////////////////////////////////////////////////////////


module TimeParameters(selector, interval, Prog_Sync,time_value, value, clk, Reset_Sync);
	 
  
    input clk, Reset_Sync;
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
      if(Reset_Sync)
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


//////////////////////////////////////////////////////////////////////////
////////////////   timer    //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

module timer (Hz1_enable, value, start_timer, Reset_Sync, expired);
  
  input[3:0] value;
  input Hz1_enable, start_timer, Reset_Sync;  
  output expired;
  reg expired;
  
  reg start_flag = 0;
  reg [3:0] counter = 4'b0000;

  
 
  always @(posedge Hz1_enable, Reset_Sync, negedge Hz1_enable)
    begin 
     if (Reset_Sync == 1)
      begin
       expired = 0;
       counter = 4'b0000;
       start_flag = 0;
     end
     else if (counter == value - 1) begin
         expired = 1;
         counter = 4'b0000;
         start_flag = 0;
     end
     else if (start_timer == 1 && start_flag == 0) begin
         start_flag = 1;
         expired = 0;
     end 
     else if (start_flag == 1) begin
         counter = counter + 4'b0001;
         expired = 0;
     end
     else begin
         expired = 0;
     end
    end
endmodule

////////////////////////////////////////////////////////////////
////////////////// Walk_Register   /////////////////////////////
////////////////////////////////////////////////////////////////

module Walk_Register(clk, WR_Reset, WR_Sync, WR_Status);
  
  input clk, WR_Reset, WR_Sync;
  output reg WR_Status;
  reg walk_reg;
  
  always @ (posedge clk, WR_Sync)
  begin
      if (WR_Sync == 1) begin
          walk_reg = 1;
          WR_Status = walk_reg;
      end
      else if (WR_Reset == 1) begin
          walk_reg = 0;
          WR_Status = walk_reg;
      end
  end
endmodule
    
   