`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// LAB GROUP 32
//      CAMERON MATSUMOTO, ASHTON ROWE, JOE LIANG
//      
//      PERCENT EFFORT:
//          CAMERON 33%     ASHTON 33%      JOE 33%
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath(Clk, Rst);
    input Clk, Rst;

    //variables from Program Counter
    wire [31:0] PC_in;
    wie [31:0] PCResult;

    //variables from IF_ID_Reg
    wire [31:0] IF_Instruction; 
    wire [31:0] IF_PCAddResult;
    wire [31:0] ID_Instruction;

    //variables from ID_EX_Reg
    wire [31:0] ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult;
    wire [5:0] ID_Instruction31_26;
    wire [4:0] ID_Instruction20_16, ID_Instruction15_11, ID_ALUControl;
    wire [1:0] ID_RegDst, ID_Datatype, ID_HiLoWrite;
    wire ID_ALUSrc, ID_Branch, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, ID_Jump, ID_ALUSrc2;
    wire [31:0] ID_jumpImm, ID_jumpRs; //MAY HAVE TO CHANGE HOW JUMPS WORK LATER

    wire [31:0] EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCResult;
    wire [5:0] EX_Instruction31_26;
    wire [4:0] EX_Instruction20_16, EX_Instruction15_11, EX_ALUControl;
    wire [1:0] EX_RegDst, EX_Datatype, EX_HiLoWrite;
    wire EX_ALUSrc, EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_Jump, EX_ALUSrc2;
    wire [31:0] EX_jumpImm, EX_jumpRs; //MAY HAVE TO CHANGE HOW JUMPS WORK LATER
    
    wire SignExtend; //is not fed into ID_EX_Reg
    
/////////////////INSTRUCTION FETCH STAGE///////////////////////////////////////////    
    
    
    wire [31:0] PC4_or_PCoffset; //redo
    
    //InstructionFetchUnit    IF(IF_Instruction, PCResult, IF_PCAddResult, Rst, Clk);
    
                           //ProgramCounter(Address, PCResult, Reset, Clk);
    ProgramCounter         ProgramCounter(PC_in, PCResult, Rst, Clk); //PCResult = PC_in if Rst == 0 // muxes for input occur in MEM stage                       
                           
                           //Adder_32bit(A, B, Out);
    Adder_32bit            PCAdder(PCResult, 32'd4, IF_PCAddResult); //IF_PCAddResult = PCResult + 4
    
                           //InstructionMemory(Address, Instruction);
    InstructionMemory      InstructionMemory(PCResult, IF_Instruction);

                            /*IF_ID_Reg(
                            IF_Instruction, IF_PCAddResult, 
                            Clk, Rst, Ld, 
                            ID_Instruction, ID_PCAddResult, 
                            );*/
    IF_ID_Reg               IF_ID_Reg(
                            IF_Instruction, IF_PCAddResult, 
                            Clk, Rst, 1'b1, 
                            ID_Instruction, ID_PCAddResult
                            );
    
/////////////////INSTRUCTION DECODE STAGE////////////////////////////////////////////
   
    wire WB_RegWrite1, WB_RegWrite2; //redo
    (* mark_debug = "true" *) wire [31:0] WB_Data; //redo
    
    /*ShiftLeft2              Shift_jr( ID_ReadData1, jump_rs);
    
    ShiftLeft2              Shift_jaddr(ID_Instruction[25:0], jump_imm);*/

                            /*Controller(
                            Opcode, Bit21, Bit20_16, Bit10_6, funct, 
                            RegDst, ALUSrc, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, 
                            Branch, Jump, Datatype, ALUControl, SignExtend
                            );*/
    Controller              Controller(
                            ID_Instruction[31:26], ID_Instruction[21], ID_Instruction[20:16], ID_Instruction[10:6], ID_Instruction[5:0], 
                            ID_RegDst, ID_ALUSrc, ID_ALUSrc2, ID_MemtoReg, ID_RegWrite, ID_HiLoWrite, ID_MemRead, ID_MemWrite, 
                            ID_Branch, ID_Jump, ID_Datatype, ID_ALUControl, SignExtend
                            );
                                
    wire [31:0] regWriteAddr; //redo

                            //RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile            Registers(ID_Instruction[25:21], ID_Instruction[20:16], RegDstData, WB_Data, WB_RegWrite1 | WB_RegWrite2, Clk,  ID_ReadData1,  ID_ReadData2);
    
                            //SignExtension(in, out, signOrZero);
    SignExtension           SignExtension(ID_Instruction[15:0],  ID_SignExtended, SignExtend);

                            /*module ID_EX_Reg(
                            ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult, ID_Instruction31_26, ID_Instruction20_16, ID_Instruction15_11,
                            ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_Branch, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                            ID_Jump, ID_jumpImm, ID_jumpRs, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                            Clk, Rst, Ld, //these help separate inputs and outputs, each i/o is neatly mapped in order
                            EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCResult, EX_Instruction31_26, EX_Instruction20_16, EX_Instruction15_11,
                            EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                            EX_Jump, EX_jumpImm, EX_jumpRs, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                            );*/
    ID_EX_Reg               ID_EX_Reg(
                            ID_ReadData1,  ID_ReadData2,  ID_SignExtended, ID_PCAddResult, ID_Instruction[31:26], ID_Instruction[20:16], ID_Instruction[15:11],
                            ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_Branch, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                            ID_Jump, {16'd0,ID_Instruction[15:0]}, ID_ReadData1, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                            Clk, Rst, 1'b1, 
                            EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCResult, EX_Instruction31_26, EX_Instruction20_16, EX_Instruction15_11,
                            EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_Branch, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                            EX_Jump, EX_jumpImm, EX_jumpRs, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                            );
    
////////////////////EXECUTION STAGE////////////////////////////////////////////////////
    //wires coming from IDEX
    wire [31:0] EX_PCOffsetResult; //good, move up
    wire [31:0] ALUSrc1Data, ALUSrc2Data;
    
    wire [31:0] Imm_shifted; //good, move up

                            //ShiftLeft2(In, Out);
    ShiftLeft2              ShiftImm(EX_SignExtended, Imm_shifted);

                            //Adder_32bit(A, B, Out);
    Adder_32bit             PCAdd (EX_PCResult, Imm_shifted, EX_PCOffsetResult); //EX_PCResult + Imm_shifted
    
    Mux32Bit2To1            MuxALUinput1(ALUSrc1Data, EX_ReadData1, EX_SignExtended, EX_ALUSrc2); //decides between rs and imm
    Mux32Bit2To1            MuxALUinput2(ALUSrc2Data, EX_ReadData2, EX_SignExtended, EX_ALUSrc); //decides between rt and imm

    wire EX_Zero, RegWrite2; 
    wire [31:0] EX_ALUResult; //good, move up
    wire [31:0] HiALUOut, LoALUOut; //good, move up
   
    wire [31:0] inputHI, inputLO; 
    (* mark_debug = "true" *) wire [31:0] Hi_out, Lo_out; //good, move up
    wire HI_Src, LO_Src;
     
    wire [31:0] HI_out, LO_out; //good, move up

                            //HI_Reg(in, out, Clk, Ld, Clr)
    HI_Reg                  HI_Reg (HiALUOut, HI_out, Clk, EX_HiLoWrite[0], Rst); 
                            //LO_Reg(in, out, Clk, Ld, Clr)
    LO_Reg                  LO_Reg (LoALUOut, LO_out, Clk, EX_HiLoWrite[1], Rst);

    
/////////hi and lo in     
                            //ALU32Bit(ALUControl, A, B, Hi_in, Lo_in, Opcode, ALUResult, Hi, Lo, Zero, RegWrite2);
    ALU32Bit                ALU1  (EX_ALUControl, ALUSrc1Data, ALUSrc2Data, HI_out, LO_out, EX_Instruction31_26, EX_ALUResult, HiALUOut, LoALUOut, EX_Zero, RegWrite2);
    wire [1:0] WB_RegDst;
    Mux32Bit3To1            MuxRegDst (RegDstData, {27'd0, WB_Instruction20_16}, {27'd0, WB_Instruction15_11}, 32'd31, WB_RegDst);
    
    //outputs of the EXMEM Pipeline Register
    wire [31:0] MEM_PCResult, MEM_PCAddResult;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_Data2;
    wire [1:0] MEM_RegDst;
    //wire [31:0] MEM_RegDstData;
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
    wire [4:0]  MEM_Instruction20_16, MEM_Instruction15_11;
    
//                          EX_MEM_Reg(EX_RegWrite, RegWrite2, EX_MemtoReg, 
//                                     EX_Branch, EX_MemWrite, EX_MemRead,
//                                     EX_Zero, EX_PCOffsetResult, EX_ALUResult, EX_Data2, EX_RegDst, ID_Jump, jumpImm, jumpRs, ID_Datatype, ID_ALUSrc2, EX_PCResult, EX_Instruction20_16, EX_Instruction15_11,
//                                            
//                                     MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
//                                     MEM_Branch, MEM_MemWrite, MEM_MemRead,
//                                     MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDst, Jump_out, MEM_jumpImm, MEM_jumpRs, MEM_Datatype, MEM_ALUSrc2, MEM_PCAddResult, MEM_Instruction20_16, MEM_Instruction15_11,
//                                            
//                                     Clk, Clr, Ld);
    EX_MEM_Reg              EX_MEM (EX_RegWrite, RegWrite2, EX_MemtoReg, EX_Branch, EX_MemWrite, EX_MemRead,
                                    EX_Zero, EX_PCOffsetResult, EX_ALUResult, EX_ReadData2, EX_RegDst, EX_Jump, EX_jumpImm, EX_jumpRs, EX_Datatype, EX_ALUSrc2, EX_PCResult, EX_Instruction20_16, EX_Instruction15_11,
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_Branch, MEM_MemWrite, MEM_MemRead,
                                    MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDst, MEM_Jump, MEM_jumpImm, MEM_jumpRs, MEM_Datatype, MEM_ALUSrc2, MEM_PCAddResult, MEM_Instruction20_16, MEM_Instruction15_11,
                                    Clk, Rst, 1'b1 );
    
    
////////////////////MEMORY STAGE////////////////////////////////////////////////////

    wire PC_Src;
    wire [31:0] MemDataOut;
    wire [31:0] Imm_or_Rs;
    
    ANDGate                 AND_Branch(MEM_Branch, MEM_Zero, PC_Src); //EX_Zero && ID_Branch
    
    Mux32Bit2To1            PCTarget(Imm_or_Rs, MEM_jumpRs, MEM_jumpImm, MEM_ALUSrc2); //imm or Rs TODO

                            //DataMemory(Address, WriteData, Clk, ID_MemWrite, ID_MemRead, ID_Datatype, ReadData)
    DataMemory              Data_Memory(MEM_ALUResult, MEM_Data2, Clk, MEM_MemWrite, MEM_MemRead, MEM_Datatype, MemDataOut);
    
    
    //determine new pc
    Mux32Bit2To1            PC4_or_PC4Offset(PC4_or_PCoffset, MEM_PCAddResult, MEM_PCResult, PC_Src); //PC+4 or ID_Branch
    Mux32Bit2To1            NextPC(PC_in, PC4_or_PCoffset, Imm_or_Rs, MEM_Jump); //last choice or ID_Jump
      
    
    
    wire WB_MemtoReg, WB_Zero;
    wire [31:0] WB_ReadData, WB_ALUResult, WB_HI, WB_LO;
    
    wire [5:0] WB_func;
    wire [4:0] WB_Instruction20_16, WB_Instruction15_11;

                            //MEM_WB_Reg(MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_ReadData, MEM_ALUResult, MEM_RegDstData, HI, LO,
                            //Clk, Clr, Ld,
                            //WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_ReadData, WB_ALUResult, WB_RegDstData, WB_HI, WB_LO);
    MEM_WB_Reg              MEM_WB(MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MemDataOut, MEM_ALUResult, MEM_RegDst, MEM_Instruction20_16, MEM_Instruction15_11,
                                    Clk, Rst, 1'b1,
                                    WB_RegWrite1, WB_RegWrite2, WB_MemtoReg, WB_ReadData, WB_ALUResult, WB_RegDst, WB_Instruction20_16, WB_Instruction15_11);
                                    
                                    
                                    
////////////////////WRITEBACK STAGE////////////////////////////////////////////////////
    wire WriteHILO;             /////////move to controller
    wire MEM_or_HILO;
    
   // Compare                 compareFunc(WB_func, WriteHILO, MEM_or_HILO);
    
   // wire[31:0] WB_Data2;
    //wire[31:0] MovnData, MovzData;
    
    // wire MOVN, MOVZ;
    
   /* ANDGate                 movn_gate(WB_Zero, MOVN, MovnData);
    ANDGate                 movz_gate(WB_Zero, MOVZ, MovzData);*/
    
    
    
    Mux32Bit2To1            WriteBackData(WB_Data, WB_ReadData, WB_ALUResult, WB_MemtoReg); //WB_Data2 = ReadData or EX_ALUResult

    //feed WB_Data2 into mux to choose between it and PC+4 using ID_Jump signal

    
    
    //wire [31:0] HI_OR_LO;


    //Mux32Bit2To1            HI_or_LO(HI_OR_LO, WB_HI, WB_LO, WriteHILO);
    
    //Mux32Bit2To1            FinalWBData(WB_Data, WB_Data2, HI_OR_LO, MEM_or_HILO);
    

endmodule
