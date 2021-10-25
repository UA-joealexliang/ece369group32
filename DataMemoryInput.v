`timescale 1ns / 1ps

module DataMemoryInput(WriteDataIn, Datatype, WriteDataOut); 

    input [31:0] WriteDataIn; // Data entering data memory
    input [1:0] Datatype;   // 0 = word, 1 = halfword, 2 = btye
    
    reg sign;
    
    output reg[31:0] WriteDataOut; // Data entering data memory after size modification
    
    /* Please fill in the implementation here */
    always@(*) begin
        if (Datatype == 0) begin // word
            WriteDataOut <= WriteDataIn; // no modification necessary
        end
        else if (Datatype == 1) begin // half
            //memory[Address[11:2]][Address[1:0]*8+:16] <= WriteData[15:0];
            WriteDataOut <= WriteDataIn[15:0];
        end
        else if (Datatype == 2) begin // byte
            //memory[Address[11:2]][Address[1:0]*8+:8] <= WriteData[7:0];
            WriteDataOut <= WriteDataIn[7:0];
        end
    end
    
endmodule
