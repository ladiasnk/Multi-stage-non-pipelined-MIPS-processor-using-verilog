`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:15:13 12/13/2021 
// Design Name: 
// Module Name:    register 
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
//
////////////////////////////////////////////////////////////////////////////////

//32-bit 32 to 1 Mux Design using Verilog case statement
//select one 32-bit line always according to S
module Mux32to1_32Bit(IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,
IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,S,OUT);
input [4:0] S;
input [31:0] IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31;
output reg [31:0] OUT;
	always @ (*)
	begin
	case (S)
	5'b00000: OUT = IN0;
	5'b00001: OUT = IN1;
	5'b00010: OUT = IN2;
	5'b00011: OUT = IN3;
	5'b00100: OUT = IN4;
	5'b00101: OUT = IN5;
	5'b00110: OUT = IN6;
	5'b00111: OUT = IN7;
	5'b01000: OUT = IN8;
	5'b01001: OUT = IN9;
	5'b01010: OUT = IN10;
	5'b01011: OUT = IN11;
	5'b01100: OUT = IN12;
	5'b01101: OUT = IN13;
	5'b01110: OUT = IN14;
	5'b01111: OUT = IN15;
	5'b10000: OUT = IN16;
	5'b10001: OUT = IN17;
	5'b10010: OUT = IN18;
	5'b10011: OUT = IN19;
	5'b10100: OUT = IN20;
	5'b10101: OUT = IN21;
	5'b10110: OUT = IN22;
	5'b10111: OUT = IN23;
	5'b11000: OUT = IN24;
	5'b11001: OUT = IN25;
	5'b11010: OUT = IN26;
	5'b11011: OUT = IN27;
	5'b11100: OUT = IN28;
	5'b11101: OUT = IN29;
	5'b11110: OUT = IN30;
	5'b11111: OUT = IN31;
	default : OUT = 32'bx;
	endcase
	end
endmodule
//1-to-2 decoder
module decoder1to2(In,Out);
input In;
output [1:0] Out;
assign Out[0]= ~In; 
assign Out[1]= In;

endmodule


// 2 to 4 Line Decoder Verilog Design
module decoder2to4(In, Out );
input [1:0] In;
output [3:0] Out;
wire  [3:0]W;
//Module instantiations
decoder1to2 u0(.In(In[1]),.Out(W[3:2])); 
decoder1to2 u1(.In(In[0]),.Out(W[1:0]));
//AND gates
assign Out[3] = W[3] & W[1];
assign Out[2] = W[3] & W[0];
assign Out[1] = W[2] & W[1];
assign Out[0] = W[2] & W[0];

endmodule

// 3 to 8 Line Decoder Verilog Design
module decoder3to8 (In,Out);
input [2:0] In;
output [7:0] Out;

wire  [5:0]W;
//Module Instantiations
decoder2to4 u0(.In(In[2:1]), .Out(W[5:2]));
decoder1to2 u1(.In(In[0]),.Out(W[1:0]));
//AND gates, using a smart for loop to assign them
   genvar idx;
	genvar idy;
	generate 
	for (idx = 3; idx >=0; idx = idx-1) begin : for_outer
				for ( idy = 1; idy >=0; idy =idy-1) begin : for_inner
						assign Out[idx*2 + idy] = W[idx + 2]	&  W[idy];
						end
					end
	endgenerate


endmodule

module decoder5to32(In,Out);
input [4:0] In;
output [31:0] Out;
wire  [11:0]W;
//Module Instantiations
decoder3to8 u0(.In(In[4:2]), .Out(W[11:4]));
decoder2to4 u1(.In(In[1:0]), .Out(W[3:0]));

//AND gates,using a smart for loop to assign them
   genvar idx;
	genvar idy;
	generate
		for (idx = 7; idx >=0; idx = idx-1) begin: for_outter
			for ( idy = 3; idy >=0; idy =idy-1) begin: for_inner
				begin : assign_out_values
					assign Out[idx * 4 + idy] = W[idx + 4]	&  W[idy];
				end
			end
		end	
	endgenerate

endmodule



module register(
input [31:0] Data,
output reg [31:0] Dout,
input clk,
input WE
);
//just pass Data to Dout whenever a positive edge of the clock occurs, and WE=1
always @(posedge clk) begin
		if (WE==1) begin
			Dout <= Data;
			end
end

endmodule

module register_file( Ard1, Ard2, Awr ,Din ,WrEn,clk,Dout1, Dout2);
input [4:0] Ard1, Ard2, Awr;
input [31:0] Din;
input WrEn, clk;
output [31:0] Dout1,Dout2;
	 //wires out of decoder
	wire  [31:0]WE_lines;
	//wires to create and gates for WE lines
	wire [31:0]WE_line_and;
	//wires to connect registers
	wire [31:0] r_wires [31:0];
	
	//decoder instantiation
	decoder5to32 dec (.In(Awr[4:0]), .Out(WE_lines[31:0]));
	assign WE_line_and[0] = 0; //r0 always zero 
	genvar i;
		generate for( i=1; i<=31; i=i+1) 
		begin : assign_WE_and_values
			assign WE_line_and[i]= WrEn & WE_lines[i];  
		end
		endgenerate
   //multiple registers using 
	//register r0(.Data(Din),.WE(WE_line_and[0]),.clk(clk),.Dout(r_wires[0]));
	assign r_wires[0]=0; 
   register r1(.Data(Din),.WE(WE_line_and[1]),.clk(clk),.Dout(r_wires[1]));
   register r2(.Data(Din),.WE(WE_line_and[2]),.clk(clk),.Dout(r_wires[2]));
   register r3(.Data(Din),.WE(WE_line_and[3]),.clk(clk),.Dout(r_wires[3]));	
	register r4(.Data(Din),.WE(WE_line_and[4]),.clk(clk),.Dout(r_wires[4]));
   register r5(.Data(Din),.WE(WE_line_and[5]),.clk(clk),.Dout(r_wires[5]));
   register r6(.Data(Din),.WE(WE_line_and[6]),.clk(clk),.Dout(r_wires[6]));
   register r7(.Data(Din),.WE(WE_line_and[7]),.clk(clk),.Dout(r_wires[7]));

	register r8(.Data(Din),.WE(WE_line_and[8]),.clk(clk),.Dout(r_wires[8]));
   register r9(.Data(Din),.WE(WE_line_and[9]),.clk(clk),.Dout(r_wires[9]));
   register r10(.Data(Din),.WE(WE_line_and[10]),.clk(clk),.Dout(r_wires[10]));
   register r11(.Data(Din),.WE(WE_line_and[11]),.clk(clk),.Dout(r_wires[11]));	
	register r12(.Data(Din),.WE(WE_line_and[12]),.clk(clk),.Dout(r_wires[12]));
   register r13(.Data(Din),.WE(WE_line_and[13]),.clk(clk),.Dout(r_wires[13]));
   register r14(.Data(Din),.WE(WE_line_and[14]),.clk(clk),.Dout(r_wires[14]));
   register r15(.Data(Din),.WE(WE_line_and[15]),.clk(clk),.Dout(r_wires[15]));
	
	register r16(.Data(Din),.WE(WE_line_and[16]),.clk(clk),.Dout(r_wires[16]));
   register r17(.Data(Din),.WE(WE_line_and[17]),.clk(clk),.Dout(r_wires[17]));
   register r18(.Data(Din),.WE(WE_line_and[18]),.clk(clk),.Dout(r_wires[18]));
   register r19(.Data(Din),.WE(WE_line_and[19]),.clk(clk),.Dout(r_wires[19]));	
	register r20(.Data(Din),.WE(WE_line_and[20]),.clk(clk),.Dout(r_wires[20]));
   register r21(.Data(Din),.WE(WE_line_and[21]),.clk(clk),.Dout(r_wires[21]));
   register r22(.Data(Din),.WE(WE_line_and[22]),.clk(clk),.Dout(r_wires[22]));
   register r23(.Data(Din),.WE(WE_line_and[23]),.clk(clk),.Dout(r_wires[23]));
	
	register r24(.Data(Din),.WE(WE_line_and[24]),.clk(clk),.Dout(r_wires[24]));
   register r25(.Data(Din),.WE(WE_line_and[25]),.clk(clk),.Dout(r_wires[25]));
   register r26(.Data(Din),.WE(WE_line_and[26]),.clk(clk),.Dout(r_wires[26]));
   register r27(.Data(Din),.WE(WE_line_and[27]),.clk(clk),.Dout(r_wires[27]));	
	register r28(.Data(Din),.WE(WE_line_and[28]),.clk(clk),.Dout(r_wires[28]));
   register r29(.Data(Din),.WE(WE_line_and[29]),.clk(clk),.Dout(r_wires[29]));
   register r30(.Data(Din),.WE(WE_line_and[30]),.clk(clk),.Dout(r_wires[30]));
   register r31(.Data(Din),.WE(WE_line_and[31]),.clk(clk),.Dout(r_wires[31]));
		
		

	Mux32to1_32Bit mux1(.IN0(r_wires[0]),.IN1(r_wires[1]),.IN2(r_wires[2])
	,.IN3(r_wires[3]),.IN4(r_wires[4]),.IN5(r_wires[5]),.IN6(r_wires[6])
	,.IN7(r_wires[7]),.IN8(r_wires[8]),.IN9(r_wires[9]),.IN10(r_wires[10])
	,.IN11(r_wires[11]),.IN12(r_wires[12]),.IN13(r_wires[13]),.IN14(r_wires[14])
	,.IN15(r_wires[15]),.IN16(r_wires[16]),.IN17(r_wires[17]),.IN18(r_wires[18])
	,.IN19(r_wires[19]),.IN20(r_wires[20]),.IN21(r_wires[21]),.IN22(r_wires[22])
	,.IN23(r_wires[23]),.IN24(r_wires[24]),.IN25(r_wires[25]),.IN26(r_wires[26])
	,.IN27(r_wires[27]),.IN28(r_wires[28]),.IN29(r_wires[29]),.IN30(r_wires[30])
	,.IN31(r_wires[31]),.S(Ard1[4:0]),.OUT(Dout1[31:0]));
	Mux32to1_32Bit mux2(.IN0(r_wires[0]),.IN1(r_wires[1]),.IN2(r_wires[2])
	,.IN3(r_wires[3]),.IN4(r_wires[4]),.IN5(r_wires[5]),.IN6(r_wires[6])
	,.IN7(r_wires[7]),.IN8(r_wires[8]),.IN9(r_wires[9]),.IN10(r_wires[10])
	,.IN11(r_wires[11]),.IN12(r_wires[12]),.IN13(r_wires[13]),.IN14(r_wires[14])
	,.IN15(r_wires[15]),.IN16(r_wires[16]),.IN17(r_wires[17]),.IN18(r_wires[18])
	,.IN19(r_wires[19]),.IN20(r_wires[20]),.IN21(r_wires[21]),.IN22(r_wires[22])
	,.IN23(r_wires[23]),.IN24(r_wires[24]),.IN25(r_wires[25]),.IN26(r_wires[26])
	,.IN27(r_wires[27]),.IN28(r_wires[28]),.IN29(r_wires[29]),.IN30(r_wires[30])
	,.IN31(r_wires[31]),.S(Ard2[4:0]),.OUT(Dout2[31:0]));
	 
endmodule
