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


module MEM_WB_Reg(MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg, MEM_ReadData, MEM_ALUResult, MEM_RegDstData, HI, LO,
                    Clk, Clr, Ld,
                    WB_RegWrite, WB_RegWrite2, WB_MemtoReg, WB_ReadData, WB_ALUResult, WB_RegDstData, WB_HI, WB_LO);
        
        input MEM_RegWrite, MEM_RegWrite2, MEM_MemtoReg;
        input [31:0] MEM_ReadData, MEM_ALUResult, HI, LO;
        input [4:0] MEM_RegDstData;
        input Clk, Clr, Ld;
        
        output reg WB_RegWrite, WB_MemtoReg, WB_RegWrite2;
        output reg [31:0]  WB_ReadData, WB_ALUResult, WB_HI, WB_LO;
        output reg [4:0] WB_RegDstData;
                    
        always@(posedge Clk) begin
        
        if(Clr == 1) begin 
            WB_MemtoReg <= 0; 
            WB_RegWrite <= 0; 
            WB_RegWrite2 <= 0;
            WB_ALUResult <= 0; 
            WB_ReadData <= 0;
            WB_RegDstData <= 0;
            WB_HI <= 0;
            WB_LO <= 0;
        end
        else if(Ld == 1) begin
            WB_MemtoReg <= MEM_MemtoReg; 
            WB_RegWrite <= MEM_RegWrite; 
            WB_RegWrite2 <= MEM_RegWrite2;
            WB_ALUResult <= MEM_ALUResult; 
            WB_ReadData <= MEM_ReadData;
            WB_RegDstData <= MEM_RegDstData;
            WB_HI <= HI;
            WB_LO <= LO;
        end
                      
    end
endmodule
