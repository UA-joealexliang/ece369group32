`timescale 1ns / 1ps

module controller(Opcode, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0);

    input [5:0] Opcode; // left-most 6 bits of the instruction signifying the opcode

    output reg RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0; // 9 control signals

    always@(*) begin
        case(Opcode)
            // Arithmetic/Logic r-format

            6'b000000: begin // r-format instructions
                RegDst = 1'b1;
                ALUSrc = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b011100: begin // mul, madd, msub
                RegDst = 1'b1;
                ALUSrc = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end
            
            // Data

            6'b100011: begin // lw
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            6'b100001: begin // lh
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            6'b100000: begin // lb
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            6'b001111: begin // lui
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            6'b101011: begin // sw
                RegDst = X;
                ALUSrc = 1'b1;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            6'b101001: begin // sh
                RegDst = X;
                ALUSrc = 1'b1;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            6'b101000: begin // sb
                RegDst = X;
                ALUSrc = 1'b1;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                Branch = 1'b0;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b0;
            end

            // Branch

            6'b000001: begin // bgez, bltz
                RegDst = X;
                ALUSrc = 1'b0;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b1;
            end

            6'b000100: begin // beq
                RegDst = X;
                ALUSrc = 1'b0;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b1;
            end

            6'b000101: begin // bne
                RegDst = X;
                ALUSrc = 1'b0;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b1;
            end

            6'b000111: begin // bgtz
                RegDst = X;
                ALUSrc = 1'b0;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b1;
            end

            6'b000110: begin // blez
                RegDst = X;
                ALUSrc = 1'b0;
                MemtoReg = X;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                ALUOp1 = 1'b0;
                ALUOp0 = 1'b1;
            end

            // Arithmetic/Logic I-format

            6'b001001: begin // addiu
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b001000: begin // addi
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b001100: begin // andi
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b001101: begin // ori
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b001110: begin // xori
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b001010: begin // slti
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            6'b001011: begin // sltiu
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            // Other

            6'b011111: begin // seh, seb
                RegDst = 1'b1;
                ALUSrc = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp1 = 1'b1;
                ALUOp0 = 1'b0;
            end

            default: begin
                RegDst = X;
                ALUSrc = X;
                MemtoReg = X;
                RegWrite = X;
                MemRead = X;
                MemWrite = X;
                Branch = X;
                ALUOp1 = X;
                ALUOp0 = X;
            end
        endcase
    end

endmodule
