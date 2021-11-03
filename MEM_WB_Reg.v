`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 04:17:04 PM
// Design Name: 
// Module Name: MEM_WB_Reg
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


module MEM_WB_Reg(
                MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_MemDataOut, MEM_ALUResult, MEM_RegDst, MEM_Jump, MEM_PCAddResult,
                MEM_Instruction,
                Clk, Rst, Ld,
                WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_MemDataOut, WB_ALUResult, WB_RegDst, WB_Jump, WB_PCAddResult,
                WB_Instruction
                );
        
    input Clk, Rst, Ld;
    input MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_Jump;
    input [31:0] MEM_MemDataOut, MEM_ALUResult, MEM_PCAddResult;
    input [1:0] MEM_RegDst;
    input [31:0] MEM_Instruction;
        
    output reg WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_Jump;
    output reg [31:0] WB_MemDataOut, WB_ALUResult, WB_PCAddResult;
    output reg [1:0] WB_RegDst;
    output reg [31:0] WB_Instruction;
                    
    always@(posedge Clk) begin
        if(Rst == 1) begin 
            WB_RegWrite <= 0; 
            WB_RegWrite2 <= 0;
            WB_MemtoReg <= 0;
            WB_MemDataOut <= 0;
            WB_ALUResult <= 0; 
            WB_RegDst <= 0;
            WB_Jump <= 0;
            WB_PCAddResult <= 0;
            WB_Instruction <= 0;
        end
        else if(Ld == 1) begin
            WB_RegWrite <= MEM_RegWrite; 
            WB_RegWrite2 <= MEM_RegWrite2;
            WB_MemtoReg <= MEM_MemtoReg; 
            WB_MemDataOut <= MEM_MemDataOut;
            WB_ALUResult <= MEM_ALUResult; 
            WB_RegDst <= MEM_RegDst;
            WB_Jump <= MEM_Jump;
            WB_PCAddResult <= MEM_PCAddResult;
            WB_Instruction <= MEM_Instruction;
        end             
    end
endmodule
