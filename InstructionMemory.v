`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory  1
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:-
// Address: 32-Bit address input port.
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
// FUNCTIONALITY:-
// Similar to the DataMemory, this module should also be byte-addressed
// (i.e., ignore bits 0 and 1 of 'Address'). All of the instructions will be 
// hard-coded into the instruction memory, so there is no need to write to the 
// InstructionMemory.  The contents of the InstructionMemory is the machine 
// language program to be run on your MIPS processor.
//
//
//we will store the machine code for a code written in C later. for now initialize 
//each entry to be its index * 3 (memory[i] = i * 3;)
//all you need to do is give an address as input and read the contents of the 
//address on your output port. 
// 
//Using a 32bit address you will index into the memory, output the contents of that specific 
//address. for data memory we are using 1K word of storage space. for the instruction memory 
//you may assume smaller size for practical purpose. you can use 128 words as the size and 
//hardcode the values.  in this case you need 7 bits to index into the memory. 
//
//be careful with the least two significant bits of the 32bit address. those help us index 
//into one of the 4 bytes in a word. therefore you will need to use bit [8-2] of the input address. 


////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(Address, Instruction); 

    input [31:0] Address;        // Input Address 

    output reg [31:0] Instruction;    // Instruction at memory location Address
    
    reg [31:0] memory [0:127];
    
    integer i;
    
    initial begin
        memory[0] <= 32'h2008fffd;	//		addi	$t0, $0, -3

        memory[1] <= 32'h00000000;	//		nop

        memory[2] <= 32'h00000000;	//		nop

        memory[3] <= 32'h00000000;	//		nop

        memory[4] <= 32'h00000000;	//		nop

        memory[5] <= 32'h01084820;	//		add	$t1, $t0, $t0

        memory[6] <= 32'h00000000;	//		nop

        memory[7] <= 32'h00000000;	//		nop

        memory[8] <= 32'h00000000;	//		nop

        memory[9] <= 32'h00000000;	//		nop

        memory[10] <= 32'h210afffc;	//		addi	$t2, $t0, -4

        memory[11] <= 32'h00000000;	//		nop

        memory[12] <= 32'h00000000;	//		nop

        memory[13] <= 32'h00000000;	//		nop

        memory[14] <= 32'h00000000;	//		nop

        memory[15] <= 32'h254affff;	//		addiu	$t2, $t2, 0xFFFF

        memory[16] <= 32'h00000000;	//		nop

        memory[17] <= 32'h00000000;	//		nop

        memory[18] <= 32'h00000000;	//		nop

        memory[19] <= 32'h00000000;	//		nop

        memory[20] <= 32'h200bffff;	//		addi	$t3, $0, -1

        memory[21] <= 32'h00000000;	//		nop

        memory[22] <= 32'h00000000;	//		nop

        memory[23] <= 32'h00000000;	//		nop

        memory[24] <= 32'h00000000;	//		nop

        memory[25] <= 32'h014b5021;	//		addu	$t2, $t2, $t3

        memory[26] <= 32'h00000000;	//		nop

        memory[27] <= 32'h00000000;	//		nop

        memory[28] <= 32'h00000000;	//		nop

        memory[29] <= 32'h00000000;	//		nop

        memory[30] <= 32'h01495022;	//		sub	$t2, $t2, $t1

        memory[31] <= 32'h00000000;	//		nop

        memory[32] <= 32'h00000000;	//		nop

        memory[33] <= 32'h00000000;	//		nop

        memory[34] <= 32'h00000000;	//		nop

        memory[35] <= 32'h200c0fad;	//		addi	$t4, $0, 0x0FAD

        memory[36] <= 32'h00000000;	//		nop

        memory[37] <= 32'h00000000;	//		nop

        memory[38] <= 32'h00000000;	//		nop

        memory[39] <= 32'h00000000;	//		nop

        memory[40] <= 32'h718c5002;	//		mul	$t2, $t4, $t4

        memory[41] <= 32'h00000000;	//		nop

        memory[42] <= 32'h00000000;	//		nop

        memory[43] <= 32'h00000000;	//		nop

        memory[44] <= 32'h00000000;	//		nop

        memory[45] <= 32'h014a0018;	//		mult	$t2, $t2

        memory[46] <= 32'h00000000;	//		nop

        memory[47] <= 32'h00000000;	//		nop

        memory[48] <= 32'h00000000;	//		nop

        memory[49] <= 32'h00000000;	//		nop

        memory[50] <= 32'h018a0019;	//		multu	$t4, $t2

        memory[51] <= 32'h00000000;	//		nop

        memory[52] <= 32'h00000000;	//		nop

        memory[53] <= 32'h00000000;	//		nop

        memory[54] <= 32'h00000000;	//		nop

        memory[55] <= 32'h718a0000;	//		madd	$t4, $t2

        memory[56] <= 32'h00000000;	//		nop

        memory[57] <= 32'h00000000;	//		nop

        memory[58] <= 32'h00000000;	//		nop

        memory[59] <= 32'h00000000;	//		nop

        memory[60] <= 32'h718a0004;	//		msub	$t4, $t2

        memory[61] <= 32'h00000000;	//		nop

        memory[62] <= 32'h00000000;	//		nop

        memory[63] <= 32'h00000000;	//		nop

        memory[64] <= 32'h00000000;	//		nop

        memory[65] <= 32'hac0c0004;	//		sw	$t4, 4($0)

        memory[66] <= 32'h00000000;	//		nop

        memory[67] <= 32'h00000000;	//		nop

        memory[68] <= 32'h00000000;	//		nop

        memory[69] <= 32'h00000000;	//		nop

        memory[70] <= 32'h8c0d0004;	//		lw	$t5, 4($0)

        memory[71] <= 32'h00000000;	//		nop

        memory[72] <= 32'h00000000;	//		nop

        memory[73] <= 32'h00000000;	//		nop

        memory[74] <= 32'h00000000;	//		nop

        memory[75] <= 32'ha00a0004;	//		sb	$t2, 4($0)

        memory[76] <= 32'h00000000;	//		nop

        memory[77] <= 32'h00000000;	//		nop

        memory[78] <= 32'h00000000;	//		nop

        memory[79] <= 32'h00000000;	//		nop

        memory[80] <= 32'ha40a0006;	//		sh	$t2, 6($0)

        memory[81] <= 32'h00000000;	//		nop

        memory[82] <= 32'h00000000;	//		nop

        memory[83] <= 32'h00000000;	//		nop

        memory[84] <= 32'h00000000;	//		nop

        memory[85] <= 32'h860d0006;	//		lh	$t5, 6($s0)

        memory[86] <= 32'h00000000;	//		nop

        memory[87] <= 32'h00000000;	//		nop

        memory[88] <= 32'h00000000;	//		nop

        memory[89] <= 32'h00000000;	//		nop

        memory[90] <= 32'h820d0005;	//		lb	$t5, 5($s0)

        memory[91] <= 32'h00000000;	//		nop

        memory[92] <= 32'h00000000;	//		nop

        memory[93] <= 32'h00000000;	//		nop

        memory[94] <= 32'h00000000;	//		nop

        memory[95] <= 32'h3c0dabcd;	//		lui	$t5, 0xABCD

        memory[96] <= 32'h00000000;	//		nop

        memory[97] <= 32'h00000000;	//		nop

        memory[98] <= 32'h00000000;	//		nop

        memory[99] <= 32'h00000000;	//		nop

        memory[100] <= 32'h00000000;	//		nop

        memory[101] <= 32'h00000000;	//		nop

        memory[102] <= 32'h00000000;	//		nop

        memory[103] <= 32'h00000000;	//		nop

        memory[104] <= 32'h00000000;	//		nop

        memory[105] <= 32'h2008aaaa;	//		addi	$t0, $0, 0xAAAA

        memory[106] <= 32'h00000000;	//		nop

        memory[107] <= 32'h00000000;	//		nop

        memory[108] <= 32'h00000000;	//		nop

        memory[109] <= 32'h00000000;	//		nop

        memory[110] <= 32'h00000000;	//		nop

        memory[111] <= 32'h00000000;	//		nop

        memory[112] <= 32'h00000000;	//		nop

        memory[113] <= 32'h00000000;	//		nop

        memory[114] <= 32'h00000000;	//		nop

        memory[115] <= 32'h20099999;	//		addi	$t1, $0, 0x9999

        memory[116] <= 32'h00000000;	//		nop

        memory[117] <= 32'h00000000;	//		nop

        memory[118] <= 32'h00000000;	//		nop

        memory[119] <= 32'h00000000;	//		nop

        memory[120] <= 32'h01095024;	//		and	$t2, $t0, $t1

        memory[121] <= 32'h00000000;	//		nop

        memory[122] <= 32'h00000000;	//		nop

        memory[123] <= 32'h00000000;	//		nop

        memory[124] <= 32'h00000000;	//		nop

        memory[125] <= 32'h310a7777;	//		andi	$t2, $t0, 0x7777

        memory[126] <= 32'h00000000;	//		nop

        memory[127] <= 32'h00000000;	//		nop

        memory[128] <= 32'h00000000;	//		nop

        memory[129] <= 32'h00000000;	//		nop

        memory[130] <= 32'h01095025;	//		or	$t2, $t0, $t1

        memory[131] <= 32'h00000000;	//		nop

        memory[132] <= 32'h00000000;	//		nop

        memory[133] <= 32'h00000000;	//		nop

        memory[134] <= 32'h00000000;	//		nop

        memory[135] <= 32'h01095027;	//		nor	$t2, $t0, $t1

        memory[136] <= 32'h00000000;	//		nop

        memory[137] <= 32'h00000000;	//		nop

        memory[138] <= 32'h00000000;	//		nop

        memory[139] <= 32'h00000000;	//		nop

        memory[140] <= 32'h01095026;	//		xor	$t2, $t0, $t1

        memory[141] <= 32'h00000000;	//		nop

        memory[142] <= 32'h00000000;	//		nop

        memory[143] <= 32'h00000000;	//		nop

        memory[144] <= 32'h00000000;	//		nop

        memory[145] <= 32'h350a7777;	//		ori	$t2, $t0, 0x7777

        memory[146] <= 32'h00000000;	//		nop

        memory[147] <= 32'h00000000;	//		nop

        memory[148] <= 32'h00000000;	//		nop

        memory[149] <= 32'h00000000;	//		nop

        memory[150] <= 32'h390a7777;	//		xori	$t2, $t0, 0x7777

        memory[151] <= 32'h00000000;	//		nop

        memory[152] <= 32'h00000000;	//		nop

        memory[153] <= 32'h00000000;	//		nop

        memory[154] <= 32'h00000000;	//		nop

        memory[155] <= 32'h7c0a5620;	//		seh	$t2, $t2

        memory[156] <= 32'h00000000;	//		nop

        memory[157] <= 32'h00000000;	//		nop

        memory[158] <= 32'h00000000;	//		nop

        memory[159] <= 32'h00000000;	//		nop

        memory[160] <= 32'h000a5080;	//		sll	$t2, $t2, 2

        memory[161] <= 32'h00000000;	//		nop

        memory[162] <= 32'h00000000;	//		nop

        memory[163] <= 32'h00000000;	//		nop

        memory[164] <= 32'h00000000;	//		nop

        memory[165] <= 32'h000a5102;	//		srl	$t2, $t2, 4

        memory[166] <= 32'h00000000;	//		nop

        memory[167] <= 32'h00000000;	//		nop

        memory[168] <= 32'h00000000;	//		nop

        memory[169] <= 32'h00000000;	//		nop

        memory[170] <= 32'h214afff0;	//		addi	$t2, $t2, -16

        memory[171] <= 32'h00000000;	//		nop

        memory[172] <= 32'h00000000;	//		nop

        memory[173] <= 32'h00000000;	//		nop

        memory[174] <= 32'h00000000;	//		nop

        memory[175] <= 32'h014a5004;	//		sllv	$t2, $t2, $t2

        memory[176] <= 32'h00000000;	//		nop

        memory[177] <= 32'h00000000;	//		nop

        memory[178] <= 32'h00000000;	//		nop

        memory[179] <= 32'h00000000;	//		nop

        memory[180] <= 32'h2129fff0;	//		addi	$t1, $t1, -16

        memory[181] <= 32'h00000000;	//		nop

        memory[182] <= 32'h00000000;	//		nop

        memory[183] <= 32'h00000000;	//		nop

        memory[184] <= 32'h00000000;	//		nop

        memory[185] <= 32'h012a5006;	//		srlv	$t2, $t2, $t1

        memory[186] <= 32'h00000000;	//		nop

        memory[187] <= 32'h00000000;	//		nop

        memory[188] <= 32'h00000000;	//		nop

        memory[189] <= 32'h00000000;	//		nop

        memory[190] <= 32'h012a582a;	//		slt	$t3, $t1, $t2

        memory[191] <= 32'h00000000;	//		nop

        memory[192] <= 32'h00000000;	//		nop

        memory[193] <= 32'h00000000;	//		nop

        memory[194] <= 32'h00000000;	//		nop

        memory[195] <= 32'h292bffff;	//		slti	$t3, $t1, 0xFFFF

        memory[196] <= 32'h00000000;	//		nop

        memory[197] <= 32'h00000000;	//		nop

        memory[198] <= 32'h00000000;	//		nop

        memory[199] <= 32'h00000000;	//		nop

        memory[200] <= 32'h012a580b;	//		movn	$t3, $t1, $t2

        memory[201] <= 32'h00000000;	//		nop

        memory[202] <= 32'h00000000;	//		nop

        memory[203] <= 32'h00000000;	//		nop

        memory[204] <= 32'h00000000;	//		nop

        memory[205] <= 32'h0140580b;	//		movn	$t3, $t2, $0

        memory[206] <= 32'h00000000;	//		nop

        memory[207] <= 32'h00000000;	//		nop

        memory[208] <= 32'h00000000;	//		nop

        memory[209] <= 32'h00000000;	//		nop

        memory[210] <= 32'h014b5846;	//		rotrv	$t3, $t3, $t2

        memory[211] <= 32'h00000000;	//		nop

        memory[212] <= 32'h00000000;	//		nop

        memory[213] <= 32'h00000000;	//		nop

        memory[214] <= 32'h00000000;	//		nop

        memory[215] <= 32'h002b58c2;	//		rotr	$t3, $t3, 3

        memory[216] <= 32'h00000000;	//		nop

        memory[217] <= 32'h00000000;	//		nop

        memory[218] <= 32'h00000000;	//		nop

        memory[219] <= 32'h00000000;	//		nop

        memory[220] <= 32'h00095903;	//		sra	$t3, $t1, 4

        memory[221] <= 32'h00000000;	//		nop

        memory[222] <= 32'h00000000;	//		nop

        memory[223] <= 32'h00000000;	//		nop

        memory[224] <= 32'h00000000;	//		nop

        memory[225] <= 32'h01295807;	//		srav	$t3, $t1, $t1

        memory[226] <= 32'h00000000;	//		nop

        memory[227] <= 32'h00000000;	//		nop

        memory[228] <= 32'h00000000;	//		nop

        memory[229] <= 32'h00000000;	//		nop

        memory[230] <= 32'h7c095c20;	//		seb	$t3, $t1

        memory[231] <= 32'h00000000;	//		nop

        memory[232] <= 32'h00000000;	//		nop

        memory[233] <= 32'h00000000;	//		nop

        memory[234] <= 32'h00000000;	//		nop

        memory[235] <= 32'h2d2bffff;	//		sltiu	$t3, $t1, 0xFFFF

        memory[236] <= 32'h00000000;	//		nop

        memory[237] <= 32'h00000000;	//		nop

        memory[238] <= 32'h00000000;	//		nop

        memory[239] <= 32'h00000000;	//		nop

        memory[240] <= 32'h012a582b;	//		sltu	$t3, $t1, $t2

        memory[241] <= 32'h00000000;	//		nop

        memory[242] <= 32'h00000000;	//		nop

        memory[243] <= 32'h00000000;	//		nop

        memory[244] <= 32'h00000000;	//		nop

        memory[245] <= 32'h00005810;	//		mfhi	$t3

        memory[246] <= 32'h00000000;	//		nop

        memory[247] <= 32'h00000000;	//		nop

        memory[248] <= 32'h00000000;	//		nop

        memory[249] <= 32'h00000000;	//		nop

        memory[250] <= 32'h00006012;	//		mflo	$t4

        memory[251] <= 32'h00000000;	//		nop

        memory[252] <= 32'h00000000;	//		nop

        memory[253] <= 32'h00000000;	//		nop

        memory[254] <= 32'h00000000;	//		nop

        memory[255] <= 32'h01800011;	//		mthi	$t4

        memory[256] <= 32'h00000000;	//		nop

        memory[257] <= 32'h00000000;	//		nop

        memory[258] <= 32'h00000000;	//		nop

        memory[259] <= 32'h00000000;	//		nop

        memory[260] <= 32'h01600013;	//		mtlo	$t3

        memory[261] <= 32'h00000000;	//		nop

        memory[262] <= 32'h00000000;	//		nop

        memory[263] <= 32'h00000000;	//		nop

        memory[264] <= 32'h00000000;	//		nop

        memory[265] <= 32'h200b0004;	//		addi	$t3, $0, 4

        memory[266] <= 32'h00000000;	//		nop

        memory[267] <= 32'h00000000;	//		nop

        memory[268] <= 32'h00000000;	//		nop

        memory[269] <= 32'h00000000;	//		nop

        memory[270] <= 32'h216bffff;	//	bgezt3:	addi	$t3, $t3, -1

        memory[271] <= 32'h00000000;	//		nop

        memory[272] <= 32'h00000000;	//		nop

        memory[273] <= 32'h00000000;	//		nop

        memory[274] <= 32'h00000000;	//		nop

        memory[275] <= 32'h00000000;	//	bgez	nop

        memory[276] <= 32'h00000000;	//		nop

        memory[277] <= 32'h00000000;	//		nop

        memory[278] <= 32'h00000000;	//		nop

        memory[279] <= 32'h00000000;	//		nop

        memory[280] <= 32'h200c0000;	//		addi	$t4, $0, 0

        memory[281] <= 32'h00000000;	//		nop

        memory[282] <= 32'h00000000;	//		nop

        memory[283] <= 32'h00000000;	//		nop

        memory[284] <= 32'h00000000;	//		nop

        memory[285] <= 32'h216b0001;	//	beqt3:	addi	$t3, $t3, 1

        memory[286] <= 32'h00000000;	//		nop

        memory[287] <= 32'h00000000;	//		nop

        memory[288] <= 32'h00000000;	//		nop

        memory[289] <= 32'h00000000;	//		nop

        memory[290] <= 32'h116cfffa;	//		beq	$t3, $t4, beqt3

        memory[291] <= 32'h00000000;	//		nop

        memory[292] <= 32'h00000000;	//		nop

        memory[293] <= 32'h00000000;	//		nop

        memory[294] <= 32'h00000000;	//		nop

        memory[295] <= 32'h200cffff;	//		addi	$t4, $0, -1

        memory[296] <= 32'h00000000;	//		nop

        memory[297] <= 32'h00000000;	//		nop

        memory[298] <= 32'h00000000;	//		nop

        memory[299] <= 32'h00000000;	//		nop

        memory[300] <= 32'h218c0001;	//	bnet4:	addi	$t4, $t4, 1

        memory[301] <= 32'h00000000;	//		nop

        memory[302] <= 32'h00000000;	//		nop

        memory[303] <= 32'h00000000;	//		nop

        memory[304] <= 32'h00000000;	//		nop

        memory[305] <= 32'h156cfffa;	//		bne	$t3, $t4, bnet4

        memory[306] <= 32'h00000000;	//		nop

        memory[307] <= 32'h00000000;	//		nop

        memory[308] <= 32'h00000000;	//		nop

        memory[309] <= 32'h00000000;	//		nop

        memory[310] <= 32'h218c0001;	//		addi	$t4, $t4, 1

        memory[311] <= 32'h00000000;	//		nop

        memory[312] <= 32'h00000000;	//		nop

        memory[313] <= 32'h00000000;	//		nop

        memory[314] <= 32'h00000000;	//		nop

        memory[315] <= 32'h218cffff;	//	bgtzt4:	addi	$t4, $t4, -1

        memory[316] <= 32'h00000000;	//		nop

        memory[317] <= 32'h00000000;	//		nop

        memory[318] <= 32'h00000000;	//		nop

        memory[319] <= 32'h00000000;	//		nop

        memory[320] <= 32'h1d80fffa;	//		bgtz	$t4, bgtzt4

        memory[321] <= 32'h00000000;	//		nop

        memory[322] <= 32'h00000000;	//		nop

        memory[323] <= 32'h00000000;	//		nop

        memory[324] <= 32'h00000000;	//		nop

        memory[325] <= 32'h200cffff;	//		addi	$t4, $0, -1

        memory[326] <= 32'h00000000;	//		nop

        memory[327] <= 32'h00000000;	//		nop

        memory[328] <= 32'h00000000;	//		nop

        memory[329] <= 32'h00000000;	//		nop

        memory[330] <= 32'h218c0001;	//	blezt4:	addi	$t4, $t4, 1

        memory[331] <= 32'h00000000;	//		nop

        memory[332] <= 32'h00000000;	//		nop

        memory[333] <= 32'h00000000;	//		nop

        memory[334] <= 32'h00000000;	//		nop

        memory[335] <= 32'h1980fffa;	//		blez	$t4, blezt4

        memory[336] <= 32'h00000000;	//		nop

        memory[337] <= 32'h00000000;	//		nop

        memory[338] <= 32'h00000000;	//		nop

        memory[339] <= 32'h00000000;	//		nop

        memory[340] <= 32'h200cfffe;	//		addi	$t4, $0, -2

        memory[341] <= 32'h00000000;	//		nop

        memory[342] <= 32'h00000000;	//		nop

        memory[343] <= 32'h00000000;	//		nop

        memory[344] <= 32'h00000000;	//		nop

        memory[345] <= 32'h218c0001;	//		addi	$t4, $t4, 1

        memory[346] <= 32'h00000000;	//		nop

        memory[347] <= 32'h00000000;	//		nop

        memory[348] <= 32'h00000000;	//		nop

        memory[349] <= 32'h00000000;	//		nop

        memory[350] <= 32'h0580fffe;	//		bltz	$t4, -2

        memory[351] <= 32'h00000000;	//		nop

        memory[352] <= 32'h00000000;	//		nop

        memory[353] <= 32'h00000000;	//		nop

        memory[354] <= 32'h00000000;	//		nop

        memory[355] <= 32'h0800016d;	//		j	addit4

        memory[356] <= 32'h00000000;	//		nop

        memory[357] <= 32'h00000000;	//		nop

        memory[358] <= 32'h00000000;	//		nop

        memory[359] <= 32'h00000000;	//		nop

        memory[360] <= 32'h218c0001;	//		addi	$t4, $t4, 1

        memory[361] <= 32'h00000000;	//		nop

        memory[362] <= 32'h00000000;	//		nop

        memory[363] <= 32'h00000000;	//		nop

        memory[364] <= 32'h00000000;	//		nop

        memory[365] <= 32'h218c0001;	//	addit4:	addi	$t4, $t4, 1

        memory[366] <= 32'h00000000;	//		nop

        memory[367] <= 32'h00000000;	//		nop

        memory[368] <= 32'h00000000;	//		nop

        memory[369] <= 32'h00000000;	//		nop

        memory[370] <= 32'h200c0181;	//		addi	$t4, $0, 385

        memory[371] <= 32'h00000000;	//		nop

        memory[372] <= 32'h00000000;	//		nop

        memory[373] <= 32'h00000000;	//		nop

        memory[374] <= 32'h00000000;	//		nop

        memory[375] <= 32'h01800008;	//		jr	$t4

        memory[376] <= 32'h00000000;	//		nop

        memory[377] <= 32'h00000000;	//		nop

        memory[378] <= 32'h00000000;	//		nop

        memory[379] <= 32'h00000000;	//		nop

        memory[380] <= 32'h218c0001;	//		addi	$t4, $t4, 1

        memory[381] <= 32'h00000000;	//		nop

        memory[382] <= 32'h00000000;	//		nop

        memory[383] <= 32'h00000000;	//		nop

        memory[384] <= 32'h00000000;	//		nop

        memory[385] <= 32'h218c0001;	//		addi	$t4, $t4, 1

        memory[386] <= 32'h00000000;	//		nop

        memory[387] <= 32'h00000000;	//		nop

        memory[388] <= 32'h00000000;	//		nop

        memory[389] <= 32'h00000000;	//		nop

        memory[390] <= 32'h200d0004;	//		addi	$t5, $0, 4

        memory[391] <= 32'h00000000;	//		nop

        memory[392] <= 32'h00000000;	//		nop

        memory[393] <= 32'h00000000;	//		nop

        memory[394] <= 32'h00000000;	//		nop

        memory[395] <= 32'h15a00013;	//		bne	$t5, $0, jalra

        memory[396] <= 32'h00000000;	//		nop

        memory[397] <= 32'h00000000;	//		nop

        memory[398] <= 32'h00000000;	//		nop

        memory[399] <= 32'h00000000;	//		nop

        memory[400] <= 32'h21adfffc;	//		addi	$t5, $t5, -4

        memory[401] <= 32'h00000000;	//		nop

        memory[402] <= 32'h00000000;	//		nop

        memory[403] <= 32'h00000000;	//		nop

        memory[404] <= 32'h00000000;	//		nop

        memory[405] <= 32'h21adfffc;	//	addit5:	addi	$t5, $t5, -4

        memory[406] <= 32'h00000000;	//		nop

        memory[407] <= 32'h00000000;	//		nop

        memory[408] <= 32'h00000000;	//		nop

        memory[409] <= 32'h00000000;	//		nop

        memory[410] <= 32'h03e00008;	//		jr	$ra

        memory[411] <= 32'h00000000;	//		nop

        memory[412] <= 32'h00000000;	//		nop

        memory[413] <= 32'h00000000;	//		nop

        memory[414] <= 32'h00000000;	//		nop

        memory[415] <= 32'h0c000195;	//	jalra:	jal	addit5

        memory[416] <= 32'h00000000;	//		nop

        memory[417] <= 32'h00000000;	//		nop

        memory[418] <= 32'h00000000;	//		nop

        memory[419] <= 32'h00000000;	//		nop

        memory[420] <= 32'h218c0001;	//		addi	$t4, $t4, 1

        memory[421] <= 32'h00000000;	//		nop

        memory[422] <= 32'h00000000;	//		nop

        memory[423] <= 32'h00000000;	//		nop

        memory[424] <= 32'h00000000;	//		nop

    end
    
    always @* begin
        Instruction <= memory[Address[8:2]];
    end
    
    
        

endmodule
