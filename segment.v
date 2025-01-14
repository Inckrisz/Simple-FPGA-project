`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:03 12/01/2024 
// Design Name: 
// Module Name:    segment 
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
module segment(
input clk,
input clr,
output reg [6:0] seg,
output [4:0] an
    );

assign an = 4'b0000;
reg [19:0] refresh_counter;
reg [4:0] disp_number;
wire one_second_enable;
reg [26:0] one_second_counter;

 always @(posedge clk or posedge clr)
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

always@(posedge clk or posedge clr)
	begin
		if(clr == 1)
			disp_number <= 0;
		else if(one_second_enable==1)
			disp_number <= disp_number + 1;
		else if (disp_number == 10)
			disp_number <= 0;
	end
	
always @(posedge clk or posedge clr)
    begin 
        if(clr == 1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign activating_counter = refresh_counter[19];

always @(*)
begin
if (activating_counter == 1)

    begin
        case(disp_number)
        4'b0000: seg = 7'b0000001; // "0"     
        4'b0001: seg = 7'b1001111; // "1" 
        4'b0010: seg = 7'b0010010; // "2" 
        4'b0011: seg = 7'b0000110; // "3" 
        4'b0100: seg = 7'b1001100; // "4" 
        4'b0101: seg = 7'b0100100; // "5" 
        4'b0110: seg = 7'b0100000; // "6" 
        4'b0111: seg = 7'b0001111; // "7" 
        4'b1000: seg = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0000100; // "9" 
        default: seg = 7'b0000001; // "0"
        endcase
    end
end

endmodule
