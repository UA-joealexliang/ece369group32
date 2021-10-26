`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 11:06:55 PM
// Design Name: 
// Module Name: ORGate
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


module ORGate(A, B, Out);
    input A, B;
    output reg Out;
    
    always@(*) begin
        Out <= A || B;
    end
endmodule