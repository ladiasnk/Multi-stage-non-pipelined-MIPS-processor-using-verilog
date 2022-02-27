`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:23 12/12/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    output reg [31:0] out,
    output reg Zero, 
    input wire [31:0] A,B , 
    input wire [3:0] Op
    );
   always @(*) begin
		case(Op)
			4'b0000 : out = A+B;
			4'b0001 : out = A-B;
			4'b0010 : out = A&B;
			4'b0011 : out = A|B;
			4'b0100 : out = !A;
			4'b1000 : begin
			out = A>>1;//arithmetic shift right??== (int) A >> 1
			out[31]=A[31];
			end
			4'b1010 : out = A>>1;
			4'b1001 : out = A<<1;
			4'b1100 : out = {A[30:0] , A[31]}; 		
			4'b1101 : out = {A[0], A[31:1]};
			default: out = 32'b11111111111111111111111111111111;
		endcase
      if(out==0)
			   Zero =1;
	   else
		    Zero=0;		
   end
	
endmodule
