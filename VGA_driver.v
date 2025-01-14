`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:13:36 09/02/2017 
// Design Name: 
// Module Name:    VGA_driver 
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
	module VGA_driver(
	input wire clk,			//master clock = 100MHz
	input wire clr,			//right-most pushbutton for reset
	input [7:0] sw,
	input wire btnr,
	input wire btng,
	input wire btnb,
	output [6:0] seg,
	output [4:0] an,
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,   //green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync, 	//vertical sync out
	output [3:0] led
	);



// VGA display clock interconnect
 wire dclk;


// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	//.clr(clr),
	// .segclk(segclk)
	.dclk(dclk)
	);



// VGA controller
VGA U3(
	.dclk(dclk),
	.clr(clr),
	.btnr(btnr),
	.btng(btng),
	.btnb(btnb),
	.sw(sw),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);

led_count U4 (
	.clk(clk),
	.clr(clr),
	.led(led)
);

segment U5 (
	.clk(clk),
	.clr(clr),
	.seg(seg),
	.an(an)
);

endmodule

