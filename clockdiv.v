`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:16:18 09/02/2017 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 100MHz
	//input wire clr,		//asynchronous reset
	output reg dclk	//pixel clock: 25MHz
	//output wire segclk	//7-segment clock: 381.47Hz
	);

// 17-bit counter variable
 reg [16:0] q;

// 2-bit counter variable
   //reg [1:0] q;

// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
   reg d50clk;

always @(posedge clk) //or posedge clr)
//begin
//if (clr == 0)
	begin
	// reset condition
	//if (clr == 1)
		//q <= 0;
	// increment counter by one
	//else
	//	q <= q + 1;
		if (d50clk == 1)
			d50clk <= 0;
		else
			d50clk <= 1;
	end		
//else	
//	   d50clk <= 0;
//end

always @(posedge d50clk)// or posedge clr)
begin
//if (clr == 0)
	//begin
	// reset condition
	//if (clr == 1)
		//q <= 0;
	// increment counter by one
	//else
	//	q <= q + 1;
		if (dclk == 1)
			dclk <= 0;
		else
			dclk <= 1;
   //end
   		
//else	
	  // dclk <= 0;
end

//100Mhz / 2^18 = 381.47Hz

// assign segclk = q[17];

//100Mhz / 2^2 = 25MHz

//assign dclk = q[1];

endmodule
