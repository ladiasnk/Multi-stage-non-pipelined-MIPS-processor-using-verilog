`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:32:41 01/17/2022
// Design Name:   MEM_main
// Module Name:   /home/ise/fpga-user/Documents/MEMstage/MEMstage_tb.v
// Project Name:  MEMstage
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MEM_main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MEMstage_tb;

	// Inputs
	reg clk;
	reg Mem_WrEn;
	reg [31:0] ALU_MEM_Addr;
	reg [31:0] MEM_DataIn;

	// Outputs
	wire [31:0] MEM_DataOut;

	// Instantiate the Unit Under Test (UUT)
	MEM_main uut (
		.clk(clk), 
		.Mem_WrEn(Mem_WrEn), 
		.ALU_MEM_Addr(ALU_MEM_Addr), 
		.MEM_DataIn(MEM_DataIn), 
		.MEM_DataOut(MEM_DataOut)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		Mem_WrEn = 0;
		ALU_MEM_Addr = 0;
		MEM_DataIn = 0;

		// Wait 100 ns for global reset to finish
		#100;

	end
  always begin
		#10 clk = ~clk;
	end
	initial begin
		Mem_WrEn = 1;
		ALU_MEM_Addr = 10'b0000000101;
		MEM_DataIn = 32'b00100111110101101110000101110101;
		// Add stimulus her
		#20;
		Mem_WrEn = 0;
		ALU_MEM_Addr = 10'b0000000101;
		MEM_DataIn = 32'b00100111110101101110000101110101;
		#20;
		Mem_WrEn = 1;
		ALU_MEM_Addr = 10'b0000010101;
		MEM_DataIn = 32'b11100000000101101110000101110101;
		#20;
		Mem_WrEn = 0;
		ALU_MEM_Addr = 10'b0000010101;
		MEM_DataIn = 32'b11100000000101101110000101110101;
		#20;
		end
endmodule

