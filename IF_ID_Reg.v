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


module IF_ID_Reg(Instruction_in, PCResult_in, Clk, Clr, Ld, Instruction_out, PCResult_out);
    input Clk, Clr, Ld;
    input [31:0] Instruction_in;
    input [31:0] PCResult_in;
    
    reg [63:0] R;
    
    output reg [31:0] Instruction_out;
    output reg [31:0] PCResult_out;
    
    //write your code here
    always@(posedge Clk) begin
        
            if(Clr == 1) begin
                R <= 0;
            end
            else if(Ld == 1) begin
                R[63:32] <= PCResult_in;
                R[31:0] <= Instruction_in;
            end
            else
                R <= R;
        end
   
endmodule
