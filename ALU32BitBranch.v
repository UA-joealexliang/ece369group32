`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: N-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU, so that it supports all arithmetic operations 
// needed by the MIPS instructions given in Labs5-8.docx document. 
//   The 'ALUResult' will output the corresponding result of the operation 
//   based on the 32-Bit inputs, 'A', and 'B'. 
//   The 'Zero' flag is high when 'ALUResult' is '0'. 
//   The 'ALUControl' signal should determine the function of the ALU 
//   You need to determine the bitwidth of the ALUControl signal based on the number of 
//   operations needed to support. 
////////////////////////////////////////////////////////////////////////////////

module ALU32BitBranch(ALUControl, A, B, Opcode, Zero);

	input [4:0] ALUControl; //control bits for ALU operation
                                //you need to adjust the bitwidth as needed
	input [31:0] A, B;	//inputs
	//input [31:0] Hi_in;
	//input [31:0] Lo_in;
	input [5:0] Opcode; // input for opcode from instruction
	
	reg [63:0] temp; //temp 64 bit register
	reg [31:0] s; //temp 32 bit register
	reg [4:0] i; //0-31 for loop variable

	//output reg [31:0] ALUResult;	//answer
	output reg Zero;	    		//Zero flag is raised if conditions are met in branch instructions
	//output reg [31:0] Hi;
	//output reg [31:0] Lo;
	//output reg RegWrite2; //this is OR'd with RegWrite


    /* Please fill in the implementation here... */
    
    always@(*) begin
        case(Opcode)

			// branch instructions

			6'b000001: begin
				case(ALUControl)
					5'b11000: begin // bgez
						if ($signed(A) >= 0) begin
							Zero <= 1;
						end
						else begin
							Zero <= 0;
						end
					end

					5'b11001: begin // bltz
						if ($signed(A) < 0) begin
							Zero <= 1;
						end
						else begin
							Zero <= 0;
						end
					end
				endcase
			end

			6'b000100: begin // beq
				if ($signed(A) == $signed(B)) begin
					Zero <= 1;
				end
				else begin
					Zero <= 0;
				end
			end

			6'b000101: begin // bne
				if($signed(A) != $signed(B)) begin
					Zero <= 1;
				end
				else begin
					Zero <= 0;
				end
			end

			6'b000111: begin // bgtz
				if ($signed(A) > 0) begin
					Zero <= 1;
				end
				else begin
					Zero <= 0;
				end
			end

			6'b000110: begin // blez
				if ($signed(A) <= 0) begin
					Zero <= 1;
				end
				else begin
					Zero <= 0;
				end
			end

			default: begin // j, jal
			end
		endcase
		//$display("BRANCH A = %d, B = %d, Zero = %d", A, B, Zero);
    end
 
endmodule

