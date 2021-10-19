`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 04:34:05 PM
// Design Name: 
// Module Name: ANDGate
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


module ANDGate(A, B, Out);
    input A, B;
    output reg Out;
    
    always@(*) begin
        Out <= A & B;
    end
endmodule
