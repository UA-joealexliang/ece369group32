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


module EX_MEM_Reg(EX_RegWrite, RegWrite2, EX_MemtoReg, 
                  EX_Branch, EX_MemWrite, EX_MemRead,
                  EX_Zero, EXMEM_PC, EX_ALUResult, EX_Data2, EX_RegDst, Jump, jumpImm, jumpRs, Datatype, ALUSrc2, EX_PCResult, EX_Instruction20_16, EX_Instruction15_11
                  
                  MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                  MEM_Branch, MEM_MemWrite, MEM_MemRead,
                  MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDst, Jump_out, MEM_jumpImm, MEM_jumpRs, MEM_Datatype, MEM_ALUSrc2, MEM_PCAddResult, MEM_Instruction20_16, MEM_Instruction15_11,
                  
                  Clk, Clr, Ld);
        
        input [4:0] EX_Instruction20_16, EX_Instruction15_11;
        input EX_RegWrite, RegWrite2, EX_MemtoReg, 
              EX_Branch, EX_MemWrite, EX_MemRead,
              EX_Zero, ALUSrc2;
        input [1:0] Datatype;
              
        input [31:0] EXMEM_PC, EX_PCResult, EX_ALUResult, EX_Data2, jumpImm, jumpRs;
        input [1:0] EX_RegDst;
        input Jump;
        
        input Clk, Clr, Ld;
        
        output reg [4:0] MEM_Instruction20_16, MEM_Instruction15_11;
        output reg MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                   MEM_Branch, MEM_MemWrite, MEM_MemRead,
                   MEM_Zero, MEM_ALUSrc2;
        output reg [1:0] MEM_Datatype;
        
        output reg [31:0] MEM_PCResult, MEM_PCAddResult, MEM_ALUResult, MEM_Data2, MEM_jumpImm, MEM_jumpRs;
        output reg [1:0] MEM_RegDst;
        output reg Jump_out;
        
        always@(posedge Clk) begin
        
            if(Clr == 1) begin
                MEM_RegWrite <= 0; 
                MEM_RegWrite2 <= 0;
                MEM_MemtoReg <= 0;
                MEM_Branch <= 0; 
                MEM_MemWrite <= 0; 
                MEM_MemRead <= 0;
                MEM_Zero <= 0;
                MEM_PCResult <= 0; 
                MEM_ALUResult <= 0; 
                MEM_Data2 <= 0;
                MEM_RegDst <= 0;
                Jump_out <= 0;
                MEM_jumpImm <= 0;
                MEM_jumpRs <= 0;
                MEM_Datatype <= 0;
                MEM_ALUSrc2 <= 0;
                MEM_PCAddResult <= 0;
                MEM_Instruction20_16 <= 0;
                MEM_Instruction15_11 <= 0;
            end
            else if(Ld == 1) begin
                MEM_RegWrite <= EX_RegWrite; 
                MEM_RegWrite <= RegWrite2;
                MEM_MemtoReg <= EX_MemtoReg;
                MEM_Branch <= EX_Branch; 
                MEM_MemWrite <= EX_MemWrite; 
                MEM_MemRead <= EX_MemRead;
                MEM_Zero <= EX_Zero;
                MEM_PCResult <= EXMEM_PC; 
                MEM_ALUResult <= EX_ALUResult; 
                MEM_Data2 <= EX_Data2;
                MEM_RegDst <= EX_RegDst;
                Jump_out <= Jump;
                MEM_jumpImm <= jumpImm;
                MEM_jumpRs <= jumpRs;
                MEM_Datatype <= Datatype;
                MEM_ALUSrc2 <= ALUSrc2;
                MEM_PCAddResult <= EX_PCResult;
                MEM_Instruction20_16 <= EX_Instruction20_16;
                MEM_Instruction15_11 <= EX_Instruction15_11;
            end
                          
        end
endmodule