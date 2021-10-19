`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 03:33:45 PM
// Design Name: 
// Module Name: 32_bit_Adder
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


module 32_bit_Adder(A, B, Out);
    input [31:0] A;
    input [31:0] B;
    
    output reg [31:0] Out;
    
    always@(*) begin
        Out <= A + B;
    end
endmodule
