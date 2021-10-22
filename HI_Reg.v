`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2021 04:22:16 PM
// Design Name: 
// Module Name: HI_Reg
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


module HI_Reg(in, out, Clk, Ld, Clr);

    input [31:0] in;
    input Clk, Ld, Clr;
    
    reg [31:0] register;
    
    output reg [31:0] out;
    
    always@(posedge Clk) begin
        if(Clr == 1) begin
            out <= 0;
        end
        
        else if(Ld == 1) begin
            register <= in;
        end
        
        else if(Ld == 0) begin
            out <= register;
        end
    end
endmodule
