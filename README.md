# Multi-stage MIPS processor in verilog
This is a multi-stage MIPS processor I designed using HDL language verilog. The processor consists of 4 stages and a control-FSM(Finite State Machine).
All 4 stages along with the FSM overview are presented below in the complete datapapth of the processor.The instructions that this processor is designed to run are only those given in the programm.txt
file, this is in the context of a university course I took. However, this is a general implementation that can easily be extended to a normal PROCESSOR running all MIPS instructions. The 32-bit version of each sequential instruction is presented
in the rom.data file. 
## All the RTL view were generated using Intel Quartus Prime 17.0 software, while the behavioral simulation of every testbench was implemented using the XilinX software, you can find all RTL views as well as the datapath of the processor in the RTL views file.
- IFSTAGE is responsible for fetching every new instruction from ROM memory , the PC counter looks for the next command by getting incremented with the appropriate value (+4 or +4+Immediate)
- DECSTAGE is responsible of recognizing the instruction given by splitting the 32-bits in parts and then operating based on if the command is of I-format or R-format. A register file of 32 32-bit registers is used to here also that outputs 2 32-bit registers, RF_A and RF_B. 
- ALUSTAGE consists of 32-bit 2 input ALU and MUX that decides whether to choose from RF_B or Immed to perform an R-format operation or I-format respectively. Depending on the ALU_func given it performs the right operation with both 32-bit vectors. (Immed is originally 16 bits but it is extended properly according to the array of instructions provided below)
- MEMSTAGE is basically our RAM memory of 1024 adresses of 32-bit vectors. It either writes the data MEM_DataIn on the adress given by ALU_MEM_Addr or reads from that adress according to MEM_WrEn value (1 or 0 respectively)

### The complete datapath 
![Datapath](https://github.com/ladiasnk/Multi-stage-non-pipelined-MIPS-processor-using-verilog/blob/main/RTL%20views/datapath.png)


This non-pipelined processor is based on a subset of the instruction set architecture which consists of the following elements:
- 32 registers of 32 bits. The R0 register is always zero
- 32 bit wide commands with field size and position described below
- Commands for arithmetic and logical operations: add, sub, and, not, or, shr, shl, sla,rol, ror, li, addi, andi, ori
- Branch commands: b, beq, bneq
- Memory commands: lw, sw

The above commands have two types of format:
- R format
| Opcode      | rs         | rd | rt | not used | func   |
|-------------|:-------------:|-----:|--------:|-------:|------:|
| 6 bits     | 5 bits      |   5 bits    | 5 bits| 5 bits |  6 bits  |

- I format
| Opcode      | rs         | rd | Immediate   |
|-------------|:-------------:| -----:|------:|
| 6 bits     | 5 bits      |   5 bits    | 16 bits  |

### Commands are coded according to the following table:
| Opcode      | FUNC         | COMMAND | OPERATION |
| ------------- |:-------------:| -----:|  --------:|
| 100000      | 110000       |   add    |  RF[rd] <-- RF[rs] + RF[rt]                        | 
| 100000      | 110001       |   sub    |  RF[rd] <-- RF[rs] - RF[rt]                        | 
| 100000      | 110010       |   and    |  RF[rd] <-- RF[rs] & RF[rt]                        |
| 100000      | 110100       |   not    |  RF[rd] <-- ! RF[rs]                               | 
| 100000      | 110011       |   or     |  RF[rd] <-- RF[rs] | RF[rt]                        | 
| 100000      | 111000       |   sra    |  RF[rd] <-- RF[rs] >>1                             |
| 100000      | 111001       |   sll    |  RF[rd] <-- RF[rs] <<1 (Logical, zero fill LSB)    | 
| 100000      | 111010       |   srl    |  RF[rd] <-- RF[rs] >>1 (Logical, zero fill MSB)    | 
| 100000      | 111100       |   rol    |  RF[rd] <-- Rotate left(RF[rs])                    | 
| 100000      | 111101       |   ror    |  RF[rd] <-- Rotate right(RF[rs])                   | 
| 111000      |      -       |   li     |  RF[rd] <-- SignExtend(Imm)                        |
| 111001      |      -       |   lui    |  RF[rd] <-- Imm << 16 (zero-fill)                  | 
| 110000      |      -       |   addi   |  RF[rd] <-- RF[rs] + SignExtend(Imm)               | 
| 110010      |      -       |   andi   |  RF[rd] <-- RF[rs] & ZeroFill(Imm)                 |
| 110011      |      -       |   ori    |  RF[rd] <-- RF[rs] | ZeroFill(Imm)                 | 
| 111111      |      -       |   b      |  PC <-- PC + 4 + (SignExtend(Imm) << 2)            | 
| 000000      |      -       |   beq    |  if (RF[rs] == RF[rd])                             |
                                              PC <-- PC + 4 + (SignExtend(Imm) << 2)        
                                           else                                             
                                              PC <-- PC + 4                                 
| 000001      |      -       |   bne    |   if (RF[rs] != RF[rd])                            |
                                              PC <-- PC + 4 + (SignExtend(Imm) << 2)        
                                           else                                             
                                              PC <-- PC + 4                                  
| 001111      |      -       |   lw     | RF[rd] <-- MEM[RF[rs] + SignExtend(Imm)]           | 
| 011111      |      -       |   sw     | MEM[RF[rs] + SignExtend(Imm)] <-- RF[rd]           | 


### File hierarchy :
- ALU.v , implements the ALU module only
- ALUSTAGE.v , connects ALU with a mux using a top level module ALU_main
- IFSTAGE.v , uses a ROM memory, a mux and a top level module command_unit to implement the entire stage 
- register_file.v , implements the entire register file using 32 32-bit registers, a decoder 5-to-32 , 2 32-to-1 muxes and connects all WE lines of all registers to WrEn of the registrer file using AND gates
- DECSTAGE , uses a register file, 2 muxes and a Immediate_extension module and top level module decode_unit
- MEMSTAGE , uses only a MEMSTAGE module where the RAM memory is located , and a top level module MEM_main

