`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:53:54 01/17/2022
// Design Name:   command_unit
// Module Name:   /home/ise/fpga-user/Documents/IFstage/IFSTAGE_tb.v
// Project Name:  IFstage
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: command_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IFSTAGE_tb;

	// Inputs
	reg [31:0] PC_Immed;
	reg PC_sel;
	reg PC_LdEn;
	reg Reset;
	reg Clk;

	// Outputs
	wire [31:0] Instr;

	// Instantiate the Unit Under Test (UUT)
	command_unit uut (
		.PC_Immed(PC_Immed), 
		.PC_sel(PC_sel), 
		.PC_LdEn(PC_LdEn), 
		.Reset(Reset), 
		.Clk(Clk), 
		.Instr(Instr)
	);
	initial begin
	   PC_Immed = 0;
		PC_sel = 0;
		PC_LdEn = 0;
		Reset=0;
		Clk=0;
	end
		// Wait 100 ns for global reset to finish
   always begin
	#100 Clk=~Clk;
	end
	initial begin
		// Initialize Inputs
		PC_Immed = 0;
		PC_sel = 0;
		PC_LdEn = 0;
		Reset = 1;
      //wait 100
		#200;
      PC_Immed = 32'b100;
		PC_sel = 1;
		PC_LdEn = 1;
		Reset = 0; 
		#200;
		//PC_Immed = 32'b10101001011011010001111010011011;
		PC_sel = 0;
		PC_LdEn = 1;
		Reset = 0; 
		#200;
		//PC_Immed = 32'b10101001011011010001111010011011;
		PC_sel = 0;
		PC_LdEn = 1;
		Reset = 0; 
		#200;
		// Add stimulus here

	end
      
endmodule

