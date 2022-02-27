
// ROM memory of 1024 slots of 32-bit each
module IFSTAGE( input clk, input [9:0] addr, output reg [31:0] dout );

reg [31:0] ROM [1023:0];
initial
		begin
		$readmemb("rom.data", ROM);
end

always @(posedge clk)begin
dout <= ROM[addr];
end

endmodule 

// PC is a Register with synch reset load behavior
module PC(input [31:0] Din, input Clk,
input reset, input load, output reg [31:0] Dout);

always @(posedge Clk) begin
	if (reset)
	   Dout <= 32'h00000000;
	else if (load)
	   Dout <= Din;
	else
      Dout<=Dout;	
end
endmodule 

module mux2to1_32bit(input [31:0] In1,In2,
input sel,
output [31:0] Out
);
assign Out = (sel==0) ? In1 : In2;

endmodule


module command_unit(input [31:0] PC_Immed, 
input PC_sel,
input PC_LdEn,
input Reset,
input Clk,
output [31:0] Instr
);
// self explanatory names of wires needed
wire [31:0] mux_to_PC;
wire [31:0] PC_to_IMEM;
wire [31:0] PC_incr ;
wire [31:0] PC_immed_inc;

assign PC_incr=PC_to_IMEM+4;


assign PC_immed_inc = PC_incr+PC_Immed;


mux2to1_32bit mux(.In1(PC_incr), .In2(PC_immed_inc),.sel(PC_sel),.Out(mux_to_PC) );

PC PC_reg(.Din(mux_to_PC), .Clk(Clk), .reset(Reset), .load(PC_LdEn), .Dout(PC_to_IMEM));

IFSTAGE IMEM(.clk(Clk),.addr(PC_to_IMEM[11:2]), .dout(Instr));

endmodule 