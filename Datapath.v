`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// LAB GROUP 32
//      CAMERON MATSUMOTO, ASHTON ROWE, JOE LIANG
//      
//      PERCENT EFFORT:
//          CAMERON 33%     ASHTON 33%      JOE 33%
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath(Clk, Rst, PCResult);
    input Clk, Rst;
    output wire [31:0] PCResult;

//clock signal determined at end
    
    
    //Controller signals
    wire ALUSrc, ALUSrc2, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump; 
    wire [1:0] RegDst;
    wire SignExtend;
    wire [1:0] Datatype;
    wire [1:0] HI_LO_Write; // 0: don't write, 1: HI, 2: LO, 3: Both
    wire [4:0] ALUControl;
    
/////////////////INSTRUCTION FETCH STAGE///////////////////////////////////////////    
    
    wire [31:0] IF_Instruction; 
    
    wire [31:0] PCAddResult;
    wire [31:0] PC_in;
    wire [31:0] PC4_or_PCoffset;
    
    //InstructionFetchUnit    IF(IF_Instruction, PCResult, PCAddResult, Rst, Clk);
                           
                           //Adder_32bit(A, B, Out);
    Adder_32bit            PCAdder(PCResult, 32'd4, PCAddResult); //PCAddResult = PCResult + 4
    
                           //ProgramCounter(Address, PCResult, Reset, Clk);
    ProgramCounter         ProgramCounter(PC_in, PCResult, Rst, Clk); //PCResult = PC_in if Rst ==0 // muxes for input occur in MEM stage
    
                           //InstructionMemory(Address, Instruction);
    InstructionMemory      InstructionMemory(PCResult, IF_Instruction);
    
    //wire Load_Reg = 1;
    wire [31:0] ID_PCResult;
    wire [31:0] ID_Instruction;

                            //IF_ID_Reg(Instruction_in, PCResult_in, Clk, Clr, Ld, Instruction_out, PCResult_out)
    IF_ID_Reg               IF_ID_Reg(IF_Instruction, PCAddResult, Clk, Rst, 1'b1, ID_Instruction, ID_PCResult);
    
/////////////////INSTRUCTION DECODE STAGE////////////////////////////////////////////
   
    wire [31:0] ReadData1; 
    wire [31:0] ReadData2;
    wire [31:0] SignExtended; 
    wire WB_RegWrite1, WB_RegWrite2;
    (* mark_debug = "true" *) wire [31:0] WB_Data;
    
    wire [31:0] jump_imm, jump_rs;
    
    //wires exiting IDEX register
    wire [31:0] EX_ReadData1;
    wire [31:0] EX_ReadData2;
    wire [31:0] EX_SignExtend;
    wire [31:0] EX_PCResult,  EX_jumpImm, EX_jumpRs;
    wire [4:0]  EX_Instruction20_16, EX_Instruction15_11;
    wire [5:0] EX_Instruction5_0, EX_Instruction31_26;
    wire  EX_Jump;
    wire ALUOp1_out, ALUOp0_out, ALUSrc_out;
    wire [4:0] ALUControl_out;
    wire EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_ALUSrc2;
    wire [1:0] HI_LO_Write;
    wire [1:0] EX_Datatype, RegDst_out;
    
    /*ShiftLeft2              Shift_jr(ReadData1, jump_rs);
    
    ShiftLeft2              Shift_jaddr(ID_Instruction[25:0], jump_imm);*/

                            //Controller(Opcode, Bit21, Bit20_16, Bit10_6, funct, RegDst, ALUSrc, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, Branch, Jump, Datatype, ALUControl, SignExtend);
    Controller              Controller(ID_Instruction[31:26], ID_Instruction[21], ID_Instruction[20:16], ID_Instruction[10:6], ID_Instruction[5:0], 
                                                    RegDst, ALUSrc, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, 
                                                    MemRead, MemWrite, Branch, Jump, Datatype, ALUControl, SignExtend);
                                
    wire [31:0] regWriteAddr;

                            //RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile            Registers(ID_Instruction[25:21], ID_Instruction[20:16], WB_RegDstData, WB_Data, WB_RegWrite1 | WB_RegWrite2, Clk, ReadData1, ReadData2);
    
                            //SignExtension(in, out, signOrZero);
    SignExtension           SignExtension(ID_Instruction[15:0], SignExtended, SignExtend);

                            //ID_EX_Reg(ReadData1_in, ReadData2_in, SignExtend_in, PCResult_in, Instruction31_26, Instruction20_16, Instruction15_11, Instruction5_0,
                            //ALUOp1, ALUOp0, RegDst, ALUSrc, ALUControl, Branch, MemWrite, MemRead, MemtoReg, RegWrite, Jump, jump_imm, jump_rs, ALUSrc2, Datatype,
                            //Clk, Clr, Ld, 
                            //ReadData1_out, ReadData2_out, SignExtend_out, PCResult_out, Instruction31_26_out, Instruction20_16_out, Instruction15_11_out, Instruction5_0_out,
                            //ALUOp1_out, ALUOp0_out, RegDst_out, ALUSrc_out, ALUControl_out, Branch_out, 
                            //MemWrite_out, MemRead_out, MemtoReg_out, RegWrite_out, Jump_out, EX_jumpImm, EX_jumpRs, EX_ALUSrc2, EX_Datatype);
            
    ID_EX_Reg               ID_EX_Reg(ReadData1, ReadData2, SignExtended, ID_PCResult, ID_Instruction[31:26], ID_Instruction[20:16], ID_Instruction[15:11], ID_Instruction[5:0],
                                     ALUOp1, ALUOp0, RegDst, ALUSrc, ALUControl, Branch, MemWrite, MemRead, MemtoReg, RegWrite, Jump,
                                     {16'd0,ID_Instruction[15:0]}, ReadData1, ALUSrc2, Datatype,
                                     Clk, Rst, 1'b1, 
                                     EX_ReadData1, EX_ReadData2, EX_SignExtend, EX_PCResult, EX_Instruction31_26, EX_Instruction20_16, EX_Instruction15_11, EX_Instruction5_0,
                                     ALUOp1_out, ALUOp0_out, RegDst_out, ALUSrc_out, ALUControl_out, 
                                     EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_Jump, EX_jumpImm, 
                                     EX_jumpRs, EX_ALUSrc2, EX_Datatype);
    
////////////////////EXECUTION STAGE////////////////////////////////////////////////////
    //wires coming from IDEX
    wire [31:0] EXMEM_PC;
    wire [31:0] ALUSrc1Data, ALUSrc2Data;
    
    wire [31:0] Imm_shifted;

                            //ShiftLeft2(In, Out);
    ShiftLeft2              ShiftImm(EX_SignExtend, Imm_shifted);

                            //Adder_32bit(A, B, Out);
    Adder_32bit             PCAdd (EX_PCResult, Imm_shifted, EXMEM_PC); //EX_PCResult + Imm_shifted
    
    Mux32Bit2To1            MuxALUinput1(ALUSrc1Data, EX_ReadData1, EX_SignExtend, EX_ALUSrc2); //decides between rs and imm
    Mux32Bit2To1            MuxALUinput2(ALUSrc2Data, EX_ReadData2, EX_SignExtend, ALUSrc_out); //decides between rt and imm

    
    wire Zero, RegWrite2;
    wire [31:0] ALUResult;
    wire [31:0] HiALUOut, LoALUOut;
   
    
    wire [31:0] inputHI, inputLO; 
    (* mark_debug = "true" *) wire [31:0] Hi_out, Lo_out;
    wire HI_Src, LO_Src;
     
    //Mux32Bit2To1            HI_mux (inputHI, EX_ReadData1, HiALUOut, HI_LO_Write);
    //Mux32Bit2To1            LO_mux (inputLO, EX_ReadData1, LoALUOut, HI_LO_Write);
    
    wire [31:0] HI_out, LO_out;

                            //HI_Reg(in, out, Clk, Ld, Clr)
    HI_Reg                  HI_Reg (HiALUOut, HI_out, Clk, HI_LO_Write[0], Rst);
                            //LO_Reg(in, out, Clk, Ld, Clr)
    LO_Reg                  LO_Reg (LoALUOut, LO_out, Clk, HI_LO_Write[1], Rst);

    
/////////hi and lo in     
                            //ALU32Bit(ALUControl, A, B, Hi_in, Lo_in, Opcode, ALUResult, Hi, Lo, Zero, RegWrite2)
    ALU32Bit                ALU1  (ALUControl_out, ALUSrc1Data, ALUSrc2Data, HI_out, LO_out, EX_Instruction31_26, ALUResult, HiALUOut, LoALUOut, Zero, RegWrite2);
    
    wire [31:0] RegDstData;
    
    Mux32Bit3To1            MuxRegDst (RegDstData, {27'd0, EX_Instruction20_16}, {27'd0, EX_Instruction15_11}, 32'd31, RegDst_out);
    
    //outputs of the EXMEM Pipeline Register
    wire [31:0] MEM_PCResult;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_Data2;
    wire [31:0] MEM_RegDstData;
    wire MEM_Branch, MEM_ALUSRC2;
    wire MEM_Zero;
    wire MEM_MemWrite;
    wire MEM_MemRead;
    wire MEM_MemtoReg;
    wire MEM_RegWrite, MEM_RegWrite2;
    wire [1:0] MEM_Datatype;
    wire [31:0] MEM_HI, MEM_LO, MEM_jumpImm, MEM_jumpRs;
    wire [5:0] MEM_func;
    wire MEM_Jump;
    
                            //EX_MEM_Reg(EX_RegWrite, RegWrite2, EX_MemtoReg, 
                            //EX_Branch, EX_MemWrite, EX_MemRead,
                            //EX_Zero, EX_PCResult, EX_ALUResult, EX_Data2, EX_RegDstData, HI, LO, func, Jump, jumpImm, jumpRs, Datatype,
                            
                            //MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                            //MEM_Branch, MEM_MemWrite, MEM_MemRead,
                            //MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDstData, MEM_HI, MEM_LO, func_out, Jump_out, MEM_jumpImm, MEM_jumpRs, MEM_Datatype,
                            
                            //Clk, Clr, Ld);
    EX_MEM_Reg              EX_MEM (EX_RegWrite, RegWrite2, EX_MemtoReg, EX_Branch, EX_MemWrite, EX_MemRead,
                                    Zero, EXMEM_PC, ALUResult, EX_ReadData2, RegDstData[4:0], EX_Instruction5_0, EX_Jump, EX_jumpImm, EX_jumpRs, EX_Datatype, EX_ALUSrc2,
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_Branch, MEM_MemWrite, MEM_MemRead,
                                    MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDstData[4:0], MEM_func, MEM_Jump, MEM_jumpImm, MEM_jumpRs, MEM_Datatype, MEM_ALUSrc2,
                                    Clk, Rst, 1'b1 );
    
    
////////////////////MEMORY STAGE////////////////////////////////////////////////////

    wire PC_Src;
    wire [31:0] MemDataOut;
    wire [31:0] Imm_or_Rs;
    
    ANDGate                 AND_Branch(MEM_Branch, MEM_Zero, PC_Src); //Zero && Branch
    
    Mux32Bit2To1            PCTarget(Imm_or_Rs, MEM_jumpRs, MEM_jumpImm, MEM_ALUSrc2); //imm or Rs TODO

                            //DataMemory(Address, WriteData, Clk, MemWrite, MemRead, Datatype, ReadData)
    DataMemory              Data_Memory(MEM_ALUResult, MEM_Data2, Clk, MEM_MemWrite, MEM_MemRead, MEM_Datatype, MemDataOut);
    
    
    //determine new pc
    Mux32Bit2To1            PC4_or_PC4Offset(PC4_or_PCoffset, PCAddResult, MEM_PCResult, PC_Src); //PC+4 or branch
    Mux32Bit2To1            NextPC(PC_in, PC4_or_PCoffset, Imm_or_Rs, MEM_Jump); //last choice or jump
      
    
    
    wire WB_MemtoReg, WB_Zero;
    wire [31:0] WB_ReadData, WB_ALUResult, WB_HI, WB_LO;
    wire [4:0] WB_RegDstData;
    wire [5:0] WB_func;
    

                            //MEM_WB_Reg(MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_ReadData, MEM_ALUResult, MEM_RegDstData, HI, LO,
                            //Clk, Clr, Ld,
                            //WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_ReadData, WB_ALUResult, WB_RegDstData, WB_HI, WB_LO);
    MEM_WB_Reg              MEM_WB(MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MemDataOut, MEM_ALUResult, MEM_RegDstData[4:0],
                                    Clk, Rst, 1'b1,
                                    WB_RegWrite1, WB_RegWrite2, WB_MemtoReg, WB_ReadData, WB_ALUResult, WB_RegDstData);
                                    
                                    
                                    
////////////////////WRITEBACK STAGE////////////////////////////////////////////////////
    wire WriteHILO;             /////////move to controller
    wire MEM_or_HILO;
    
   // Compare                 compareFunc(WB_func, WriteHILO, MEM_or_HILO);
    
   // wire[31:0] WB_Data2;
    //wire[31:0] MovnData, MovzData;
    
    // wire MOVN, MOVZ;
    
   /* ANDGate                 movn_gate(WB_Zero, MOVN, MovnData);
    ANDGate                 movz_gate(WB_Zero, MOVZ, MovzData);*/
    
    
    
    Mux32Bit2To1            WriteBackData(WB_Data, WB_ReadData, WB_ALUResult, WB_MemtoReg); //WB_Data2 = ReadData or ALUResult

    //feed WB_Data2 into mux to choose between it and PC+4 using jump signal

    
    
    //wire [31:0] HI_OR_LO;


    //Mux32Bit2To1            HI_or_LO(HI_OR_LO, WB_HI, WB_LO, WriteHILO);
    
    //Mux32Bit2To1            FinalWBData(WB_Data, WB_Data2, HI_OR_LO, MEM_or_HILO);
    

endmodule
