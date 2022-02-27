`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:52:01 01/04/2022
// Design Name:   register_file
// Module Name:   C:/Users/demie/Desktop/HW1/Part1/register_file_tb.v
// Project Name:  Part1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register_file
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module register_file_tb;

	// Inputs
	reg [4:0] Ard1;
	reg [4:0] Ard2;
	reg [4:0] Awr;
	reg [31:0] Din;
	reg WrEn;
	reg clk;

	// Outputs
	wire [31:0] Dout1;
	wire [31:0] Dout2;

	// Instantiate the Unit Under Test (UUT)
	register_file uut (
		.Ard1(Ard1), 
		.Ard2(Ard2), 
		.Awr(Awr), 
		.Din(Din), 
		.WrEn(WrEn), 
		.clk(clk), 
		.Dout1(Dout1), 
		.Dout2(Dout2)
	);

	initial begin
		clk = 1'b0;
		
		//Initialize data
		Ard1 = 5'd0;
		Ard2 = 5'd0;
		Awr = 5'd0;
		Din = 32'd0;
		WrEn = 0;
		
	end
	
	always begin
		#100 clk = ~clk;
	end
	
		initial begin
		//Write data to Ard1 and read it
		Ard1 = 5'b00001;
		Ard2 = 5'b10110;
		Awr = 5'b00001;
		Din = 32'b10111111001110111011000100010110;
		WrEn = 1;
      #200;

		
		//Write data to Ard2 and read it
		Ard1 = 5'b00001;
		Ard2 = 5'b10110;
		Awr = 5'b10110;
		Din = 32'b00111111001110111011000100010110;
		WrEn = 1;
      #200;
		
		
		//Read previous Ard1 & Ard2 data without writing
		Ard1 = 5'b00001;
		Ard2 = 5'b10110;
		Awr = 5'b00001;
		Din = 32'b00010110110101110101110010100100;
		WrEn = 0;
      #200;
		
		
		//Write data to Ard1 and read Ard1 and Ard2
		Ard1 = 5'b00100;
		Ard2 = 5'b10110;
		Awr = 5'b00100;
		Din = 32'b11111110110101110101110010100100;
		WrEn = 1;
      #200;
		
		
		//Write data to Ard2 and read Ard1 and Ard2
		Ard1 = 5'b00001;
		Ard2 = 5'b10010;
		Awr = 5'b10010;
		Din = 32'b00111110110101110101110010100100;
		WrEn = 1;
      #200;
	end

      
endmodule

