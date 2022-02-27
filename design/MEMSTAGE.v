module MEMSTAGE( 
input clk, 
input we, 
input [9:0] addr, 
input [31:0] din, 
output reg [31:0] dout );
reg [31:0] RAM [1023:0];
	always @(posedge clk)
	begin
	if(we)
	RAM[addr] = din;
	else
	dout = RAM[addr];
	end
	
endmodule 
	
module MEM_main(
input clk,
input Mem_WrEn,
input [31:0] ALU_MEM_Addr,
input [31:0] MEM_DataIn,
output [31:0] MEM_DataOut
);

MEMSTAGE mem(.clk(clk), .we(Mem_WrEn), .addr(ALU_MEM_Addr[11:2]),.din(MEM_DataIn), .dout(MEM_DataOut));

endmodule 