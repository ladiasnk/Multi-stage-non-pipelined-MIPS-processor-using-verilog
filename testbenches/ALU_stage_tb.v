`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:55:15 01/17/2022
// Design Name:   ALU_main
// Module Name:   /home/ise/fpga-user/Documents/ALUstage/ALU_stage_tb.v
// Project Name:  ALUstage
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU_main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_stage_tb;

	// Inputs
	reg [31:0] RF_A;
	reg [31:0] RF_B;
	reg [31:0] Immed;
	reg ALU_Bin_sel;
	reg [3:0] ALU_func;

	// Outputs
	wire [31:0] ALU_out;

	// Instantiate the Unit Under Test (UUT)
	ALU_main uut (
		.RF_A(RF_A), 
		.RF_B(RF_B), 
		.Immed(Immed), 
		.ALU_Bin_sel(ALU_Bin_sel), 
		.ALU_func(ALU_func), 
		.ALU_out(ALU_out)
	);

	initial begin
		// Initialize Inputs
		RF_A = 0;
		RF_B = 0;
		Immed = 0;
		ALU_Bin_sel = 0;
		ALU_func = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
      RF_A=32'b10001000010011100010101101011001;
		RF_B=32'b01110011100111010010110001000000;
		Immed = 16'b1101110110001111; 
		ALU_Bin_sel = 0; //choose RF_B
		ALU_func=4'b0010;// or operation
		#200;

      RF_A=32'b11101000010011001110111101100001;
		RF_B=32'b01110011100111010010110001000000;
		Immed = 16'b1101110110001111; 
		ALU_Bin_sel = 1; // now choose Immed
		ALU_func=4'b0000;// perform addi operation (Note:Immed needs extension)
		#200;
	end

endmodule

