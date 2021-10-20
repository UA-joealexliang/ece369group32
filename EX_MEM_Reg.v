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
                  EX_Zero, EX_PCResult, EX_ALUResult, EX_Data2, EX_RegDstData, HI, LO, func, Jump, jumpImm, jumpRs,
                  
                  MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                  MEM_Branch, MEM_MemWrite, MEM_MemRead,
                  MEM_Zero, MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_RegDstData, MEM_HI, MEM_LO, func_out, Jump_out, MEM_jumpImm, MEM_jumpRs,
                  
                  Clk, Clr, Ld);
                  
        input EX_RegWrite, RegWrite2, EX_MemtoReg, 
              EX_Branch, EX_MemWrite, EX_MemRead,
              EX_Zero;
              
        input [31:0] EX_PCResult, EX_ALUResult, EX_Data2, HI, LO, jumpImm, jumpRs;
        input [4:0] EX_RegDstData;
        input [5:0] func;
        input [1:0] Jump;
        
        input Clk, Clr, Ld;
        
        output reg MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg,
                   MEM_Branch, MEM_MemWrite, MEM_MemRead,
                   MEM_Zero;
        
        output reg [31:0] MEM_PCResult, MEM_ALUResult, MEM_Data2, MEM_HI, MEM_LO, MEM_jumpImm, MEM_jumpRs;
        output reg [4:0] MEM_RegDstData;
        output reg [5:0] func_out;
        output reg [1:0] Jump_out;
        
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
                MEM_RegDstData <= 0;
                MEM_HI <= 0;
                MEM_LO <= 0;
                func_out <= 0;
                Jump_out <= 0;
                MEM_jumpImm <= 0;
                MEM_jumpRs <= 0;
            end
            else if(Ld == 1) begin
                MEM_RegWrite <= EX_RegWrite; 
                MEM_RegWrite <= RegWrite2;
                MEM_MemtoReg <= EX_MemtoReg;
                MEM_Branch <= EX_Branch; 
                MEM_MemWrite <= EX_MemWrite; 
                MEM_MemRead <= EX_MemRead;
                MEM_Zero <= EX_Zero;
                MEM_PCResult <= EX_PCResult; 
                MEM_ALUResult <= EX_ALUResult; 
                MEM_Data2 <= EX_Data2;
                MEM_RegDstData <= EX_RegDstData;
                MEM_HI <= HI;
                MEM_LO <= LO;
                func_out <= func;
                Jump_out <= Jump;
                MEM_jumpImm <= jumpImm;
                MEM_jumpRs <= jumpRs;
            end
                          
        end
endmodule
