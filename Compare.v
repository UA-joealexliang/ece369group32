`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2021 03:52:12 PM
// Design Name: 
// Module Name: Compare
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


module Compare(in, WriteHi_Lo, WriteMem_HILO, Jump);
    input [5:0] in;
    
    output reg WriteHi_Lo;          //0 writes HI, 1 writes LO
    output reg WriteMem_HILO;       //0 writes MEM, 1 writes HILO
    output reg [1:0] Jump;
    
    always@(*) begin
  
        case(in) 
            6'b010000: begin            //choose to write to hi or lo
                WriteHi_Lo <= 0;
                WriteMem_HILO <= 1;
                Jump <= 0;
            end
            
            6'b010010: begin            //chooses when if Hi Lo is written
                WriteHi_Lo <= 1;
                WriteMem_HILO <= 1;
                Jump <= 0;
            end
            
            6'b001000: begin            //chooses if should jump to register
                WriteHi_Lo <= 1'bX;
                WriteMem_HILO <= 1'bX;
                Jump <= 2'd2;
            end
            
            default: begin
                WriteHi_Lo <= 1'bX;
                WriteMem_HILO <= 0;
                Jump <= 0;
            end
        
        endcase
    end
endmodule
