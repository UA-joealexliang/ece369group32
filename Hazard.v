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

module Hazard(
            ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, IF_ID_Rt, ID_EX_Rt, EX_MEM_Rt, 
            ID_EX_RegWrite, EX_MEM_RegWrite, ID_EX_RegDst, EX_MEM_RegDst, ID_EX_MemWrite, EX_MEM_MemWrite, IF_ID_ALUSrc, IF_ID_MemWrite, IF_ID_Jump, 
            FlushSignal,
            MEM_WB_Rd, MEM_WB_Rt,
            MEM_WB_RegWrite, MEM_WB_RegDst
            );
    input [4:0] ID_EX_Rd, EX_MEM_Rd, IF_ID_Rs, IF_ID_Rt, ID_EX_Rt, EX_MEM_Rt;
    input ID_EX_RegWrite, EX_MEM_RegWrite, ID_EX_RegDst, EX_MEM_RegDst, ID_EX_MemWrite, EX_MEM_MemWrite, IF_ID_ALUSrc, IF_ID_MemWrite, IF_ID_Jump;

    output reg FlushSignal; // 0 for original control signals, 1 for nop

    always@(*) begin
        FlushSignal <= 0;

        if (ID_EX_RegWrite == 1) begin //ID/EX check dependency
            if (((IF_ID_ALUSrc == 1) && (IF_ID_MemWrite == 0)) || (IF_ID_Jump == 1)) begin //i-type, load, or jump
                if (ID_EX_RegDst == 0) begin //rt writeaddress
                    if (IF_ID_Rs == ID_EX_Rt) begin //rs = rt
                        FlushSignal <= 1;
                        $display("ID/EX rs=rt DEP");
                    end
                end
                else if (ID_EX_RegDst == 1) begin //rd writeaddress
                    if (IF_ID_Rs == ID_EX_Rd) begin //rs = rd
                        FlushSignal <= 1;
                        $display("ID/EX rs=rd DEP");
                    end
                end
            end
            else begin // if r-type, store, or branch
                if (ID_EX_RegDst == 0) begin //rt writeaddress
                    if ((IF_ID_Rs == ID_EX_Rt) || (IF_ID_Rt == ID_EX_Rt)) begin //rs or rt = rt
                        FlushSignal <= 1;
                        $display("ID/EX rs or rt = rt DEP");
                    end
                end
                else if (ID_EX_RegDst == 1) begin //rd writeaddress
                    if ((IF_ID_Rs == ID_EX_Rd) || (IF_ID_Rt == ID_EX_Rd)) begin // rs or rt = rd
                        FlushSignal <= 1;
                        $display("ID/EX rs or rt = rd DEP");
                    end
                end
            end
        end
        if (EX_MEM_RegWrite == 1) begin
            if (((IF_ID_ALUSrc == 1) && (IF_ID_MemWrite == 0)) || (IF_ID_Jump == 1)) begin //i-type, load, or jump
                if (EX_MEM_RegDst == 0) begin //rt writeaddress
                    if (IF_ID_Rs == EX_MEM_Rt) begin //rs = rt
                        FlushSignal <= 1;
                        $display("EX/MEM rs=rt DEP");
                    end
                end
                else if (EX_MEM_RegDst == 1) begin //rd writeaddress
                    if (IF_ID_Rs == EX_MEM_Rd) begin //rs = rd
                        FlushSignal <= 1;
                        $display("EX/MEM rs=rd DEP");
                    end
                end
            end
            else begin // if r-type, store, or branch
                if (EX_MEM_RegDst == 0) begin //rt writeaddress
                    if ((IF_ID_Rs == EX_MEM_Rt) || (IF_ID_Rt == EX_MEM_Rt)) begin //rs or rt = rt
                        FlushSignal <= 1;
                        $display("EX/MEM rs or rt = rt DEP");
                    end
                end
                else if (EX_MEM_RegDst == 1) begin //rd writeaddress
                    if ((IF_ID_Rs == EX_MEM_Rd) || (IF_ID_Rt == EX_MEM_Rd)) begin // rs or rt = rd
                        FlushSignal <= 1;
                        $display("EX/MEM rs or rt = rd DEP");
                    end
                end
            end
        end
    end
    if (MEM_WB_RegWrite == 1) begin
            if (((IF_ID_ALUSrc == 1) && (IF_ID_MemWrite == 0)) || (IF_ID_Jump == 1)) begin //i-type, load, or jump
                if (MEM_WB_RegDst == 0) begin //rt writeaddress
                    if (IF_ID_Rs == MEM_WB_Rt) begin //rs = rt
                        FlushSignal <= 1;
                        $display("MEM/WB rs=rt DEP");
                    end
                end
                else if (MEM_WB_RegDst == 1) begin //rd writeaddress
                    if (IF_ID_Rs == MEM_WB_Rd) begin //rs = rd
                        FlushSignal <= 1;
                        $display("MEM/WB rs=rd DEP");
                    end
                end
            end
            else begin // if r-type, store, or branch
                if (MEM_WB_RegDst == 0) begin //rt writeaddress
                    if ((IF_ID_Rs == MEM_WB_Rt) || (IF_ID_Rt == MEM_WB_Rt)) begin //rs or rt = rt
                        FlushSignal <= 1;
                        $display("MEM/WB rs or rt = rt DEP");
                    end
                end
                else if (MEM_WB_RegDst == 1) begin //rd writeaddress
                    if ((IF_ID_Rs == MEM_WB_Rd) || (IF_ID_Rt == MEM_WB_Rd)) begin // rs or rt = rd
                        FlushSignal <= 1;
                        $display("MEM/WB rs or rt = rd DEP");
                    end
                end
            end
        end
    end

        /*if ((ID_EX_RegWrite == 1) || (EX_MEM_RegWrite == 1)) begin // if first instruction will write to register
            if ((ID_EX_RegDst == 0) || (EX_MEM_RegDst == 0)) begin // -> rt
                if (((IF_ID_ALUSrc == 1) && (IF_ID_MemWrite == 0)) || (IF_ID_Jump == 1)) begin // if i-type, load, or jump
                    if ((IF_ID_Rs == ID_EX_Rt) || (IF_ID_Rs == EX_MEM_Rt)) begin // rs = rt
                        FlushSignal <= 1;
                        $display("first");
                    end
                end
                else begin // if r-type, store, or branch
                    if (((IF_ID_Rs == ID_EX_Rt) || (IF_ID_Rs == EX_MEM_Rt)) || ((IF_ID_Rt == ID_EX_Rt) || (IF_ID_Rt == EX_MEM_Rt))) begin // rs or rt = rt
                        FlushSignal <= 1;
                        $display("second");
                    end
                end
            end
            else begin // -> rd
                if (((IF_ID_ALUSrc == 1) && (IF_ID_MemWrite == 0)) || (IF_ID_Jump == 1)) begin // if i-type, load, or jump
                    if ((IF_ID_Rs == ID_EX_Rd) || (IF_ID_Rs == EX_MEM_Rd)) begin // rs = rd
                        FlushSignal <= 1;
                        $display("third");
                    end
                end
                else begin // if r-type, store, or branch
                    if (((IF_ID_Rs == ID_EX_Rd) || (IF_ID_Rs == EX_MEM_Rd)) || ((IF_ID_Rt == ID_EX_Rd) || (IF_ID_Rt == EX_MEM_Rd))) begin // rs or rt = rd
                        FlushSignal <= 1;
                        $display("fourth");
                    end
                end
            end
        end*/

        /*else if ((ID_EX_MemWrite == 1) || (EX_MEM_MemWrite == 1)) begin // if first instruction will write to memory
            if (IF_ID_MemRead == 1) begin // i.e. reg -> mem then mem -> reg
                if ()
            end
        end*/
endmodule

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