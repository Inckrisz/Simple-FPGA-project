`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:09 12/01/2024 
// Design Name: 
// Module Name:    led_count 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module led_count(
input clk,
input clr,
output reg [3:0] led
    );
	 
reg [26:0] one_second_counter;	
	
always @(posedge clk or posedge clk)
    begin
        if(clr==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 

assign one_second_enable = (one_second_counter==99999999)?1:0;
    always @(posedge clk or posedge clr)
    begin
        if(clr==1)
            led <= 0;
        else if(one_second_enable==1)
            led <= led + 1;
			else if (led == 10)
				led <= 0;
    end

endmodule
