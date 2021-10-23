`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 04:11:55 PM
// Design Name: 
// Module Name: ID_EX_Reg
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


module ID_EX_Reg(ReadData1_in, ReadData2_in, SignExtend_in, PCResult_in, Instruction31_26, Instruction20_16, Instruction15_11,
            RegDst, ALUSrc, ALUControl, Branch, MemWrite, MemRead, MemtoReg, RegWrite, Jump, jump_imm, jump_rs, ALUSrc2, Datatype,
            Clk, Clr, Ld, HI_LO_Write,
            ReadData1_out, ReadData2_out, SignExtend_out, PCResult_out, Instruction31_26_out, Instruction20_16_out, Instruction15_11_out,
            RegDst_out, ALUSrc_out, ALUControl_out, Branch_out, 
            MemWrite_out, MemRead_out, MemtoReg_out, RegWrite_out, Jump_out, EX_jumpImm, EX_jumpRs, EX_ALUSrc2, EX_Datatype, EX_HI_LO_Write);
            
    input Clk, Clr, Ld;
    input [31:0] ReadData1_in;
    input [31:0] ReadData2_in;
    input [31:0] SignExtend_in;
    input [31:0] PCResult_in, jump_imm, jump_rs;
    input [5:0] Instruction31_26;
    input [4:0] Instruction20_16;
    input [4:0] Instruction15_11;
    input Jump;
    input ALUSrc, ALUSrc2;
    input [4:0] ALUControl;
    input Branch, MemWrite, MemRead;
    input MemtoReg, RegWrite;
    input [1:0] Datatype, RegDst, HI_LO_Write;
    
    output reg ALUSrc_out, EX_ALUSrc2; 
    output reg [1:0] EX_Datatype, RegDst_out, EX_HI_LO_Write;
    output reg [4:0] ALUControl_out;
    output reg Branch_out, MemWrite_out, MemRead_out;
    output reg MemtoReg_out, RegWrite_out;
    
    output reg [31:0] ReadData1_out;
    output reg [31:0] ReadData2_out;
    output reg [31:0] SignExtend_out;
    output reg [31:0] PCResult_out, EX_jumpImm, EX_jumpRs;
    output reg [5:0] Instruction31_26_out;
    output reg [4:0] Instruction20_16_out;
    output reg [4:0] Instruction15_11_out;
    output reg Jump_out;
    
    
    
    //write your code here
    always@(posedge Clk) begin
        
            if(Clr == 1) begin
                RegDst_out <= 0;
                ALUSrc_out <= 0;
                ALUControl_out <= 0;
                
                ReadData1_out <= 0;
                ReadData2_out <= 0;
                SignExtend_out <= 0;
                PCResult_out <= 0;
                Instruction31_26_out <= 0;
                Instruction20_16_out <= 0;
                Instruction15_11_out <= 0;
                Jump_out <= 0;
                EX_jumpImm <= 0;
                EX_jumpRs <= 0;
                EX_ALUSrc2 <= 0;
                EX_Datatype <= 0;
                EX_HI_LO_Write <= 0;
            end
            else if(Ld == 1) begin
                RegDst_out <= RegDst;
                ALUSrc_out <= ALUSrc;
                ALUControl_out <= ALUControl;
                
                ReadData1_out <= ReadData1_in;
                ReadData2_out <= ReadData2_in;
                SignExtend_out <= SignExtend_in;
                PCResult_out <= PCResult_in;
                Instruction31_26_out <= Instruction31_26;
                Instruction20_16_out <= Instruction20_16;
                Instruction15_11_out <= Instruction15_11;
                Jump_out <= Jump;
                EX_jumpImm <= jump_imm;
                EX_jumpRs <= jump_rs;
                EX_ALUSrc2 <= ALUSrc2;
                EX_Datatype <= Datatype;
                EX_HI_LO_Write <= HI_LO_Write;
            end
            
        end
endmodule
