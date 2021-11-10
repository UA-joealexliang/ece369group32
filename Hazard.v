`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// LAB GROUP 32
//      CAMERON MATSUMOTO, ASHTON ROWE, JOE LIANG
//      
//      PERCENT EFFORT:
//          CAMERON 33%     ASHTON 33%      JOE 33%
//
//      5 Pipeline Stages
//
//      Branches Resolved in the Decode Stage
//
// 
//////////////////////////////////////////////////////////////////////////////////

/*module Hazard(ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, ID_EX_Rs, IF_ID_Rt, ID_EX_Rt, EX_MEM_Rt, ID_EX_MemRead, EX_MEM_MemRead, ID_EX_RegWrite, EX_MEM_RegWrite, ID_EX_Branch, EX_MEM_Branch, FlushSignal);
    input [4:0] ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, ID_EX_Rs, IF_ID_Rt, ID_EX_Rt, EX_MEM_Rt;
    input ID_EX_MemRead, EX_MEM_MemRead, ID_EX_RegWrite, EX_MEM_RegWrite, ID_EX_Branch, EX_MEM_Branch;
    
    output reg [1:0] FlushSignal; // 0 for original control signals, 1 for nop

    always@(*) begin

        // rd + rs/rt hazards
        if (ID_EX_RegWrite == 0 && EX_MEM_RegWrite == 0 && ID_EX_MemRead == 0 && EX_MEM_MemRead == 0) begin
            FlushSignal <= 2'b00;
        end

        if (ID_EX_RegWrite == 1) begin
            if ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt)) begin
                FlushSignal <= 2'b01;
            end
            else begin
                FlushSignal <= 2'b00;
            end
        end

        if (EX_MEM_RegWrite == 1) begin
            if ((EX_MEM_Rd == ID_EX_Rs) || (EX_MEM_Rd == ID_EX_Rt)) begin
                FlushSignal <= 2'b11;
            end
            else begin
                FlushSignal <= 2'b00;
            end
        end

        // mem load hazard
        if (ID_EX_MemRead == 1) begin
            if ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt)) begin
                FlushSignal <= 2'b01;
            end
            else begin
                FlushSignal <= 2'b00;
            end
        end

        if (EX_MEM_MemRead == 1) begin
            if ((EX_MEM_Rt == ID_EX_Rs) || (EX_MEM_Rt == ID_EX_Rt)) begin
                FlushSignal <= 2'b11;
            end
            else begin
                FlushSignal <= 2'b00;
            end
        end

        // branch hazard
        // if (ID_EX_Branch == 1) begin
        //     if ((ID_EX_Rd == IF_ID_Rs) || (ID_EX_Rd == IF_ID_Rt)) begin
        //         FlushSignal <= 1;
        //     end
        //     else begin
        //         FlushSignal <= 0;
        //     end
        // end

        // if (EX_MEM_Branch == 1) begin
        //     if ((EX_MEM_Rd == ID_EX_Rs) || (EX_MEM_Rd == ID_EX_Rt)) begin
        //         FlushSignal <= 1;
        //     end
        //     else begin
        //         FlushSignal <= 0;
        //     end
        // end
    end

endmodule*/

module Hazard(EX_Instruction, MEM_Instruction, ID_Instruction,
                EX_MemRead, MEM_MemRead, EX_RegWrite, MEM_RegWrite,
                EX_Branch, MEM_Branch, FlushSignal);


endmodule