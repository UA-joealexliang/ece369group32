`timescale 1ns / 1ps
// LAB GROUP 32
//      CAMERON MATSUMOTO, ASHTON ROWE, JOE LIANG
//      
//      PERCENT EFFORT:
//          CAMERON 33%     ASHTON 33%      JOE 33%
// 

/*
module Top_tb();

    reg Clk, Rst;
    
    wire [6:0] out7;
    wire [7:0] en_out;
    
    //wire [31:0] PCResult, WriteData, HI_out, LO_out;
    //Datapath a1(Clk,Rst, PCResult, WriteData, HI_out, LO_out);
    TopLevel a1(Clk, Rst, out7, en_out);
    
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
*/

module Top_tb();

reg Clk, Rst;

wire [31:0] PCResult, WriteData;
Datapath a1(Clk,Rst, PCResult, WriteData);

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
        //@(posedge Clk);
        //@(posedge Clk)
        //#300;
        //Rst <= 1;
        //#200;
        //@(posedge Clk);
        //Rst <= 0;
    end

endmodule