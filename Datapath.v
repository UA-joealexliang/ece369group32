`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// LAB GROUP 32
//      CAMERON MATSUMOTO, ASHTON ROWE, JOE LIANG
//      
//      PERCENT EFFORT:
//          CAMERON 33%     ASHTON 33%      JOE 33%
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath(Clk, Rst, PCResult, WriteData);
    input Clk, Rst;

    //variables from Program Counter
    wire [31:0] PC_in;
    output [31:0] PCResult;

    //variables from IF_ID_Reg
    wire [31:0] IF_Instruction; 
    wire [31:0] IF_PCAddResult;
    wire [31:0] ID_Instruction;

    //variables from ID_EX_Reg
    wire [31:0] ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult;
    wire [4:0] ID_ALUControl;
    wire [1:0] ID_RegDst, ID_Datatype, ID_HiLoWrite;
    wire ID_ALUSrc, ID_Branch, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, ID_Jump, ID_ALUSrc2;
    wire FlushSignal;

    wire [31:0] EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult;
    wire[31:0] EX_Instruction;
    wire [4:0] EX_ALUControl;
    wire [1:0] EX_RegDst, EX_Datatype, EX_HiLoWrite;
    wire EX_ALUSrc, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_Jump, EX_ALUSrc2;
    
    wire SignExtend; //is not fed into ID_EX_Reg
    wire [31:0] Imm_shifted; //is not fed into ID_EX_Reg
    wire [31:0] PCOffsetResult; //is not fed into ID_EX_Reg
    wire [31:0] PC4_or_PCoffset; //is not fed into MEM_WB_Reg
    wire [31:0] Rs_or_Imm; //is not fed into MEM_WB_Reg
    //wire [31:0] Shifted_Imm; //imm shifted, not rs

    wire [31:0] ID_ALUSrc1Data, ID_ALUSrc2Data;
    wire Zero;

    //variables from EX_MEM_Reg
    wire EX_RegWrite2;
    wire [31:0] EX_ALUResult;
    
    wire MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemWrite, MEM_MemRead, MEM_Jump;
    wire [31:0] MEM_ALUResult, MEM_ReadData2, MEM_PCAddResult;
    wire [1:0] MEM_RegDst, MEM_Datatype;
    wire [31:0] MEM_Instruction;

    wire [31:0] ALUSrc1Data, ALUSrc2Data; //is not fed into EX_MEM_Reg
    
    wire [31:0] HiALUOut, LoALUOut; //is not fed into EX_MEM_Reg
    
    wire [31:0] HI_out, LO_out; //is not fed into EX_MEM_Reg
    
    //variables from MEM_WB_Reg
    wire [31:0] MEM_MemDataOut;
    //wire [31:0] WriteDataIn, ReadDataOut;

    wire WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_Jump;
    wire [31:0] WB_MemDataOut, WB_ALUResult, WB_PCAddResult;
    wire [1:0] WB_RegDst;
    wire [31:0] WB_Instruction;

    output [31:0] WriteData; //is not fed into MEM_WB_Reg
    
    wire [31:0] RegDstData;
    wire [31:0] ALUResult_or_ReadData;

/////////////////INSTRUCTION FETCH STAGE///////////////////////////////////////////    
    
    //InstructionFetchUnit    IF(IF_Instruction, PCResult, IF_PCAddResult, Rst, Clk);
    
                           //ProgramCounter(Address, PCResult, Reset, Clk);
                           //PCResult = PC_in if Rst == 0
    ProgramCounter         ProgramCounter(PC_in, PCResult, Rst, Clk);  // muxes for input occur in MEM stage                       
                           
                           //Adder_32bit(A, B, Out);
                           //IF_PCAddResult = PCResult + 4
    Adder_32bit            PCAdder(PCResult, 32'd4, IF_PCAddResult); 
    
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

                          /*Hazard(
                                   ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, IF_ID_Rt, ID_EX_Rt, EX_MEM_Rt, 
                                   ID_EX_RegWrite, EX_MEM_RegWrite, ID_EX_RegDst, EX_MEM_RegDst, ID_EX_MemWrite, EX_MEM_MemWrite, IF_ID_ALUSrc, IF_ID_MemWrite, IF_ID_Jump, 
                                   FlushSignal,
                                   MEM_WB_Rd, MEM_WB_Rt,
                                   MEM_WB_RegWrite, MEM_WB_RegDst
                                   );*/                                   
    Hazard                  Hazard(
                                   EX_Instruction[15:11], MEM_Instruction[15:11], ID_Instruction[25:21], ID_Instruction[20:16], EX_Instruction[20:16], MEM_Instruction[20:16], 
                                   EX_RegWrite, MEM_RegWrite, EX_RegDst, MEM_RegDst, EX_MemWrite, MEM_MemWrite, ID_ALUSrc, ID_MemWrite, ID_Jump, 
                                   FlushSignal,
                                   WB_Instruction[15:11], WB_Instruction[20:16], 
                                   WB_RegWrite, WB_RegDst, 
                                   );

                            /*Controller(
                                        Opcode, Bit21, Bit20_16, Bit10_6, funct,
                                        RegDst, ALUSrc, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, 
                                        Branch, Jump, Datatype, ALUControl, SignExtend, index, RegisterTypes
                                        );*/
    wire index15_0or10_6;
    wire [3:0] RegisterTypes;
    Controller                Controller(
                                        ID_Instruction[31:26], ID_Instruction[21], ID_Instruction[20:16], ID_Instruction[10:6], ID_Instruction[5:0],
                                        ID_RegDst, ID_ALUSrc, ID_ALUSrc2, ID_MemtoReg, ID_RegWrite, ID_HiLoWrite, ID_MemRead, ID_MemWrite, 
                                        ID_Branch, ID_Jump, ID_Datatype, ID_ALUControl, SignExtend, index15_0or10_6, RegisterTypes
                                        );

    wire OrResult;
                            //ORGate(A, B, Out);
                            //WB_RegWrite or WB_RegWrite2 need to be 1 to write into registers
    ORGate                  ORGate(WB_RegWrite, WB_RegWrite2, OrResult);

                            //RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile            Registers(ID_Instruction[25:21], ID_Instruction[20:16], RegDstData[4:0], WriteData, OrResult, Clk, ID_ReadData1, ID_ReadData2);
    
    wire [31:0] chosen_Imm;
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //chooses between 15:0 imm vs 10:6 imm for shifts
    Mux32Bit2To1            chooseindex(chosen_Imm, {16'd0, ID_Instruction[15:0]}, {27'd0, ID_Instruction[10:6]}, index15_0or10_6);
                            
                            //SignExtension(in, out, signOrZero);
                            //Sign Extend or Zero Extend
    SignExtension           SignExtension(chosen_Imm[15:0], ID_SignExtended, SignExtend);

                            /*ID_EX_Reg(
                                        ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult, ID_Instruction,
                                        ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                                        ID_Jump, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                                        Clk, Rst, Ld, //these help separate inputs and outputs, each i/o is neatly mapped in order
                                        EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult, EX_Instruction,
                                        EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                                        EX_Jump, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                                        );*/
    ID_EX_Reg                 ID_EX_Reg(
                                        ID_ReadData1,  ID_ReadData2,  ID_SignExtended, ID_PCAddResult, ID_Instruction,
                                        ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                                        ID_Jump, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                                        Clk, Rst, ~(FlushSignal), 
                                        EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult, EX_Instruction,
                                        EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                                        EX_Jump, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                                        );

                            //ShiftLeft2(In, Out);
                            //shift Imm for branch offsets
    ShiftLeft2              ShiftImm(ID_SignExtended, Imm_shifted); //Imm_shifted = ID_SignExtended*4

                            //Adder_32bit(A, B, Out);
                            //used to add immediate offset to PC+4 (for branch offset)
    Adder_32bit             PCAdd(ID_PCAddResult, Imm_shifted, PCOffsetResult);  
    
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //decides between rs and imm
    Mux32Bit2To1            ID_MuxALUinput1(ID_ALUSrc1Data, ID_ReadData1, ID_SignExtended, ID_ALUSrc2); 
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //decides between rt and imm
    Mux32Bit2To1            ID_MuxALUinput2(ID_ALUSrc2Data, ID_ReadData2, ID_SignExtended, ID_ALUSrc); 

                            //ALU32BitBranch(ALUControl, A, B, Opcode, Zero);
    ALU32BitBranch          ALU32BitBranch(ID_ALUControl, ID_ALUSrc1Data, ID_ALUSrc2Data, ID_Instruction[31:26], Zero);

    wire [31:0] Shifted_Jump;
                            //ShiftLeft2(In, Out)
                            //sign extends 25:0 for jumps
    ShiftLeft2              ShiftLeft2_Jump({6'd0, ID_Instruction[25:0]}, Shifted_Jump); //for jumps

    wire AndResult;
                            //ANDGate(A, B, Out);
    ANDGate                 ANDGate(ID_Branch, Zero, AndResult);

    //determine new pc
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //used to determine ID_PCAddResult (PC+4) or PCOffsetResult (branch success) based on AndResult
    Mux32Bit2To1            PC4_or_PC4Offset(PC4_or_PCoffset, ID_PCAddResult, PCOffsetResult, AndResult); //PC+4 or MEM_Branch
                            
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //used to determine ID_ReadData1 (rs for jr) or Shifted_Jump (j and jal) based on Rs_or_Imm
    Mux32Bit2To1            PCTarget(Rs_or_Imm, ID_ReadData1, Shifted_Jump, ID_ALUSrc2); //imm or Rs

    wire [31:0] NextPC_Out;
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //used to determine PC4_or_PCoffset or Rs_or_Imm based on ID_Jump
    Mux32Bit2To1            NextPC(NextPC_Out, PC4_or_PCoffset, Rs_or_Imm, ID_Jump); //combination new mux to determine from last two muxes

                            //Mux32Bit2To1(out, inA, inB, sel)
                            //used to determine NextPC_Out or PCResult based on FlushSignal
    Mux32Bit2To1            NextPC_or_CurrentPC(PC_in, NextPC_Out, PCResult, FlushSignal); //determines whether to go to new PC or stall

////////////////////EXECUTION STAGE////////////////////////////////////////////////////        

                            //Mux32Bit2To1(out, inA, inB, sel)
                            //decides between rs and imm
    Mux32Bit2To1            EX_MuxALUinput1(ALUSrc1Data, EX_ReadData1, EX_SignExtended, EX_ALUSrc2); 
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //decides between rt and imm
    Mux32Bit2To1            EX_MuxALUinput2(ALUSrc2Data, EX_ReadData2, EX_SignExtended, EX_ALUSrc); 

                            //HI_Reg(in, out, Clk, Ld, Clr)
    HI_Reg                  HI_Reg(HiALUOut, HI_out, Clk, EX_HiLoWrite[0], Rst); 
                            //LO_Reg(in, out, Clk, Ld, Clr)
    LO_Reg                  LO_Reg(LoALUOut, LO_out, Clk, EX_HiLoWrite[1], Rst);

                            //ALU32Bit(ALUControl, A, B, Hi_in, Lo_in, Opcode, ALUResult, Hi, Lo, Zero, RegWrite2);
    ALU32Bit                EX_ALU(EX_ALUControl, ALUSrc1Data, ALUSrc2Data, HI_out, LO_out, EX_Instruction[31:26], EX_ALUResult, HiALUOut, LoALUOut, EX_Zero, EX_RegWrite2);
    
                            /*EX_MEM_Reg(
                                    EX_RegWrite, EX_RegWrite2, EX_MemtoReg, 
                                    EX_MemWrite, EX_MemRead, EX_ALUResult, EX_ReadData2, EX_RegDst, 
                                    EX_Jump, EX_Datatype, EX_PCAddResult
                                    EX_Instruction,
                                    Clk, Rst, Ld,
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                                    MEM_MemWrite, MEM_MemRead, MEM_ALUResult, MEM_ReadData2, MEM_RegDst, 
                                    MEM_Jump, MEM_Datatype, MEM_PCAddResult, 
                                    MEM_Instruction
                                    );*/
    EX_MEM_Reg              EX_MEM_Reg(
                                    EX_RegWrite, EX_RegWrite2, EX_MemtoReg, 
                                    EX_MemWrite, EX_MemRead, EX_ALUResult, EX_ReadData2, EX_RegDst, 
                                    EX_Jump, EX_Datatype, EX_PCAddResult, 
                                    EX_Instruction,
                                    Clk, Rst, 1'b1,
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, 
                                    MEM_MemWrite, MEM_MemRead, MEM_ALUResult, MEM_ReadData2, MEM_RegDst, 
                                    MEM_Jump, MEM_Datatype, MEM_PCAddResult, 
                                    MEM_Instruction
                                    );
    
////////////////////MEMORY STAGE////////////////////////////////////////////////////

                            //DataMemory(Address, WriteData, Clk, MemWrite, MemRead, Datatype, ReadData);
    DataMemory              DataMemory(MEM_ALUResult, MEM_ReadData2, Clk, MEM_MemWrite, MEM_MemRead, MEM_Datatype, MEM_MemDataOut);                        
    
                            /*MEM_WB_Reg(
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemDataOut, MEM_ALUResult, MEM_RegDst, MEM_Jump, MEM_PCAddResult,
                                    MEM_Instruction,
                                    Clk, Rst, Ld,
                                    WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_MemDataOut, WB_ALUResult, WB_RegDst, WB_Jump, WB_PCAddResult,
                                    WB_Instruction
                                    );*/
    MEM_WB_Reg              MEM_WB_Reg(
                                    MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemDataOut, MEM_ALUResult, MEM_RegDst, MEM_Jump, MEM_PCAddResult,
                                    MEM_Instruction,
                                    Clk, Rst, 1'b1,
                                    WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_MemDataOut, WB_ALUResult, WB_RegDst, WB_Jump, WB_PCAddResult,
                                    WB_Instruction
                                    );
                                                     
////////////////////WRITEBACK STAGE////////////////////////////////////////////////////

                            //Mux32Bit3To1(out, inA, inB, inC, sel);
                            //determines rt, rd or $31 for WB address
    Mux32Bit3To1            MuxRegDst(RegDstData, {27'd0, WB_Instruction[20:16]}, {27'd0, WB_Instruction[15:11]}, 32'd31, WB_RegDst);
                            
                            //Mux32Bit2To1(out, inA, inB, sel)
                            //determines ALUResult or MemDataOut based on MemtoReg
    Mux32Bit2To1            WriteBackData(ALUResult_or_ReadData, WB_ALUResult, WB_MemDataOut, WB_MemtoReg);

                            //Mux32Bit2To1(out, inA, inB, sel)
                            //determines final write: normal ALUResult_or_ReadData or jr PCAddResult based on Jump
    Mux32Bit2To1            WriteBackJumpData(WriteData, ALUResult_or_ReadData, WB_PCAddResult, WB_Jump);

endmodule
