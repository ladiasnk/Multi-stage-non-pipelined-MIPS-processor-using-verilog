
//parameterized mux 2 to 1, to implement the different bit input sizes
module mux2to1_parameterized
#(
parameter bitsize=32)
(
input [bitsize-1:0] A,B,
input sel,
output [bitsize-1:0] out
);

assign out = (sel==0) ? A : B; 

endmodule 

//module for extending immediate
module Immediate_extension(
input [15:0] Immediate,
input [5:0] opcode, // opcode of Instruction given
output reg [31:0] result); //32-bit output

// temporary variable to store a value
reg [5:0]i;
reg [5:0]temp;
   always @ (*)
	begin
	case(opcode)
	  6'b111000:result={ {16{Immediate[15]}}, Immediate[15:0] };//li command, sign extension
	  6'b111001:result=Immediate<<16;  //lui command, zero fill
	  6'b110000:result={ {16{Immediate[15]}}, Immediate[15:0] }; // addi command, sign extension
	  6'b110010:result={16'd0,Immediate}; //andi command, zero fill
	  6'b110011:result={16'd0,Immediate}; //ori command, zero fill
	  6'b111111,6'b000000,6'b000001:result= {{16{Immediate[15]}}, Immediate[15:0]<<2}; // b,beq,bne command, sign extend			
	  default:result=32'hxxxxxxxx;
	endcase 
	
	 


end
endmodule




module decode_unit(input [31:0] Instr,
input RF_WrEn,
input [31:0 ] ALU_out,
input [31:0] MEM_out,
input RF_WrData_sel,
input RF_B_sel,
input Clk,
output [31:0] Immed,
output [31:0] RF_A,
output [31:0] RF_B
);
//wires needed defined, one 32-bit for the mux to register file connection on the write data
//one 5-bit or the instruction selection for the read register 2, and of course all the wires needed for the
//different bits needed of the Instr input
wire [31:0] write_data;
wire [15:0] Immediate=Instr[15:0];
wire [4:0] Write_register=Instr[20:16];
wire [4:0] rd=Instr[15:11];
wire [4:0] rs=Instr[25:21];
wire [5:0] opcode=Instr[31:26];
wire [4:0] mux_to_readreg2;
//5 bit mux for the read register 2 
mux2to1_parameterized #(.bitsize(5)) mux_read_reg2(.A(rd),.B(Write_register),.sel(RF_B_sel),.out(mux_to_readreg2));
//32 bit mux for the write data of the register file
mux2to1_parameterized #(.bitsize(32)) mux_write(.A(ALU_out), .B(MEM_out), .sel(RF_WrData_sel), .out(write_data));

//now the register file instantiation can take place
register_file reg_file(.Ard1(rs), .Ard2(mux_to_readreg2),.Awr(Write_register),.Din(write_data),.WrEn(RF_WrEn),
.Dout1(RF_A),.Dout2(RF_B),.clk(Clk));

//extend Immediate using a module implementing logic
Immediate_extension Immediate_ext(.Immediate(Immediate),.opcode(opcode), .result(Immed));

endmodule 