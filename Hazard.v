`timescale 1ns / 1ps

module Hazard(ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, ID_EX_Rs, IF_ID_Rt, ID_EX_Rt, ID_EX_MemRead, EX_MEM_MemRead, ID_EX_RegWrite, EX_MEM_RegWrite, ID_EX_Branch, EX_MEM_Branch, FlushSignal);
    input [4:0] ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, ID_EX_Rs, IF_ID_Rt, ID_EX_Rt;
    input ID_EX_MemRead, EX_MEM_MemRead, ID_EX_RegWrite, EX_MEM_MemRead, ID_EX_Branch, EX_MEM_Branch;

    output reg FlushSignal; // 0 for original control signals, 1 for nop

    always(*) begin
        // rd + rs/rt hazards
        if (ID_EX_RegWrite == 1) begin
            if ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end

        if (EX_MEM_RegWrite == 1) begin
            if ((EX_MEM_Rd == ID_EX_Rs) || (EX_MEM_Rd == ID_EX_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end

        // mem load hazard
        if (ID_EX_MemRead == 1) begin
            if ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end

        if (EX_MEM_MemRead == 1) begin
            if ((EX_MEM_Rd == ID_EX_Rs) || (EX_MEM_Rd == ID_EX_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end

        // branch hazard
        if (ID_EX_Branch == 1) begin
            if ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end

        if (EX_MEM_Branch == 1) begin
            if ((EX_MEM_Rd == ID_EX_Rs) || (EX_MEM_Rd == ID_EX_Rt)) begin
                FlushSignal <= 1;
            end
            else begin
                FlushSignal <= 0;
            end
        end
    end

endmodule