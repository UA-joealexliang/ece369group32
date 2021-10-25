`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 04:17:04 PM
// Design Name: 
// Module Name: EX_MEM_Reg
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


module EX_MEM_Reg(
                EX_RegWrite, EX_RegWrite2, EX_MemtoReg, 
                EX_MemWrite, EX_MemRead, EX_ALUResult, EX_ReadData2, EX_RegDst, 
                EX_Jump, EX_Datatype, EX_PCAddResult,
                EX_Instruction20_16, EX_Instruction15_11,
                Clk, Rst, Ld,
                MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                MEM_MemWrite, MEM_MemRead, MEM_ALUResult, MEM_ReadData2, MEM_RegDst, 
                MEM_Jump, MEM_Datatype, MEM_PCAddResult, 
                MEM_Instruction20_16, MEM_Instruction15_11,
                );
        
    input Clk, Rst, Ld;
    input EX_RegWrite, EX_RegWrite2, EX_MemtoReg, EX_MemWrite, EX_MemRead, EX_Jump;
    input [31:0] EX_ALUResult, EX_ReadData2, EX_PCAddResult;
    input [1:0] EX_RegDst, EX_Datatype;
    input [4:0] EX_Instruction20_16, EX_Instruction15_11;

    output reg MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemWrite, MEM_MemRead, MEM_Jump;
    output reg [31:0] MEM_ALUResult, MEM_ReadData2, MEM_PCAddResult;
    output reg [1:0] MEM_RegDst, MEM_Datatype;
    output reg [4:0] MEM_Instruction20_16, MEM_Instruction15_11;

    always@(posedge Clk) begin
        if(Rst == 1) begin
            MEM_RegWrite <= 0; 
            MEM_RegWrite2 <= 0;
            MEM_MemtoReg <= 0;
            MEM_MemWrite <= 0; 
            MEM_MemRead <= 0;
            MEM_ALUResult <= 0; 
            MEM_ReadData2 <= 0;
            MEM_RegDst <= 0;
            MEM_Jump <= 0;
            MEM_Datatype <= 0;
            MEM_PCAddResult <= 0;
            MEM_Instruction20_16 <= 0;
            MEM_Instruction15_11 <= 0;
        end
        else if(Ld == 1) begin
            MEM_RegWrite <= EX_RegWrite; 
            MEM_RegWrite2 <= EX_RegWrite2;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_MemWrite <= EX_MemWrite; 
            MEM_MemRead <= EX_MemRead;
            MEM_ALUResult <= EX_ALUResult; 
            MEM_ReadData2 <= EX_ReadData2;
            MEM_RegDst <= EX_RegDst;
            MEM_Jump <= EX_Jump;
            MEM_Datatype <= EX_Datatype;
            MEM_PCAddResult <= EX_PCAddResult;
            MEM_Instruction20_16 <= EX_Instruction20_16;
           MEM_Instruction15_11 <= EX_Instruction15_11;
        end           
    end
endmodule