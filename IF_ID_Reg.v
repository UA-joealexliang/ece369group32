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
            IF_Instruction, IF_PCAddResult, 
            Clk, Rst, Ld, 
            ID_Instruction, ID_PCAddResult, 
            );

    input Clk, Rst, Ld;
    input [31:0] IF_Instruction, IF_PCAddResult;

    //reg [63:0] R;

    output reg [31:0] ID_Instruction, ID_PCAddResult;
    
    //write your code here
    always@(posedge Clk) begin
        if(Clr == 1) begin
            R <= 0;
        end
        else if(Ld == 1) begin
            ID_PCAddResult <= IF_PCAddResult;
            ID_Instruction <= IF_Instruction;
        end
        /*else begin
            R <= R;
        end*/
    end
endmodule
