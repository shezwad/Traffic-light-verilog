//////////////////////////////////////////////////////////////////////////////////
//////////////             E/15/335 - Readme                     /////////////////
//////////////     EE587 : Digital System Design and Synthesis   /////////////////
//////////////                 Assignment                        /////////////////
//////////////////////////////////////////////////////////////////////////////////


The final design is in the 'Full design' folder. When combining the previous submission 
together to form the fulldesign some adjustement had to be made in order to make the 
system work correctly. Final modules are in the fulldesign.v and previous models which
appeared to do some corrections are in the 'Previous submissions' folder.

Waveforms for each modules are present within each moduled named folder. 

When creating the 1 Hz clock (Hz1_enable) which found difficult to get some accurate 
clockings when using 1ns clk (`timescale 1ns/1ps). So to achieve the 1 hz this design have
implemented by taking the general clock as 1ms clk. It seems to be working well after 
changing the simulation timescale. 

There is a new module 'LED_light' which has not been submitted previously. It was implemented 
where in the FSM module which I previously submitted, I have output the LED as a 
[6:0] register. I used 1 bit output to observe the behavior lights (Rm,Ym,Gm,Rs,Ys,Gs,Walk) 
without any diffulty.     