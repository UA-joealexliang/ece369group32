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

module ALU32Bit(ALUControl, A, B, Hi_in, Lo_in, ALUResult, Hi, Lo, Zero, HI_LO_Write);

	input [4:0] ALUControl; //control bits for ALU operation
                                //you need to adjust the bitwidth as needed
	input [31:0] A, B;	//inputs
	input [31:0] Hi_in;
	input [31:0] Lo_in;
	
	reg [63:0] temp; //temp 64 bit register
	reg [31:0] s; //temp 32 bit register
	reg [4:0] i; //0-31 for loop variable

	output reg [31:0] ALUResult;	//answer
	output reg Zero;	    		//Zero flag is raised if conditions are met in branch instructions
	output reg [31:0] Hi;
	output reg [31:0] Lo;
    output reg HI_LO_Write;	// {0 = no write, 1 = write}
	output reg RegWrite2; //this is OR'd with RegWrite


    /* Please fill in the implementation here... */

    always@(*)begin
        case(ALUControl)
            
        5'b00001: begin                 	//add, addiu, addu, addi, lw, sw, sb, lh, lb, sh
        	ALUResult = A + B;
			HI_LO_Write <= 0;
        end 
            
        5'b00010: begin                 	//sub
            ALUResult = A - B; 
			HI_LO_Write <= 0;
        end    
	
	    5'b00011: begin              		//mul
            ALUResult <= A * B;
			HI_LO_Write <= 0;		
        end 
	
	    5'b00100: begin                  	//multiply word: mult, multu
            temp <= $signed(A * B);
            Hi <= temp[63:32];
            Lo <= temp[31:0];
            HI_LO_Write <= 1;
        end
	
  	    5'b00101: begin                 	//multiply and add: madd
            temp <= {Hi_in, Lo_in} + (A * B);
            Hi <= temp[63:32];
            Lo <= temp[31:0]; 
            HI_LO_Write <= 1;
        end
            
        5'b00110: begin                 	//multiply and sub: msub
            temp <= {Hi_in, Lo_in} - (A * B);
            Hi <= temp[63:32];
            Lo <= temp[31:0]; 
            HI_LO_Write <= 1;
        end
	
	    5'b00111: begin						//bgez rs >= 0
			HI_LO_Write <= 0;
			if (A >= 0) begin
				Zero <= 1;
			end
			else begin
				Zero <= 0;
			end
	    end

	    5'b01000: begin						//beq rs == rt
			HI_LO_Write <= 0;
			if (A == B) begin
				Zero <= 1;
			end
			else begin
				Zero <= 0;
			end
	    end

	    5'b01001: begin						//bne rs != rt
			HI_LO_Write <= 0;
			if(A != B) begin
				Zero <= 1;
			end
			else begin
				Zero <= 0;
			end
	    end

	    5'b01010: begin						//bgtz rs > 0
			HI_LO_Write <= 0;
			if (A > 0) begin
				Zero <= 1;
			end
			else begin
				Zero <= 0;
			end
	    end

	    5'b01011: begin						//blez rs <= 0
			HI_LO_Write <= 0;
			if (A <= 0) begin
				Zero <= 1;
			end
			else begin
				Zero <= 0;
			end
	    end
	    
	    5'b01100: begin						//bltz rs < 0
			HI_LO_Write <= 0;
			if (A < 0) begin
				Zero <= 1;
			end
			else begin
				Zero <= 0;
			end
	    end

        5'b01101: begin                  	//logical and, andi
			HI_LO_Write <= 0;
        	ALUResult = (A & B);
        end 
            
        5'b01110: begin                  	//logical or, ori
			HI_LO_Write <= 0;
            ALUResult = (A | B);
        end
            
	    5'b01111: begin                  	//logical nor
			HI_LO_Write <= 0;
            ALUResult = ~(A | B);
        end

        5'b10000: begin                  	//logical xor, xori
			HI_LO_Write <= 0;
            ALUResult = (A ^ B);
        end
		
	    5'b10001: begin 					//seh least significant halfword rt sign extended
			HI_LO_Write <= 0;
			if (B[15] == 1) begin
     		    ALUResult <= {16'hffff, B[15:0]};
     		end
			else begin
		    	ALUResult <= {16'h0000, B[15:0]};
		    end
	    end

	    5'b10001: begin                  	//sll, sllv rt is left shifted rs[4:0] bits
			HI_LO_Write <= 0;
			ALUResult <= B << A[4:0];
        end
            
 	    5'b10010: begin                  	//srl, srlv rt is right shifted rs[4:0] bits
			HI_LO_Write <= 0;
            ALUResult <= B >> A[4:0];
        end

	    5'b10011: begin                  	//slt, slti rs < rt
			HI_LO_Write <= 0;
			if (A[31] != B[31]) begin //if they are not the same sign
				if (A[31] == 1) begin //rs is negative
					ALUResult <= 1;
				end
				else if (B[31] == 1) begin //rt is negative
					ALUResult <= 0;
				end
			end
			else begin //if they are the same sign, normal comparison works (1000 < 1111 since 1000 = -8 and 1111 = -1)
				if (A < B) begin
					ALUResult <= 1;
				end
				else begin
					ALUResult <= 0;
				end
			end
        end
		
	    5'b10100: begin						//movn SET RegWrite = 0, writing now determined by RegWrite2
			HI_LO_Write <= 0;
			ALUResult <= A;
			if(B != 0) begin
				RegWrite2 <= 1;
			end
			else begin
				RegWrite2 <= 0;
			end
	    end

	    5'b10101: begin						//movz SET RegWrite = 0, writing now determined by RegWrite2
			HI_LO_Write <= 0;
			ALUResult <= A;
			if(B == 0) begin				
				RegWrite2 <= 1;
			end
			else begin
				RegWrite2 <= 0;
			end
	    end	
            
        5'b10110: begin                  	//rotrv, rotr rt is rotated rs[4:0] bits (ASSUME unsigned B[4:0])
			HI_LO_Write <= 0;
			temp <= {B, B}; //ex B = 101 temp = 101101 rotr0/3 = 101 rotr1 = 110 rotr2 = 011 
			ALUResult <= temp[A[4:0]+:32]; //https://electronics.stackexchange.com/questions/67983/accessing-rows-of-an-array-using-variable-in-verilog
        end

	    5'b10111: begin						//sra, srav rt is sign right shifted rs[4:0] bits  
			HI_LO_Write <= 0;
			if (B[31] == 1) begin
				s <= B >> A[4:0];
				for (i = 32-A[4:0]; i <= 5'd31; i = i + 1) begin
					s[i] = 1;
				end
				ALUResult <= s;
			end
			else if (B[31] == 0) begin
				ALUResult <= B >> A[4:0];
			end
	    end
            
 	    5'b11000: begin 					//seb sign extend least significant byte
			HI_LO_Write <= 0;
			if (B[7] == 1) begin
     		    ALUResult <= {24'hffff, B[7:0]};
     		end
			else begin
		    	ALUResult <= {24'h0000, B[7:0]};
		    end
	    end
		
 	    5'b11001: begin 					//sltiu, sltu unsigned rs < rt
			HI_LO_Write <= 0;
			Zero <= 0;
			if (A < B) begin
		   		ALUResult <= 1;
		    end
			else begin
                ALUResult <= 0;
            end
	     end

 	    5'b11001: begin 					//mthi
			Hi <= A;
			HI_LO_Write <= 1;
	    end

	    5'b11001: begin 					//mtlo
			Lo <= A;
			HI_LO_Write <= 1;
	    end	

	    5'b11001: begin 					//mfhi
			HI_LO_Write <= 0;
			ALUResult <= Hi_in;
		end

	    5'b11001: begin 					//mflo
			HI_LO_Write <= 0;
			ALUResult <= Lo_in;
	    end		
	    
	    5'b11010: begin 					//lui load immediate into upper half of a word
			HI_LO_Write <= 0;
			ALUResult <= B<<16;
	    end		    

        default:  begin  					//j, jr, jal
			HI_LO_Write <= 0;   
        end
            
        endcase
    end
 
endmodule

