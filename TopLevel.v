`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2021 05:28:54 PM
// Design Name: 
// Module Name: TopLevel
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


module TopLevel( Clk, Reset, out7, en_out );
    
    input Clk, Reset;
    
    output [6:0] out7;
    output [7:0] en_out;
    
    wire ClkOut;
    wire [31:0] PCResult, WriteData, HI_out, LO_out;
    
    ClkDiv              ClkDiv(Clk, Reset, ClkOut);
    
    Datapath            Datapath(Clk_Out, Rst, PCResult, WriteData, HI_out, LO_out);
                      //Datapath(Clk, Rst, PCResult, WriteData, HI_out, LO_out
    
    Two4DigitDisplay    Two4DigitDisplay(Clk, , , out7, en_out);     
       
    
endmodule
