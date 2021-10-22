`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2021 03:53:20 PM
// Design Name: 
// Module Name: Datapath_tb
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


module Datapath_tb();

    reg Clk, Rst;
    wire [31:0] PCResult;
    
    Datapath a1(Clk,Rst,PCResult);
    
    always begin
        Clk <= 0;
        #100;
        Clk <= 1; 
        #100;
       
    end
    
    initial begin
        Rst <= 1;
        @(posedge Clk);
        @(posedge Clk);
        Rst <= 0;
    end

    
    
endmodule
