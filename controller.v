`timescale 1ns / 1ps

module Controller(Opcode, Bit21, Bit20_16, Bit10_6, funct, RegDst, SignExtend, ALUSrc1, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, Branch, Jump, Datatype, ALUControl);

    input [5:0] Opcode;     // left-most 6 bits of the instruction signifying the opcode
    input Bit21;            // used to differentiate srl vs rotr 
    input [4:0] Bit20_16;   // used to differentiate bgez vs bltz
    input [4:0] Bit10_6;    // used to differentiate seb vs seh and Bit6 used to differentiate srlv vs rotrv
    input [5:0] funct;      // right-most 6 bits of the instruction signifying the function under operation type

    output reg RegDst, SignExtend, ALUSrc1, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, Branch, Jump, Datatype; // 12 control signals
    output reg [4:0] ALUControl;

    //SignExtend: 0 for unsigned operations, 1 for signed operations
    //ALUSrc1: 0 for rs, 1 for imm (for rotate and shift)
    //HI_LO_Write: 1 for HI/LO register write
    //Branch: 1 for branches
    //Jump: 1 for jumps
    //Datatype: 0 = word, 1 = halfword, 2 = byte (loads and stores)
    //ALUControl: match ALU32Bit.v values

    always@(*) begin
        case(Opcode)
            // Arithmetic/Logic r-format

            6'b000000: begin // r-format instructions add, addu
                RegDst = 1'b1;
                ALUSrc = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
                Jump = 1'b0;
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
