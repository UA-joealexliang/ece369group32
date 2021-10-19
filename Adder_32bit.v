`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 03:35:47 PM
// Design Name: 
// Module Name: Adder_32bit
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


module Adder_32bit(A, B, Out);
    input [31:0] A;
    input [31:0] B;
    
    output reg [31:0] Out;
    
    always@(*) begin
        Out <= A + B;
    end
endmodule
