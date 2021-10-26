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
    wire [31:0] PCResult;

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

    wire [31:0] EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult;
    wire [5:0] EX_Instruction31_26;
    wire [4:0] EX_Instruction20_16, EX_Instruction15_11, EX_ALUControl;
    wire [1:0] EX_RegDst, EX_Datatype, EX_HiLoWrite;
    wire EX_ALUSrc, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_Jump, EX_ALUSrc2;
    
    wire SignExtend; //is not fed into ID_EX_Reg
    wire [31:0] Imm_shifted; //is not fed into ID_EX_Reg
    wire [31:0] PCOffsetResult; //is not fed into ID_EX_Reg
    wire [31:0] PC4_or_PCoffset; //is not fed into MEM_WB_Reg
    wire [31:0] Rs_or_Imm; //is not fed into MEM_WB_Reg
    wire [31:0] Shifted_Imm; //imm shifted, not rs

    wire [31:0] ID_ALUSrc1Data, ID_ALUSrc2Data;
    wire Zero;

    //variables from EX_MEM_Reg
    wire EX_RegWrite2;
    wire [31:0] EX_ALUResult;
    
    wire MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemWrite, MEM_MemRead, MEM_Jump;
    wire [31:0] MEM_ALUResult, MEM_ReadData2, MEM_PCAddResult;
    wire [1:0] MEM_RegDst, MEM_Datatype;
    wire [4:0] MEM_Instruction20_16, MEM_Instruction15_11;

    wire [31:0] ALUSrc1Data, ALUSrc2Data; //is not fed into EX_MEM_Reg
    
    wire [31:0] HiALUOut, LoALUOut; //is not fed into EX_MEM_Reg
    (* mark_debug = "true" *) wire [31:0] HI_out, LO_out; //is not fed into EX_MEM_Reg
    
    //variables from MEM_WB_Reg
    wire [31:0] MEM_MemDataOut;
    wire [31:0] WriteDataIn, ReadDataOut;

    wire WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_Jump;
    wire [31:0] WB_MemDataOut, WB_ALUResult, WB_PCAddResult;
    wire [1:0] WB_RegDst;
    wire [4:0] WB_Instruction20_16, WB_Instruction15_11;

    (* mark_debug = "true" *) wire [31:0] WriteData; //is not fed into MEM_WB_Reg
    wire [31:0] RegDstData;
    wire [31:0] ALUResult_or_ReadData;

/////////////////INSTRUCTION FETCH STAGE///////////////////////////////////////////    
    
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
    IF_ID_Reg                 IF_ID_Reg(
                                        IF_Instruction, IF_PCAddResult, 
                                        Clk, Rst, 1'b1, 
                                        ID_Instruction, ID_PCAddResult
                                        );
    
