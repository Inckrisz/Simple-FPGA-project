`timescale 1ns / 1ps
module VGA(
    input wire dclk,       // pixel clock: 25MHz
    input wire clr,        // asynchronous reset
	 input wire btnr,
	 input wire btng,
	 input wire btnb,
	 input [7:0] sw,
    output wire hsync,     // horizontal sync out
    output wire vsync,     // vertical sync out
    output reg [2:0] red,  // red VGA output
    output reg [2:0] green,// green VGA output
    output reg [1:0] blue  // blue VGA output
    );

    // Video structure constants
    parameter hpixels = 800; // horizontal pixels per line
    parameter vlines = 521;  // vertical lines per frame
    parameter hpulse = 96;   // hsync pulse length
    parameter vpulse = 2;    // vsync pulse length
    parameter hbp = 144;     // end of horizontal back porch
    parameter hfp = 784;     // beginning of horizontal front porch
    parameter vbp = 31;      // end of vertical back porch
    parameter vfp = 511;     // beginning of vertical front porch
    // active horizontal video is therefore: 784 - 144 = 640
    // active vertical video is therefore: 511 - 31 = 480

    // Registers for storing the horizontal & vertical counters
    reg [9:0] hc;
    reg [9:0] vc;
	 reg [26:0] cnt;
	 reg [2:0] red_R;
	 reg [2:0] green_R;
	 reg [1:0] blue_R;
	 
	 always@ (posedge btnr or posedge btng or posedge btnb)
	 begin
		if (btnr == 1)
			red_R <= sw[2:0];
		else if (btng == 1)
			green_R <= sw[5:3];
		else if ( btnb == 1)
			blue_R <= sw[7:6];
			
		else 
		begin
			red_R <= 3'b111;
			green_R <= 3'b000;
			blue_R <= 2'b00;
		end
			
	 end

    // State control variables
    reg [3:0] current_digit;    // Digit to display: 0=1, 1=2, 2=3
       // Frame-based timer to switch digits
    parameter DIGIT_DURATION = 25000000; // Number of frames per digit (adjust as needed)

    // Horizontal & vertical counters
    always @(posedge dclk or posedge clr) begin
        if (clr == 1) begin
            hc <= 0;
            vc <= 0;
        end 
		  else 
		  begin
            if (hc < hpixels - 1)
                hc <= hc + 1;
            else 
				begin
                hc <= 0;
                if (vc < vlines - 1)
                    vc <= vc + 1;
                else
                    vc <= 0;
            end
        end
    end

    // Frame counter and digit selector
    always @(posedge dclk or posedge clr) begin
        if (clr == 1) begin
            cnt <= 0;
            current_digit <= 0;
        end 
		  else if (cnt < DIGIT_DURATION - 1)
                cnt <= cnt + 1;
        else 
				begin
                cnt <= 0;
                current_digit <= current_digit + 1;
                if (current_digit == 9)
                    current_digit <= 0; // Loop back to 1
					end
					
            
           
        end
    

    // Generate sync pulses (active low)
    assign hsync = (hc < hpulse) ? 0 : 1;
    assign vsync = (vc < vpulse) ? 0 : 1;

    // Intermediate coordinates for active region
    reg [9:0] x, y;

    // Display digits (1, 2, 3) based on the current state
    always @(*) begin
        // Default to black background
        red <= 3'b000;
        green <= 3'b000;
        blue <= 2'b00;

        // Calculate active region coordinates
        if (hc >= hbp && hc < hfp)
            x = hc - hbp; // Horizontal coordinate (0-639)
        else
            x = 0;

        if (vc >= vbp && vc < vfp)
            y = vc - vbp; // Vertical coordinate (0-479)
        else
            y = 0;

        // Draw digits based on the current state
        if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp) begin
            case (current_digit)
                0: 
					 begin
					 if ((x >= 280 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
						 (x >= 340 && x <= 360 && y >= 100 && y <= 400) ||  // right vertical
						 (x >= 280 && x <= 300 && y >= 100 && y <= 400) ||  // Left vertical line
						 (x >= 280 && x <= 360 && y >= 380 && y <= 400)) begin // bottom horizontal
						red <= red_R;
						green <= green_R;
						blue <= blue_R;
					end 
					
					 
                end
                1: 
					 begin
                    // Display "1"
						  if   // Vertical line for "1"
							  (x >= 330 && x <= 350 && y >= 120 && y <= 400) begin // Base of "1" y 100 400
								red <= red_R;
						green <= green_R;
						blue <= blue_R;
							end 
							
							
					end
                2: 
					 begin
                    // Display "2"
                    if ((x >= 280 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
                        (x >= 340 && x <= 360 && y >= 100 && y <= 240) ||  // Right vertical line
                        (x >= 280 && x <= 360 && y >= 240 && y <= 260) ||  // Middle horizontal line
                        (x >= 280 && x <= 300 && y >= 260 && y <= 380) ||  // Left vertical line
                        (x >= 280 && x <= 360 && y >= 380 && y <= 400)) begin // Bottom horizontal line
                        red <= red_R;
						green <= green_R;
						blue <= blue_R;
                    end
                end
					 3:
					 begin
						if ((x >= 280 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
                        (x >= 340 && x <= 360 && y >= 100 && y <= 240) ||  // Right vertical line (top)
                        (x >= 280 && x <= 360 && y >= 240 && y <= 260) ||  // Middle horizontal line
                        (x >= 340 && x <= 360 && y >= 260 && y <= 380) ||  // Right vertical line (bottom)
                        (x >= 280 && x <= 360 && y >= 380 && y <= 400)) begin // Bottom horizontal line
                        red <= red_R;
						green <= green_R;
						blue <= blue_R;
                    end
					 end
					 4:
					 begin
						if ((x >= 280 && x <= 310 && y >= 100 && y <= 200) ||  // Left vertical line
            (x >= 280 && x <= 360 && y >= 200 && y <= 250) ||  // Middle horizontal
            (x >= 320 && x <= 350 && y >= 180 && y <= 400)) begin // Middle vertical line
            red <= red_R;
						green <= green_R;
						blue <= blue_R;
        end 
        
					 end
					 5:
					 begin
					 if ((x >= 320 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
            (x >= 320 && x <= 340 && y >= 100 && y <= 240) ||  // Left vertical line
            (x >= 320 && x <= 360 && y >= 220 && y <= 240) ||  // Middle horizontal line
            (x >= 340 && x <= 360 && y >= 240 && y <= 380) ||  // Right vertical line
            (x >= 320 && x <= 360 && y >= 380 && y <= 400)) begin // Bottom horizontal line
            red <= red_R;
						green <= green_R;
						blue <= blue_R;
        end 
					 
					 end
					 6:
					 begin
					 if ((x >= 320 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
            (x >= 320 && x <= 340 && y >= 100 && y <= 380) ||  // Left vertical line
            (x >= 320 && x <= 360 && y >= 220 && y <= 240) ||  // Middle horizontal line
            (x >= 340 && x <= 360 && y >= 240 && y <= 380) ||  // Right vertical line
            (x >= 320 && x <= 360 && y >= 380 && y <= 400)) begin // Bottom horizontal line
            red <= red_R;
						green <= green_R;
						blue <= blue_R;
        end 
					 end
					 7:
					 begin
					 if ((x >= 320 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
            (x >= 340 && x <= 360 && y >= 120 && y <= 400)) begin // Right vertical line
            red <= red_R;
						green <= green_R;
						blue <= blue_R;
        end 
					 end
					 8:
					 begin
					 if ((x >= 320 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
            (x >= 320 && x <= 330 && y >= 100 && y <= 400) ||  // Left vertical line
            (x >= 350 && x <= 360 && y >= 100 && y <= 400) ||  // Right vertical line
            (x >= 320 && x <= 360 && y >= 230 && y <= 240) ||  // Middle horizontal line
            (x >= 320 && x <= 360 && y >= 380 && y <= 400)) begin // Bottom horizontal line
            red <= red_R;
						green <= green_R;
						blue <= blue_R;
        end 
					 
					 end
					 9:
					 begin
					  if ((x >= 320 && x <= 360 && y >= 100 && y <= 120) ||  // Top horizontal line
            (x >= 320 && x <= 340 && y >= 100 && y <= 240) ||  // Left vertical line
            (x >= 320 && x <= 360 && y >= 220 && y <= 240) ||  // Middle horizontal line
            (x >= 340 && x <= 360 && y >= 100 && y <= 380) ||  // Right vertical line
            (x >= 320 && x <= 360 && y >= 380 && y <= 400)) begin // Bottom horizontal line
            red <= red_R;
						green <= green_R;
						blue <= blue_R;
        end 
					 
					 end
					 
		default:
    begin
        // Default to black background
        red <= 3'b000;
        green <= 3'b000;
        blue <= 2'b00;
    end
					 
            endcase
        end
    end

endmodule
