`timescale 1ns / 1ps
`include "TimeParameters.v"



module TimeParameters_testbench;


    reg [1:0] selector;
    reg [3:0] Prog_Sync;
	reg [1:0] interval;
	reg [3:0] time_value;
	reg clk;
	reg Reset;
    
    wire [3:0] value;

	
	TimeParameters t1 (selector, interval, Prog_Sync,time_value, value, clk, Reset);

	initial begin
		forever 
			#10 clk = ~clk;
	end

	initial begin
      
    $dumpfile("TimeParameters.vcd");
    $dumpvars(0,TimeParameters_testbench);
		
		selector = 0;
		interval = 0;
		Prog_Sync = 0;
		clk = 0;
		Reset = 0;

		#100;
        
		Reset = 1;
		interval = 2'b00;
		
		#60
		Reset = 0;
		
		#60
		interval = 2'b01;
		
		#60
		interval = 2'b10;
		
		#60
		selector = 2'b01;
		Prog_Sync = 4'b1010;
		
		
		#60
		interval = 2'b01;
		
		#60
		Reset = 1;
		interval = 2'b00;
		
		#60
		Reset = 0;
		
		#60
		interval = 2'b01;
		
		#20 $finish();
		
	end
      
endmodule
