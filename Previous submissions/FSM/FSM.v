`timescale 1ns / 1ps

module FSM(Sensor_Sync, WR, Prog_Sync, expired, WR_Reset, interval, start_timer, LEDs, clk, Reset);
	
    input Sensor_Sync, WR, Prog_Sync, expired, clk, Reset;
	output WR_Reset, start_timer;
    output[6:0] LEDs;
	output[1:0] interval;
	
	reg WR_Reset, start_timer;
    reg[6:0] LEDs = 7'b0011000;
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
	
	always @ ( posedge clk )
	begin
	
		start_timer = 0;					
		WR_Reset = 0;

      if ( Reset || Prog_Sync)
			begin
			start_timer = 1;
			interval = BASE_ADD ;
			state = START_MAIN_GREEN ;
			end
			
		else if (~ expired )
			begin
			case ( state )
				START_MAIN_GREEN, CONT_MAIN_GREEN_NO_TRAFFIC, CONT_MAIN_GREEN_TRAFFIC :
					LEDs = 7'b0011000;	// bits represent Rm,Ym,Gm,Rs,Ys,Gs,Walk from left to right of the bits 
            
				MAIN_YELLOW :
					LEDs = 7'b0101000;	

				PEDESTRIAN_WALK :
					LEDs = 7'b1001001;	 

				START_SIDE_GREEN, CONT_SIDE_GREEN_TRAFFIC :
					LEDs = 7'b1000010;	

				SIDE_YELLOW :
					LEDs = 7'b1000100;	
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
								
								interval = EXT_ADD ;
								state = CONT_MAIN_GREEN_TRAFFIC ;
							end
						else
							begin
								interval = BASE_ADD ;
								state = CONT_MAIN_GREEN_NO_TRAFFIC ;
							end
					end

				CONT_MAIN_GREEN_NO_TRAFFIC,CONT_MAIN_GREEN_TRAFFIC :
					begin
						interval= YEL_ADD ;
						state = MAIN_YELLOW ;
					end

				MAIN_YELLOW :
					begin
						
                      if ( WR )
							begin
								
								interval= EXT_ADD ;
								state = PEDESTRIAN_WALK ;
							end
						else
							begin
								interval = BASE_ADD ;
								state = START_SIDE_GREEN ;
							end
					end

				PEDESTRIAN_WALK :
					begin
				
						interval= BASE_ADD ;
						state = START_SIDE_GREEN ;
						WR_Reset = 1;
					end

				START_SIDE_GREEN :
					begin
                      if ( Sensor_Sync )
							begin
								interval = EXT_ADD ;
								state = CONT_SIDE_GREEN_TRAFFIC ;
							end
						else
							begin
								interval = YEL_ADD ;
								state  = SIDE_YELLOW ;

							end
					end

				CONT_SIDE_GREEN_TRAFFIC :
					begin
						interval = YEL_ADD ;
						state = SIDE_YELLOW ;
					end

				SIDE_YELLOW :
					begin
						interval = BASE_ADD ;
						state = START_MAIN_GREEN ;
					end

			endcase
			end
			
	end
	
endmodule