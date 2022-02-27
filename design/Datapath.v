`timescale 1ns / 1ps
module Datapath(

//all inputs
input Clk,
input pc_reset,
input pc_lden,
input mux_rf_b_sel,
input alu_bin_sel,
input pc_sel,
input mem_wren,
input rf_wr_data_sel,
input  rf_write,
input [3:0] alu_func,
output Zero,
output [31:0] Instr
);

//wires to connect rest of the signals
wire [31:0] Instr_wire;
wire [31:0] immediate;
wire [31:0] alu_out;
wire [31:0] mem_out;
wire [31:0] rf_a;
wire [31:0] rf_b;
command_unit encoder(.Clk(Clk),.PC_sel(pc_sel),.PC_LdEn(pc_lden),.Reset(pc_reset),.PC_Immed(immediate),.Instr(Instr));


decode_unit decoder(.Clk(Clk),.Instr(Instr),.Immed(immediate),.ALU_out(alu_out),.MEM_out(mem_out),
.RF_B_sel(mux_rf_b_sel),.RF_WrData_sel(rf_wr_data_sel),.RF_WrEn(rf_write),.RF_A(rf_a),.RF_B(rf_b));

ALU_main alu(.RF_A(rf_a),.RF_B(rf_b),.Immed(immediate),.ALU_Bin_sel(alu_bin_sel),.ALU_func(alu_func),.ALU_out(alu_out),.Zero(Zero));
MEM_main memory(.clk(Clk),.Mem_WrEn(mem_wren),.ALU_MEM_Addr(alu_out),.MEM_DataIn(rf_b),.MEM_DataOut(mem_out));
endmodule 