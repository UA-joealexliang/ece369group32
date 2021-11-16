`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 04:17:04 PM
// Design Name: 
// Module Name: IF_ID_Reg
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

module IF_ID_Reg(
                IF_Instruction, IF_PCAddResult, PCResult,
                Clk, Rst, Ld, 
                ID_Instruction, ID_PCAddResult, ID_PCResult
                );

    input Clk, Rst, Ld;
    input [31:0] IF_Instruction, IF_PCAddResult, PCResult;

    output reg [31:0] ID_Instruction, ID_PCAddResult, ID_PCResult;
    
    //write your code here
    always@(posedge Clk) begin
        if(Rst == 1 || Ld == 0) begin
            ID_PCResult <= 0;
            ID_PCAddResult <= 0;
            ID_Instruction <= 0;
        end
        else if(Ld == 1) begin
            ID_PCResult <= PCResult;
            ID_PCAddResult <= IF_PCAddResult;
            ID_Instruction <= IF_Instruction;
        end
    end
endmodule
