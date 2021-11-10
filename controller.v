`timescale 1ns / 1ps

module Controller(
            Opcode, Bit21, Bit20_16, Bit10_6, funct,
            RegDst, ALUSrc, ALUSrc2, MemtoReg, RegWrite, HI_LO_Write, MemRead, MemWrite, 
            Branch, Jump, Datatype, ALUControl, SignExtend, index, RegisterTypes
            );

    input [5:0] Opcode;     // left-most 6 bits of the instruction signifying the opcode
    input Bit21;            // used to differentiate srl vs rotr 
    input [4:0] Bit20_16;   // used to differentiate bgez vs bltz
    input [4:0] Bit10_6;    // used to differentiate seb vs seh and Bit6 used to differentiate srlv vs rotrv
    input [5:0] funct;      // right-most 6 bits of the instruction signifying the function under operation type
    input [3:0] RegisterTypes;

    output reg ALUSrc, ALUSrc2, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, index; // 12 control signals
    output reg [1:0] RegDst;
    output reg SignExtend; // still needs to be implemented
    output reg [1:0] Datatype;
    output reg [1:0] HI_LO_Write; // 0: don't write, 1: HI, 2: LO, 3: Both
    output reg [4:0] ALUControl;

    //SignExtend: 0 for unsigned operations, 1 for signed operations
    //ALUSrc2: 0 for rs, 1 for imm (for rotate and shift)
    //HI_LO_Write: 0 = noWrite, 1 = HI_Write, 2 = LO_Write 3 = HI_LO_Write
    //Branch: 1 for branches
    //Jump: 1 for jumps
    //Datatype: 0 = word, 1 = halfword, 2 = byte (loads and stores)
    //ALUControl: match ALU32Bit.v values

    always@(*) begin
        if (Opcode == 0 && Bit21 == 0 && Bit20_16 == 0 && Bit10_6 == 0 && funct == 0) begin
            //Datatype = 2'bXX;
            RegDst = 2'b00;
            ALUSrc = 1'b0;
            ALUSrc2 = 1'b0;
            MemtoReg = 1'b0;
            RegWrite = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            Branch = 1'b0;
            Jump = 1'b0;
            HI_LO_Write = 2'b00;
            SignExtend = 1'b0;
            ALUControl = 5'b11111;
            index = 0;
            RegisterTypes = 4'b1011;
        end
        else begin
            case(Opcode)
                // Arithmetic/Logic r-format

                6'b000000: begin // r-format instructions add, addu
                    //Datatype = 2'bXX;
                    RegDst = 2'b01;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;

                    case(funct)
                        6'b100000: begin // add
                            ALUControl = 5'b00000;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b100001: begin // addu
                            ALUControl = 5'b00000;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b100010: begin // sub
                            ALUControl = 5'b00001;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b011000: begin // mult
                            ALUControl = 5'b00010;
                            HI_LO_Write = 2'b11;
                            index = 0;
                            RegisterTypes <= 4'b0010;
                        end

                        6'b011001: begin // multu
                            ALUControl = 5'b00010;
                            HI_LO_Write = 2'b11;
                            index = 0;
                            RegisterTypes <= 4'b0010;
                        end

                        6'b100100: begin // and
                            ALUControl = 5'b00011;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b100101: begin // or
                            ALUControl = 5'b00100;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b100111: begin // nor
                            ALUControl = 5'b00101;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b100110: begin // xor
                            ALUControl = 5'b00110;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b000000: begin // sll
                            ALUControl = 5'b00111;
                            ALUSrc2 = 1'b1;
                            index = 1;
                            RegisterTypes <= 4'b1001;
                        end

                        6'b000100: begin // sllv
                            ALUControl = 5'b00111;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b000010: begin
                            case(Bit21)
                                1'b0: begin // srl
                                    ALUControl = 5'b01000;
                                    ALUSrc2 = 1'b1;
                                    index = 1;
                                    RegisterTypes <= 4'b1001;
                                end

                                1'b1: begin // rotr
                                    ALUControl = 5'b01001;
                                    ALUSrc2 = 1'b1;
                                    index = 1;
                                    RegisterTypes <= 4'b01001;
                                end

                                default: begin
                                    ALUControl = 5'b11111;
                                end
                            endcase
                        end

                        6'b000110: begin
                            case(Bit10_6)
                                5'b00000: begin // srlv
                                    ALUControl = 5'b01000;
                                    index = 0;
                                    RegisterTypes <= 4'b0000;
                                end

                                5'b00001: begin // rotrv
                                    ALUControl = 5'b01001;
                                    index = 0;
                                    RegisterTypes <= 4'b0000;
                                end

                                default: begin
                                    ALUControl = 5'b11111;
                                end
                            endcase
                        end

                        6'b101010: begin // slt
                            ALUControl = 5'b01010;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b001011: begin // movn
                            ALUControl = 5'b01011;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b001010: begin // movz
                            ALUControl = 5'b01100;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b000011: begin // sra
                            ALUControl = 5'b01101;
                            index = 1;
                            ALUSrc2 = 1'b1;
                            RegisterTypes <= 4'b1001;
                        end

                        6'b000111: begin // srav
                            ALUControl = 5'b01101;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b101011: begin // sltu
                            ALUControl = 5'b01110;
                            index = 0;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b010001: begin // mthi
                            ALUControl = 5'b01111;
                            HI_LO_Write = 2'b01;
                            index = 0;
                            RegisterTypes <= 4'b0010;
                        end

                        6'b010011: begin // mtlo
                            ALUControl = 5'b10000;
                            HI_LO_Write = 2'b10;
                            index = 0;
                            RegisterTypes <= 4'b0010;
                        end

                        6'b010000: begin // mfhi
                            ALUControl = 5'b10001;
                            index = 0;
                            RegisterTypes <= 4'b1010;
                        end

                        6'b010010: begin // mflo
                            ALUControl = 5'b10010;
                            index = 0;
                            RegisterTypes <= 4'b1010;
                        end
                        
                        6'b001000: begin // jr
                            ALUControl = 5'b11111;
                            Jump = 1'b1;
                            index = 0;
                            RegisterTypes <= 4'b1000;
                        end

                        default: begin
                            ALUControl = 5'b11111;
                        end
                    endcase
                end

                6'b011100: begin // mul, madd, msub
                    //Datatype = 2'bXX;
                    RegDst = 2'b01;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    SignExtend = 1'b0;
                    index = 0;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;

                    case(funct)
                        6'b000010: begin // mul
                            ALUControl = 5'b10011;
                            HI_LO_Write = 2'b00;
                            RegisterTypes <= 4'b0000;
                        end

                        6'b000000: begin // madd
                            ALUControl = 5'b10100;
                            HI_LO_Write = 2'b11;
                            RegisterTypes <= 4'b0010;
                        end

                        6'b000100: begin // msub
                            ALUControl = 5'b10101;
                            HI_LO_Write = 2'b11;
                            RegisterTypes <= 4'b0010;
                        end

                        default: begin
                            ALUControl = 5'b11111;
                            HI_LO_Write = 2'b00;
                        end
                    endcase
                end
                
                // Data

                6'b100011: begin // lw
                    Datatype = 2'b00;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b1;
                    RegWrite = 1'b1;
                    MemRead = 1'b1;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end

                6'b100001: begin // lh
                    Datatype = 2'b01;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b1;
                    RegWrite = 1'b1;
                    MemRead = 1'b1;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0011;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end

                6'b100000: begin // lb
                    Datatype = 2'b10;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b1;
                    RegWrite = 1'b1;
                    MemRead = 1'b1;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0011;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end

                6'b001111: begin // lui
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0011;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end

                6'b101011: begin // sw
                    Datatype = 2'b00;
                    //RegDst = X;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b1;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0100;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end

                6'b101001: begin // sh
                    Datatype = 2'b01;
                    //RegDst = X;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b1;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                    RegisterTypes <= 4'b0100;
                end

                6'b101000: begin // sb
                    Datatype = 2'b10;
                    //RegDst = X;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b1;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0100;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end

                // Branch

                6'b000001: begin // bgez, bltz
                    //Datatype = 2'bXX;
                    //RegDst = X;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b1;

                    case(Bit20_16)
                        5'b00001: begin // bgez
                            ALUControl = 5'b11000;
                            RegisterTypes <= 4'b0101;
                        end

                        5'b00000: begin // bltz
                            ALUControl = 5'b11001;
                            RegisterTypes <= 4'b0101;
                        end
                    endcase
                end

                6'b000100: begin // beq
                    //Datatype = 2'bXX;
                    //RegDst = X;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0110;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b1;
                end

                6'b000101: begin // bne
                    //Datatype = 2'bXX;
                    //RegDst = X;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0110;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b1;
                end

                6'b000111: begin // bgtz
                    //Datatype = 2'bXX;
                    //RegDst = X;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0101;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b1;
                end

                6'b000110: begin // blez
                    //Datatype = 2'bXX;
                    //RegDst = X;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    //MemtoReg = X;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0101;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b1;
                end

                // Arithmetic/Logic I-format

                6'b001001: begin // addiu
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                6'b001000: begin // addi
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                6'b001100: begin // andi
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b1;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                6'b001101: begin // ori
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b1;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                6'b001110: begin // xori
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b1;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                6'b001010: begin // slti
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                6'b001011: begin // sltiu
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b1;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0001;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;
                end

                // Other

                6'b011111: begin // seh, seb
                    //Datatype = 2'bXX;
                    RegDst = 2'b01;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    //ALUOp1 = 1'b1;
                    //ALUOp0 = 1'b0;

                    case(Bit10_6)
                        5'b11000: begin // seh
                            ALUControl = 5'b10110;
                            RegisterTypes <= 4'b1001;
                        end

                        5'b10000: begin // seb
                            ALUControl = 5'b10111;
                            RegisterTypes <= 4'b1001;
                        end
                    endcase
                end
                
                6'b000010: begin // j
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b1;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b1;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0111;
                end
                
                6'b000011: begin // jal
                    //Datatype = 2'bXX;
                    RegDst = 2'b10;
                    ALUSrc = 1'b0;
                    ALUSrc2 = 1'b1;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b1;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b1;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    RegisterTypes <= 4'b0111;
                end

                default: begin
                    //Datatype = 2'bXX;
                    RegDst = 2'b00;
                    ALUSrc = 1'b0;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b0;
                    Jump = 1'b0;
                    HI_LO_Write = 2'b00;
                    SignExtend = 1'b0;
                    index = 0;
                    //ALUOp1 = 1'b0;
                    //ALUOp0 = 1'b0;
                end
            endcase
        end
    end

endmodule
