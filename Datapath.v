`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 04:01:04 PM
// Design Name: 
// Module Name: Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath(Clk, Rst);
    input Clk, Rst;
    

//clock signal determined at end
    
    
    //Controller signals
    wire [1:0] RegDst; 
    wire ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0, Opcode, Jump, JRegOrImm;
    
/////////////////INSTRUCTION FETCH STAGE///////////////////////////////////////////    
    
    wire [31:0] IF_Instruction;
    wire [31:0] PCResult;
    wire [31:0] PCAddResult;
    wire [31:0] PC_in;
    
    //InstructionFetchUnit    IF(IF_Instruction, PCResult, PCAddResult, Rst, Clk);
    
    ProgramCounter         ProgramCounter(PC_in, PCResult, Rst, Clk);
    
    Adder_32bit             PCAdder(PCResult, 32'd4, PCAddResult);
    
    InstructionMemory      InstructionMemory(PCResult, IF_Instruction);
    
    wire Load_Reg = 1;
    wire [31:0] ID_PCResult;
    wire [31:0] ID_Instruction;
    
    IF_ID_Reg               IF_ID_Reg(IF_Instruction, PCResult, Clk, Rst, 1'b1 , ID_Instruction, ID_PCResult);
    
/////////////////INSTRUCTION DECODE STAGE////////////////////////////////////////////
   
    wire [31:0] ReadData1; 
    wire [31:0] ReadData2;
    wire [31:0] SignExtended; 
    wire WB_RegWrite;
    wire [31:0] WB_Data;
    
    wire [31:0] jump_imm, jump_rs;
    
    //wires exiting IDEX register
    wire [31:0] EX_ReadData1;
    wire [31:0] EX_ReadData2;
    wire [31:0] EX_SignExtend;
    wire [31:0] EX_PCResult,  EX_jumpImm, EX_jumpRs;
    wire [4:0] EX_Instruction20_16, EX_Instruction15_11;
    wire [5:0] EX_Instruction5_0;
    wire [1:0] EX_Jump;
    wire ALUOp1_out, ALUOp0_out, RegDst_out, ALUSrc_out;
    wire EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite;
    
    ShiftLeft2              Shift_jr(ReadData1, jump_rs);
    
    ShiftLeft2              Shift_jaddr(ID_Instruction[25:0], jump_imm);

    Controller              Controller(ID_Instruction[31:26], RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0, Jump);
    
    RegisterFile            Registers(ID_Instruction[25:21], ID_Instruction[20:16], ID_Instruction[15:11], WB_Data, WB_RegWrite,  Clk, ReadData1, ReadData2);
    
    SignExtension           SignExtend(ID_Instruction[15:0], SignExtended);
    
    ID_EX_Reg               ID_EX_Reg(ReadData1, ReadData2, SignExtended, ID_PCResult, ID_Instruction[20:16], ID_Instruction[15:11], ID_Instruction[5:0],
                                     ALUOp1, ALUOp0, RegDst, ALUSrc, Branch, MemWrite, MemRead, MemtoReg, RegWrite, Jump, jump_imm, jump_rs,
                                     Clk, Rst, 1'b1, 
                                     EX_ReadData1, EX_ReadData2, EX_SignExtend, EX_PCResult, EX_Instruction20_16, EX_Instruction15_11, EX_Instruction5_0,
                                     ALUOp1_out, ALUOp0_out, RegDst_out, ALUSrc_out, 
                                     EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_Jump, EX_jumpImm, EX_jumpRs);
    
////////////////////EXECUTION STAGE////////////////////////////////////////////////////
    //wires coming from IDEX
    wire [31:0] EXMEM_PC;
    wire [31:0] ALUSrcData;
    
    wire [31:0] Imm_shifted;
    
    ShiftLeft2              ShiftImm(EX_SignExtend, Imm_shifted);
    
    Adder_32bit             PCAdd (EX_PCResult, Imm_shifted, EXMEM_PC);
    Mux32Bit2To1            MuxALU(ALUSrcData, EX_ReadData2, EX_SignExtend, ALUSrc);
    
    wire Zero;
    wire [4:0] ALUControl;
    wire [31:0] ALUResult;
    wire [31:0] HI_in, LO_in;
    wire HI_LO_Write;
    
    ALU32Bit                ALU1  (ALUControl, EX_ReadData1, ALUSrcData, ALUResult, Zero, HI_in, LO_in, HI_LO_Write);
    


    
//ALU_Control             ALU_Control()    ;//*****************************************

    

    wire [4:0] RegDstData;
    
    Mux32Bit3To1            MuxRegDst (RegDstData, EX_Instruction20_16, EX_Instruction15_11, 32'd31, RegDst);
    
    //outputs of the EXMEM Pipeline Register
    wire [31:0] MEM_PCResult;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_Data2;
    wire [31:0] MEM_RegDstData;
    wire MEM_Branch;
    wire MEM_Zero;
    wire MEM_MemWrite;
    wire MEM_MemRead;
    wire MEM_MemtoReg;
    wire MEM_RegWrite;
    wire [31:0] MEM_HI, MEM_LO, MEM_jumpImm, MEM_jumpRs;
    wire [5:0] MEM_func;
    wire [1:0] MEM_Jump;
    
    
    EX_MEM_Reg              EX_MEM (EX_RegWrite, EX_MemtoReg, EX_Branch, EX_MemWrite, EX_MemRead,
                                    Zero, EXMEM_PC, ALUResult, EX_ReadData2, RegDstData, HI_in, LO_in, EX_Instruction5_0, EX_Jump, EX_jumpImm, EX_jumpRs,
                                    MEM_RegWrite, MEM_MemtoReg, MEM_Branch, MEM_MemWrite, MEM_MemRead,
                                    MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDstData, MEM_HI, MEM_LO, MEM_func, MEM_Jump, MEM_jumpImm, MEM_jumpRs,
                                    Clk, Rst, 1'b1 );
    
    
////////////////////MEMORY STAGE////////////////////////////////////////////////////

    wire PC_Src;
    wire [31:0] ReadData;
    wire [31:0] Next_PC;
    
    Compare                 checkFunc(MEM_func, , , MEM_Jump);
    
    ANDGate                 AND_Branch(MEM_Branch, MEM_Zero, PC_Src);
    
    Mux32Bit3To1            PCTarget( Next_PC, MEM_PCResult, MEM_jumpImm, MEM_jumpRs, MEM_Jump);
    
    DataMemory              Data_Memory(MEM_ALUResult, MEM_Data2, Clk, MEM_MemWrite, MEM_MemRead, ReadData);
    
    Mux32Bit2To1            NextPC(PC_in, PCAddResult, Next_PC, (PC_Src | Jump) );
      
    wire [31:0] inputHI, inputLO;
    wire HI_Src, LO_Src;
     
    Mux32Bit2To1            HI_mux (inputHI, ID_Instruction[25:21], MEM_HI, HI_LO_Write);
    Mux32Bit2To1            LO_mux (inputLO, ID_Instruction[25:21], MEM_LO, HI_LO_Write);
    
    wire [31:0] HI_out, LO_out;
    
    HI_Reg                  HI_Reg (inputHI, HI_out, Clk, HI_LO_Write, Rst);
    LO_Reg                  LO_Reg (inputLO, LO_out, Clk, HI_LO_Write, Rst);

    
    wire WB_MemtoReg;
    wire [31:0] WB_ReadData, WB_ALUResult, WB_HI, WB_LO;
    wire [4:0] WB_RegDstData;
    wire [5:0] WB_func;
    
    MEM_WB_Reg              MEM_WB(MEM_RegWrite, MEM_MemtoReg, ReadData, MEM_ALUResult, MEM_RegDstData, HI_out, LO_out, MEM_func, 
                                    Clk, Rst, 1'b1,
                                    WB_RegWrite, WB_MemtoReg, WB_ReadData, WB_ALUResult, WB_RegDstData, WB_HI, WB_LO, WB_func);
                                    
                                    
                                    
////////////////////WRITEBACK STAGE////////////////////////////////////////////////////
    wire WriteHILO;             /////////move to controller
    wire MEM_or_HILO;
    
    Compare                 compareFunc(WB_func, WriteHILO, MEM_or_HILO);
    
    wire[31:0] WB_Data2;
    
    Mux32Bit2To1            WriteBackData(WB_Data2, WB_ReadData, WB_ALUResult, WB_MemtoReg);
    
    wire [31:0] HI_OR_LO;


    Mux32Bit2To1            HI_or_LO(HI_OR_LO, WB_HI, WB_LO, WriteHILO);
    
    Mux32Bit2To1            FinalWBData(WB_Data, WB_Data2, HI_OR_LO, MEM_or_HILO);
    
    


endmodule