/////////////////INSTRUCTION DECODE STAGE////////////////////////////////////////////
    
    /*ShiftLeft2              Shift_jr( ID_ReadData1, jump_rs);
    
    ShiftLeft2              Shift_jaddr(ID_Instruction[25:0], jump_imm);*/

                            /*Controller(
                                        Opcode, Bit21, Bit20_16, Bit10_6, funct, 
                                        RegDst, ALUSrc, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, 
                                        Branch, Jump, Datatype, ALUControl, SignExtend
                                        );*/
    Controller                Controller(
                                        ID_Instruction[31:26], ID_Instruction[21], ID_Instruction[20:16], ID_Instruction[10:6], ID_Instruction[5:0], 
                                        ID_RegDst, ID_ALUSrc, ID_ALUSrc2, ID_MemtoReg, ID_RegWrite, ID_HiLoWrite, ID_MemRead, ID_MemWrite, 
                                        ID_Branch, ID_Jump, ID_Datatype, ID_ALUControl, SignExtend
                                        );

    wire OrResult;
                            //ORGate(A, B, Out);
    ORGate                 ORGate(WB_RegWrite, WB_RegWrite2, OrResult);
                            //RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile            Registers(ID_Instruction[25:21], ID_Instruction[20:16], RegDstData, WriteData, OrResult, Clk,  ID_ReadData1,  ID_ReadData2);
    
                            //SignExtension(in, out, signOrZero);
    SignExtension           SignExtension(ID_Instruction[15:0],  ID_SignExtended, SignExtend);

                            /*ID_EX_Reg(
                                        ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult, ID_Instruction31_26, ID_Instruction20_16, ID_Instruction15_11,
                                        ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                                        ID_Jump, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                                        Clk, Rst, Ld, //these help separate inputs and outputs, each i/o is neatly mapped in order
                                        EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult, EX_Instruction31_26, EX_Instruction20_16, EX_Instruction15_11,
                                        EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                                        EX_Jump, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                                        );*/
    ID_EX_Reg                 ID_EX_Reg(
                                        ID_ReadData1,  ID_ReadData2,  ID_SignExtended, ID_PCAddResult, ID_Instruction[31:26], ID_Instruction[20:16], ID_Instruction[15:11],
                                        ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                                        ID_Jump, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                                        Clk, Rst, 1'b1, 
                                        EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult, EX_Instruction31_26, EX_Instruction20_16, EX_Instruction15_11,
                                        EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                                        EX_Jump, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                                        );

                            //ShiftLeft2(In, Out);
    ShiftLeft2              ShiftImm(ID_SignExtended, Imm_shifted); //Imm_shifted = ID_SignExtended*4

                            //Adder_32bit(A, B, Out);
    Adder_32bit             PCAdd(ID_PCAddResult, Imm_shifted, PCOffsetResult); //ID_PCAddResult + Imm_shifted  
    
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            ID_MuxALUinput1(ID_ALUSrc1Data, ID_ReadData1, ID_SignExtended, ID_ALUSrc2); //decides between rs and imm
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            ID_MuxALUinput2(ID_ALUSrc2Data, ID_ReadData2, ID_SignExtended, ID_ALUSrc); //decides between rt and imm

    ALU32BitBranch          ALU32BitBranch(ID_ALUControl, ID_ALUSrc1Data, ID_ALUSrc2Data, ID_Instruction[31:26], Zero);
