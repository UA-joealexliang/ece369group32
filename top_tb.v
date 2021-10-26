`timescale 1ns / 1ps
// LAB GROUP 32
//      CAMERON MATSUMOTO, ASHTON ROWE, JOE LIANG
//      
//      PERCENT EFFORT:
//          CAMERON 33%     ASHTON 33%      JOE 33%
// 


module Datapath_tb();

    reg Clk, Rst;
    
    wire [31:0] PCResult, WriteData, HI_out, LO_out;
    Datapath a1(Clk,Rst, PCResult, WriteData, HI_out, LO_out);
    
    always begin
        Clk <= 0;
        #100;
        Clk <= 1; 
        #100;
       
    end
    
    initial begin
        Rst <= 1;
        @(posedge Clk);
        Rst <= 0;
    end

    
    
endmodule
