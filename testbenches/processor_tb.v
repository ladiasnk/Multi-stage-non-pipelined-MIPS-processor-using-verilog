`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:40:18 01/17/2022
// Design Name:   PROCESSOR
// Module Name:   /home/ise/fpga-user/Documents/processor/processor_tb.v
// Project Name:  processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PROCESSOR
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module processor_tb;

	// Inputs
	reg Clk;
	reg Reset;

	// Outputs
	wire Zero;
	wire PC_LdEn;
	wire [31:0] Instr;
	wire RF_WrData_sel;
	wire RF_B_sel;
	wire RF_WrEn;
	wire ALU_Bin_sel;
	wire [3:0] ALU_func;
	wire MEM_WrEn;

	// Instantiate the Unit Under Test (UUT)
	PROCESSOR uut (
	   .PC_sel(PC_sel),
		.Clk(Clk), 
		.Reset(Reset), 
		.Zero(Zero), 
		.PC_LdEn(PC_LdEn), 
		.Instr(Instr), 
		.RF_WrData_sel(RF_WrData_sel), 
		.RF_B_sel(RF_B_sel), 
		.RF_WrEn(RF_WrEn), 
		.ALU_Bin_sel(ALU_Bin_sel), 
		.ALU_func(ALU_func), 
		.MEM_WrEn(MEM_WrEn)
	);
 always begin
		#5 Clk=~Clk;
		end
	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 1;

		// Wait 100 ns for global reset to finish
		#10;
        Reset=0;
	end
     
endmodule