//    ALU32BitBranch          ALU32BitBranch(EX_ALUControl, EX_ALUSrc1Data, EX_ALUSrc2Data, EX_Instruction31_26, Zero);

                            //ShiftLeft2(In, Out)
    ShiftLeft2              ShiftLeft2({27'd0, ID_Instruction[15:0]}, Shifted_Imm);

    wire AndResult;
    //ANDGate(A, B, Out);
    ANDGate                 ANDGate(ID_Branch, Zero, AndResult);

    //determine new pc
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            PC4_or_PC4Offset(PC4_or_PCoffset, ID_PCAddResult, PCOffsetResult, AndResult); //PC+4 or MEM_Branch
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            PCTarget(Rs_or_Imm, ID_ReadData1, Shifted_Imm, ID_ALUSrc2); //imm or Rs

                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            NextPC(PC_in, PC4_or_PCoffset, Rs_or_Imm, ID_Jump); //combination new mux to determine from last two muxes

////////////////////EXECUTION STAGE////////////////////////////////////////////////////        

                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            MuxALUinput1(ALUSrc1Data, EX_ReadData1, EX_SignExtended, EX_ALUSrc2); //decides between rs and imm
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            MuxALUinput2(ALUSrc2Data, EX_ReadData2, EX_SignExtended, EX_ALUSrc); //decides between rt and imm

                            //HI_Reg(in, out, Clk, Ld, Clr)
    HI_Reg                  HI_Reg(HiALUOut, HI_out, Clk, EX_HiLoWrite[0], Rst); 
                            //LO_Reg(in, out, Clk, Ld, Clr)
    LO_Reg                  LO_Reg(LoALUOut, LO_out, Clk, EX_HiLoWrite[1], Rst);

                            //ALU32Bit(ALUControl, A, B, Hi_in, Lo_in, Opcode, ALUResult, Hi, Lo, Zero, RegWrite2);
    ALU32Bit                ALU1(EX_ALUControl, ALUSrc1Data, ALUSrc2Data, HI_out, LO_out, EX_Instruction31_26, EX_ALUResult, HiALUOut, LoALUOut, EX_Zero, EX_RegWrite2);
    
                            /*EX_MEM_Reg(
                                    EX_RegWrite, EX_RegWrite2, EX_MemtoReg, 
                                    EX_MemWrite, EX_MemRead, EX_ALUResult, EX_ReadData2, EX_RegDst, 
                                    EX_Jump, EX_Datatype, EX_PCAddResult
                                    EX_Instruction20_16, EX_Instruction15_11,
                                    Clk, Rst, Ld,
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                                    MEM_MemWrite, MEM_MemRead, MEM_ALUResult, MEM_ReadData2, MEM_RegDst, 
                                    MEM_Jump, MEM_Datatype, MEM_PCAddResult, 
                                    MEM_Instruction20_16, MEM_Instruction15_11,
                                    );*/
    EX_MEM_Reg              EX_MEM_Reg(
                                    EX_RegWrite, EX_RegWrite2, EX_MemtoReg, 
                                    EX_MemWrite, EX_MemRead, EX_ALUResult, EX_ReadData2, EX_RegDst, 
                                    EX_Jump, EX_Datatype, EX_PCAddResult, 
                                    EX_Instruction20_16, EX_Instruction15_11,
                                    Clk, Rst, 1'b1,
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, 
                                    MEM_MemWrite, MEM_MemRead, MEM_ALUResult, MEM_ReadData2, MEM_RegDst, 
                                    MEM_Jump, MEM_Datatype, MEM_PCAddResult, 
                                    MEM_Instruction20_16, MEM_Instruction15_11,
                                    );
    
////////////////////MEMORY STAGE////////////////////////////////////////////////////

                            //DataMemoryInput(WriteDataIn, Datatype, WriteDataOut); 
    DataMemoryInput         Data_Memory_Input(MEM_ReadData2, MEM_Datatype, WriteDataIn);
    
                            //DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData)
    DataMemory              Data_Memory(MEM_ALUResult, WriteDataIn, Clk, MEM_MemWrite, MEM_MemRead, ReadDataOut);

    DataMemoryOutput        Data_Memory_Output(ReadDataOut, MEM_Datatype, MEM_MemDataOut);

                            /*MEM_WB_Reg(
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemDataOut, MEM_ALUResult, MEM_RegDst, MEM_Jump, MEM_PCAddResult,
                                    MEM_Instruction20_16, MEM_Instruction15_11,
                                    Clk, Rst, Ld,
                                    WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_MemDataOut, WB_ALUResult, WB_RegDst, WB_Jump, WB_PCAddResult,
                                    WB_Instruction20_16, WB_Instruction15_11
                                    );*/
    MEM_WB_Reg              MEM_WB_Reg(
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemDataOut, MEM_ALUResult, MEM_RegDst, MEM_Jump, MEM_PCAddResult,
                                    MEM_Instruction20_16, MEM_Instruction15_11,
                                    Clk, Rst, 1'b1,
                                    WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_MemDataOut, WB_ALUResult, WB_RegDst, WB_Jump, WB_PCAddResult,
                                    WB_Instruction20_16, WB_Instruction15_11
                                    );
                                                     
////////////////////WRITEBACK STAGE////////////////////////////////////////////////////

                            //Mux32Bit3To1(out, inA, inB, inC, sel);
    Mux32Bit3To1            MuxRegDst (RegDstData, {27'd0, WB_Instruction20_16}, {27'd0, WB_Instruction15_11}, 32'd31, WB_RegDst);
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            WriteBackData(ALUResult_or_ReadData, WB_ALUResult, WB_MemDataOut, WB_MemtoReg);
                            //Mux32Bit2To1(out, inA, inB, sel)
    Mux32Bit2To1            WriteBackJumpData(WriteData, ALUResult_or_ReadData, WB_PCAddResult, WB_Jump);

endmodule
