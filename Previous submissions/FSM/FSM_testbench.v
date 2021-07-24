`timescale 1ns / 1ps

`include "FSM.v"

module FSM_testbench;

	
	reg Sensor_Sync;
	reg WR;
	reg Prog_Sync;
	reg expired;
	reg clk;
	reg Reset;

	wire WR_Reset;
	wire [1:0] interval;
	wire start_timer;
    wire [6:0] LEDs;

	
	FSM t1(Sensor_Sync, WR, Prog_Sync, expired, WR_Reset, interval, start_timer, LEDs, clk, Reset);
		

	initial begin
		forever #10 clk = ~clk;
	end

	initial begin
		
      
      $dumpfile("FSM_testbench.vcd");
      $dumpvars(0,FSM_testbench);
    
		Sensor_Sync = 0;
		WR = 0;
		Prog_Sync = 0;
		expired = 0;
		clk = 0;
		Reset = 0;

		#90;
        
		
	    Reset = 1;
		WR = 1;
		
		#20
		Reset = 0;
		
		#120
		expired = 1;
		
		#20
		expired = 0;
		
		#120
		expired = 1;
		
		#20
		expired = 0;
		
		#40
		expired = 1;
		
		#20
		expired = 0;
		
		#60
		expired = 1;
		
		#20
		expired = 0;
		
		#40
		expired = 1;
		
		#20
		expired = 0;
		
		#20
		Sensor_Sync = 1;

		#100
		expired = 1;
		
		#20
		expired = 0;
		
		#60
		expired = 1;
		
		#20
		expired = 0;
		
		#120
		expired = 1;
		
		#20
		expired = 0;
       #20 $finish();
		
	end
      
endmodule