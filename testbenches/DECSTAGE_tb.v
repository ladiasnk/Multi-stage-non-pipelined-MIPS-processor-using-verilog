`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:13:31 01/11/2022
// Design Name:   decode_unit
// Module Name:   C:/Users/demie/Desktop/HW1/Part2/DECSTAGE_tb.v
// Project Name:  Part2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decode_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DECSTAGE_tb;

	// Inputs
	reg [31:0] Instr;
	reg RF_WrEn;
	reg [31:0] ALU_out;
	reg [31:0] MEM_out;
	reg RF_WrData_sel;
	reg RF_B_sel;
	reg Clk;

	// Outputs
	wire [31:0] Immed;
	wire [31:0] RF_A;
	wire [31:0] RF_B;

	// Instantiate the Unit Under Test (UUT)
	decode_unit uut (
		.Instr(Instr), 
		.RF_WrEn(RF_WrEn), 
		.ALU_out(ALU_out), 
		.MEM_out(MEM_out), 
		.RF_WrData_sel(RF_WrData_sel), 
		.RF_B_sel(RF_B_sel), 
		.Clk(Clk), 
		.Immed(Immed), 
		.RF_A(RF_A), 
		.RF_B(RF_B)
	);

	initial begin
		// Initialize Inputs
		Clk = 1'b0;
		
		Instr = 32'b0;
		RF_WrEn = 0;
		ALU_out = 32'b0;
		MEM_out = 32'b0;
		RF_WrData_sel = 0;
		RF_B_sel = 0;
	end
      
	always begin
		#100 Clk = ~Clk;
	end
		
	initial begin
		//li Instruction --> Sign extended Immediate, write in register 01000
		//Data to write=MEM_out
		Instr = 32'b111000_10001_01000_1101110110001111; 
		RF_WrEn = 1;
		ALU_out = 32'b10001000010011100010101101011001;
		MEM_out = 32'b01110011100111010010110001000000;
		RF_WrData_sel = 1;
		RF_B_sel = 1;
		#200;

      //ori Instruction --> Zero fill Immediate, read from register 01000
		//write in register 11010, Data to write=ALU_out
		Instr = 32'b110011_01000_11010_0101110110001111; 
		RF_WrEn = 1;
		ALU_out = 32'b10001000010011100010101101011001;
		MEM_out = 32'b01110011100111010010110001000000;
		RF_WrData_sel = 0;
		RF_B_sel = 0;
		#200;
		
		//lw Instruction
		Instr = 32'b001111_11010_00110_1101110110001111; 
		RF_WrEn = 1;
		ALU_out = 32'b10001000010011100010101101011001;
		MEM_out = 32'b01110011100111010010110001000000;
		RF_WrData_sel = 1;
		RF_B_sel = 0;
		#300;
		

	end
      
endmodule

