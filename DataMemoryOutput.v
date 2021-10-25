`timescale 1ns / 1ps

module DataMemoryOutput(ReadDataIn, Datatype, ReadDataOut); 

    input [31:0] ReadDataIn; // Data leaving data memory
    input [1:0] Datatype;   // 0 = word, 1 = halfword, 2 = btye
    
    reg sign;
    
    output reg[31:0] ReadDataOut; // Data leaving data memory after size modification
    
    /* Please fill in the implementation here */
    
    always@(*)begin
        if (Datatype == 0) begin // word
            ReadDataOut <= ReadDataIn; // no modification necessary
        end
        else if (Datatype == 1) begin // half
            //sign = memory[Address[11:2]][Address[1:0]*8];
            sign = ReadDataIn[15];
            if (sign == 0) begin
                //ReadData <= {16'h0000, memory[Address[11:2]][Address[1:0]*8+:16]};
                ReadDataOut <= {16'h0000, ReadDataIn[15:0]};
            end
            else if (sign == 1) begin
                //ReadData <= {16'hFFFF, memory[Address[11:2]][Address[1:0]*8+:16]};
                ReadDataOut <= {16'hFFFF, ReadDataIn[15:0]};
            end
        end
        else if (Datatype == 2) begin // byte
            //sign = memory[Address[11:2]][Address[1:0]*8];
            sign = ReadDataIn[7];
            if (sign == 0) begin
                //ReadData <= {24'h0000, memory[Address[11:2]][Address[1:0]*8+:8]};
                ReadDataOut <= {24'h000000, ReadDataIn[7:0]};
            end
            else if (sign == 1) begin
                //ReadData <= {24'hFFFF, memory[Address[11:2]][Address[1:0]*8+:8]};
                ReadDataOut <= {24'hFFFFFF, ReadDataIn[7:0]};
            end
        end
    end
endmodule
