module PROCESSOR(
//all inputs
input Clk,
input Reset,
output Zero,
output PC_sel,
output  PC_LdEn,
output [31:0] Instr,
output  RF_WrData_sel,
output  RF_B_sel,
output  RF_WrEn,
output  ALU_Bin_sel,
output  [3:0] ALU_func,
output  MEM_WrEn
);


Datapath datapath(.Clk(Clk), .pc_reset(Reset),.pc_sel(PC_sel), .pc_lden(PC_LdEn), .mem_wren(MEM_WrEn), .alu_func(ALU_func), .alu_bin_sel(ALU_Bin_sel),
.mux_rf_b_sel(RF_B_sel), .rf_write(RF_WrEn), .rf_wr_data_sel(RF_WrData_sel),.Zero(Zero),.Instr(Instr));


controller FSM(.Zero(Zero),.Reset(Reset),.Instr(Instr),.MEM_WrEn(MEM_WrEn),.ALU_func(ALU_func),.ALU_Bin_sel(ALU_Bin_sel),
.RF_WrEn(RF_WrEn),.RF_B_sel(RF_B_sel),.RF_WrData_sel(RF_WrData_sel),.PC_LdEn(PC_LdEn),.PC_sel(PC_sel),.Clk(Clk)
);



endmodule 