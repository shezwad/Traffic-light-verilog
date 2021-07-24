//////////////////////////////////////////////////////////////////////////////////
//////////////         E/15/335 - fulldesign_testbench                 ///////////
//////////////     EE587 : Digital System Design and Synthesis   /////////////////
//////////////                  Assignment                        ////////////////
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ms/1ms
`include "fulldesign.v"

module fulldesign_testbench;

reg clk,Reset,Sensor,Walk_Request,Reprogram;
reg [1:0] selector;
reg [3:0] time_value;
input[3:0] Prog_Sync;
input[1:0] interval;

wire [3:0] value;
wire [6:0] LEDs;
wire Hz1_enable,Reset_Sync, WR_Sync, Prog_Sync, Sensor_Sync,expired,WR_Status;
wire Rm,Ym,Gm,Rs,Ys,Gs,Walk, WR_Reset, start_timer;

Divider shezdiv (clk, Hz1_enable);

synchronizer shezsynch (clk, Reprogram, Walk_Request, Sensor, Reset, Reset_Sync, Sensor_Sync, WR_Sync, Prog_Sync);

Walk_Register shezWR (clk, WR_Reset, WR_Sync, WR_Status);

TimeParameters shezTM (selector, interval, Prog_Sync,time_value, value, clk, Reset_Sync);

timer sheztim (Hz1_enable, value, start_timer, Reset_Sync, expired);

LED_lights shezLED  (LEDs, Rm,Ym,Gm,Rs,Ys,Gs,Walk);

FSM shezFSM (Sensor_Sync, WR_Status, Prog_Sync, expired, WR_Reset, interval, start_timer, LEDs, clk, Reset_Sync);

initial begin
    $dumpfile("fulldesign.vcd");
    $dumpvars(0,fulldesign_testbench);

    clk = 0;
    Reset = 0;
    Sensor = 0;
    Reprogram = 0;

    #3000 

    Walk_Request = 1;
    #5 

    Walk_Request = 0;
    #1300 

    Sensor = 1;
    #15000 

    Walk_Request = 1;
    #5 
    
    Walk_Request = 0;
    #22000 

    Sensor = 0;
    #10000

    Walk_Request = 1;
    #5

    Walk_Request = 0;
    #20000

    Sensor = 1;
    #20

    #30000 $finish();
end

initial forever 
#0.5 clk =~ clk;
    
endmodule