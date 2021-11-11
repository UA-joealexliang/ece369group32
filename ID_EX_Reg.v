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

module ID_EX_Reg(
                ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult, ID_Instruction,
                ID_RegDst, ID_ALUSrc, ID_ALUControl, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, 
                ID_Jump, ID_ALUSrc2, ID_Datatype, ID_HiLoWrite,
                Clk, Rst, Ld, //these help separate inputs and outputs, each i/o is neatly mapped in order
                EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult, EX_Instruction,
                EX_RegDst, EX_ALUSrc, EX_ALUControl, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, 
                EX_Jump, EX_ALUSrc2, EX_Datatype, EX_HiLoWrite
                );
            
    input Clk, Rst, Ld;
    input [31:0] ID_ReadData1, ID_ReadData2, ID_SignExtended, ID_PCAddResult;
    input [31:0] ID_Instruction;
    input [4:0] ID_ALUControl;
    input [1:0] ID_RegDst, ID_Datatype, ID_HiLoWrite;
    input ID_ALUSrc, ID_MemWrite, ID_MemRead, ID_MemtoReg, ID_RegWrite, ID_Jump, ID_ALUSrc2;

    output reg [31:0] EX_ReadData1, EX_ReadData2, EX_SignExtended, EX_PCAddResult;
    output reg [31:0] EX_Instruction;
    output reg [4:0] EX_ALUControl;
    output reg [1:0] EX_RegDst, EX_Datatype, EX_HiLoWrite;
    output reg EX_ALUSrc, EX_MemWrite, EX_MemRead, EX_MemtoReg, EX_RegWrite, EX_Jump, EX_ALUSrc2;
    
    //write your code here
    always@(posedge Clk) begin
            if(Rst == 1 || Ld == 0) begin
                EX_ReadData1 <= 0; 
                EX_ReadData2 <= 0;  
                EX_SignExtended <= 0;  
                EX_PCAddResult <= 0;
                EX_Instruction <= 0; 
                EX_ALUControl <= 0; 
                EX_RegDst <= 0; 
                EX_Datatype <= 0; 
                EX_HiLoWrite <= 0; 
                EX_ALUSrc <= 0;  
                EX_MemWrite <= 0; 
                EX_MemRead <= 0; 
                EX_MemtoReg <= 0;  
                EX_RegWrite <= 0;  
                EX_Jump <= 0; 
                EX_ALUSrc2 <= 0; 
            end
            else if(Ld == 1) begin
                EX_ReadData1 <= ID_ReadData1; 
                EX_ReadData2 <= ID_ReadData2;  
                EX_SignExtended <= ID_SignExtended;  
                EX_PCAddResult <= ID_PCAddResult;
                EX_Instruction <= ID_Instruction; 
                EX_ALUControl <= ID_ALUControl; 
                EX_RegDst <= ID_RegDst; 
                EX_Datatype <= ID_Datatype; 
                EX_HiLoWrite <= ID_HiLoWrite; 
                EX_ALUSrc <= ID_ALUSrc; 
                EX_MemWrite <= ID_MemWrite; 
                EX_MemRead <= ID_MemRead; 
                EX_MemtoReg <= ID_MemtoReg;  
                EX_RegWrite <= ID_RegWrite;  
                EX_Jump <= ID_Jump; 
                EX_ALUSrc2 <= ID_ALUSrc2; 
            end
        end
endmodule