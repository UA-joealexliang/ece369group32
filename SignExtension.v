`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - SignExtension.v
// Description - Sign extension module.
////////////////////////////////////////////////////////////////////////////////
module SignExtension(in, out);

    /* A 16-Bit input word */
    input [15:0] in;
    
    /* A 32-Bit output word */
    output reg [31:0] out;
    
    /* Fill in the implementation here ... */
    reg [15:0] extension;
    
    always@(*) begin
        if(in[15] == 1) begin
            extension <= 16'b1111_1111_1111_1111;
            out <= {extension, in};
        end
        else if(in[15] == 0) begin
            extension <= 16'b0000_0000_0000_0000;
            out <= {extension, in};
        end
    end

endmodule
