`timescale 1ns / 1ps

module Hazard(ID_EX_Rd, IF_ID_Rs, IF_ID_Rt, ID_EX_MemRead, ID_EX_RegWrite, FlushSignal);
    input [4:0] ID_EX_Rd, IF_ID_Rs, IF_ID_Rt;
    input ID_EX_MemRead, ID_EX_RegWrite;

    output reg FlushSignal; // 0 for original control signals, 1 for nop

    always(*) begin
        if (ID_EX_RegWrite == 1) begin
            if ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end

        if (ID_EX_MemRead == 1) begin
            if (ID_EX_Rd == IF_ID_Rs) begin
                FlushSignal <= 1;
            end
        end
    end

endmodule