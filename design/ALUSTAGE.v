`timescale 1ns / 1ps
//MUX on the input side of the ALU 
module mux2to1(
input [31:0] A,B,
input sel,
output [31:0] out
);

assign out = (sel==0) ? A : B; 

endmodule 

module ALU_main
(
input [31:0] RF_A,
input [31:0] RF_B,
input [31:0 ] Immed,
input ALU_Bin_sel,
input [3:0] ALU_func,
output [31:0 ]ALU_out,
output Zero
);
wire [31:0] mux_out;

mux2to1 mux(.A(RF_B), .B(Immed), .sel(ALU_Bin_sel), .out(mux_out));
ALU alu(.out(ALU_out),.Op(ALU_func),.A(RF_A),.B(mux_out),.Zero(Zero));
endmodule


