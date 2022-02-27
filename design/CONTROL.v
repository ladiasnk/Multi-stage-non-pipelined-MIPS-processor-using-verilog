module controller(
output reg PC_sel,
    output reg PC_LdEn,
    output reg RF_WrData_sel,
    output reg RF_B_sel,
    output reg RF_WrEn,
    output reg ALU_Bin_sel,
    output reg [3:0] ALU_func,
    output reg MEM_WrEn,
    input [31:0] Instr,
    input Zero,
    input Clk,
    input Reset
);

//stages for the next stage logic, each stage has a seperate code
localparam i_fetch=4'b0000;
localparam PC_update=4'b1111;
localparam decode_rr=4'b0001;
localparam branch=4'b0010;
localparam mem_addr=4'b0011;
localparam mem_rd=4'b0100;
localparam mem_wr=4'b0101;
localparam ld_wb=4'b0111;
localparam alu_exec=4'b1000;
localparam alu_wb=4'b1001;

// opcodes :
/* R-TYPE */
localparam R_TYPE = 6'b100000; //R_Type  
// add,sub,or,and, operations with rt register
localparam AND=4'b0010;
localparam OR=4'b0011;
localparam SUB=4'b0001;
localparam ADD=4'b0000;
//memory commands commands
localparam SW=6'b011111;
localparam LW=6'b001111;
localparam LB=6'b000011;
localparam SB=6'b000111;
// li,lui,addi,andi, ori
localparam LI=6'b111000;
localparam LUI=6'b111001;
localparam ADDI=6'b110000;
localparam ANDI=6'b110010;
localparam ORI=6'b110011;
//branch commands opcodes
localparam B=6'b111111;
localparam BEQ=6'b000000;
localparam BNE=6'b000001;


reg [3:0] current_stage, next_stage;


//next stage logic
always @(Instr or Reset or current_stage) begin:NEXT_STAGE_LOGIC
      if (Reset) 
            next_stage = i_fetch;
		else 
		   begin	
		   case(current_stage)
			   PC_update:  next_stage=i_fetch;
				i_fetch: next_stage=decode_rr;
				decode_rr: case(Instr[31:26]) 
								R_TYPE,LI,LUI,ADDI,ANDI,ORI:begin
									if (Instr[20:16] == 5'b00000) //if rd==0 skip this command(i_fetch means grab next command)
											next_stage = PC_update;
										else
											next_stage = alu_exec;
										end
								LW,SW,LB,SB:next_stage=mem_wr;
								B,BEQ,BNE:next_stage=branch;
								default:$display("You suck!");
				            endcase
				alu_exec:next_stage=alu_wb;					     
			   branch:next_stage=PC_update;
			   alu_wb:next_stage=PC_update;
				mem_addr: begin
							if(Instr[31:26]==LW)
							   next_stage=mem_rd;
							else 
								next_stage=mem_wr;
								end
				mem_rd:next_stage=ld_wb;
				mem_wr:next_stage=PC_update;
				ld_wb:next_stage=PC_update;
			endcase  
			end//end else case
end//end always


	
always@(posedge Clk) begin:STATE_REGISTER;


 if(Reset)
		 current_stage<=PC_update;
		 else
		 current_stage<=next_stage;
		 end

always@(Instr or Reset or Zero or current_stage) begin:OUTPUTS_LOGIC

   if (Reset) begin
	        PC_sel=1'b0;
			  PC_LdEn=1'b0;
			  RF_WrData_sel=1'b0;
			  RF_B_sel=1'b0;
			  RF_WrEn=1'b0;
			  MEM_WrEn=1'b0;
			  ALU_Bin_sel=1'b0;
			  ALU_func=0;
	end
	else 
	 begin
    case(current_stage)
	 PC_update: begin 
			  PC_LdEn=1'b1;
			  RF_WrEn=1'b0;
			  MEM_WrEn=1'b0;
           end
	i_fetch:begin 
	        PC_LdEn=0;//Read new command from IMEM, disable PC_LdEn
           PC_sel=0;	
			  end
	decode_rr: begin //read A=RF[$rs],B=RF[$rt]
			  RF_B_sel=1'b0;
			  PC_LdEn=1'b0;
			  RF_WrEn=1'b0; // it is read stage not write
             end	
	alu_exec: begin // perform operation according to ALU_func
			  if(Instr[31:26]==R_TYPE) begin
			     ALU_Bin_sel=1'b0; 
				    ALU_func=Instr[3:0]; end//operations with both registers A and B
			  else if( Instr[31:26]!=LI || Instr[31:26]!=LUI ) begin//ADDI,ORI,ANDI
			    ALU_Bin_sel=1; 
				 ALU_func=Instr[29:26];   
				 end //operations only with A and Immediate:ADDI,ANDI,ORI
			  else if (Instr[31:26]!=R_TYPE) begin
			    ALU_Bin_sel=1'b1;
				 ALU_func=ADD; end
			  else
             $display("[%t] Should not be here!",$time);			  
			  
			        end
	branch: begin 
			  ALU_func=SUB;
			  if(Instr[31:26]==BEQ) begin // beq command 
				  if(Zero)
					  PC_sel=1'b1; //PC+4+Imm<<2
				  else 
					  PC_sel=1'b0; // PC+4
					            end
			  else if(Instr[31:26]==BNE) begin //bne command
						  if(!Zero)
							  PC_sel=1'b1; //PC+4+Imm<<2
						  else 
							  PC_sel=1'b0;//PC+4
			                       end
			  else 
			      PC_sel=1;
				end	// branch command: PC=PC+4+Immediate<<2
	 alu_wb: begin //write output of ALU_out to RF[$rd]
			  RF_WrData_sel=1'b0; //ALU_out write
			  RF_B_sel=1'b0; 
			  RF_WrEn=1'b1;//write
           end
    mem_addr: //add immediate and A (LW)
           begin 
			  ALU_func=ADD;
			  ALU_Bin_sel=1'b1;
           end	 
	 mem_wr:begin //enable write to memory to store B contexts wherever alu_out adress points to
			  MEM_WrEn=1'b1;
           end
	 mem_rd:MEM_WrEn=1'b0; // just read alu_out from memory
	 ld_wb:begin	// write alu_out in register file, to RF[$rd]
			  RF_WrData_sel=1'b1;
			  RF_WrEn=1'b1;
	       end
endcase	
end
end
     

						  
						  
						  
endmodule 