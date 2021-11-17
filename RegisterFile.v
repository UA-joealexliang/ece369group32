`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
//
//
// Student(s) Name and Last Name: FILL IN YOUR INFO HERE!
//       Cameron Matsumoto, Joe Liang, Ashton Rowe
//
//
// Module - register_file.v
// Description - Implements a register file with 32 32-Bit wide registers.
//
// 
// INPUTS:-
// ReadRegister1: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister1'.
// ReadRegister2: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister2'.
// WriteRegister: 5-Bit address to select a register to be written through 32-Bit
//                input port 'WriteRegister'.
// WriteData: 32-Bit write input port.
// RegWrite: 1-Bit control input signal.
//
// OUTPUTS:-
// ReadData1: 32-Bit registered output. 
// ReadData2: 32-Bit registered output. 
//
// FUNCTIONALITY:-
// 'ReadRegister1' and 'ReadRegister2' are two 5-bit addresses to read two 
// registers simultaneously. The two 32-bit data sets are available on ports 
// 'ReadData1' and 'ReadData2', respectively. 'ReadData1' and 'ReadData2' are 
// registered outputs (output of register file is written into these registers 
// at the falling edge of the clock). You can view it as if outputs of registers
// specified by ReadRegister1 and ReadRegister2 are written into output 
// registers ReadData1 and ReadData2 at the falling edge of the clock. 
//
// 'RegWrite' signal is high during the rising edge of the clock if the input 
// data is to be written into the register file. The contents of the register 
// specified by address 'WriteRegister' in the register file are modified at the 
// rising edge of the clock if 'RegWrite' signal is high. The D-flip flops in 
// the register file are positive-edge (rising-edge) triggered. (You have to use 
// this information to generate the write-clock properly.) 
//
// NOTE:-
// We will design the register file such that the contents of registers do not 
// change for a pre-specified time before the falling edge of the clock arrives 
// to allow for data multiplexing and setup time.
////////////////////////////////////////////////////////////////////////////////

module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2, v0, v1);
    input [4:0]ReadRegister1;
    input [4:0]ReadRegister2;
    input [4:0]WriteRegister;
    input [31:0]WriteData;
    input RegWrite;         //control signal for writing into register
    input Clk;
    
    reg [31:0] register [0:31];
    reg [4:0] i;
    
    output reg [31:0] ReadData1;
    output reg [31:0] ReadData2;
    output reg [31:0] v0;
    output reg [31:0] v1;
    
    initial begin
       register[0] <= 0;
       register[1] <= 0;
       register[2] <= 0;
       register[3] <= 0;
       register[4] <= 0;
       register[5] <= 0;
       register[6] <= 0;
       register[7] <= 0;
       register[8] <= 0;
       register[9] <= 0;
       register[10] <= 0;
       register[11] <= 0;
       register[12] <= 0;
       register[13] <= 0;
       register[14] <= 0;
       register[15] <= 0;
       register[16] <= 0;
       register[17] <= 0;
       register[18] <= 0;
       register[19] <= 0;
       register[20] <= 0;
       register[21] <= 0;
       register[22] <= 0;
       register[23] <= 0;
       register[24] <= 0;
       register[25] <= 0;
       register[26] <= 0;
       register[27] <= 0;
       register[28] <= 0;
       register[29] <= 0;
       register[30] <= 0;
       register[31] <= 0;
    end

    always@(posedge Clk) begin
        if( (RegWrite == 1) && (WriteRegister != 0) ) begin
            register[WriteRegister] <= WriteData;
            //$display("Write Register = %d, WriteData = %d", WriteRegister, WriteData);
        end
    end
    
    always@(negedge Clk)begin
        ReadData1 <= register[ReadRegister1];
        ReadData2 <= register[ReadRegister2];
        //$display("Read Rs = %d, GPR[rs] = %d, Rt = %d, GPR[rt] = %d", ReadRegister1, ReadData1, ReadRegister2, ReadData2);
        v0 <= register[2];
        v1 <= register[3];
    end
endmodule
