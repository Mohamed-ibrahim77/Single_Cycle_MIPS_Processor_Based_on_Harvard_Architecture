module Single_MIPS_Control_Unit_TOP (

	input 	[5:0]	OP_CODE, 			// intr_addr[31:26]
	input 	[5:0]	FUNCT,				// intr_addr[5:0]
	input 			ZERO_FLAG,			// not an input to any module in the control unit

	output 			REG_FILE_WR_EN,		// Reg_Write
	output 			REG_FILE_WD3_SEL,	// Mem_to_Reg
	output 			REG_FILE_A3_SEL,	// Reg_Dst
	output 	[2:0]	ALU_CTRL,			// ALU_Control
	output 			ALU_SRC_B_SEL,		// ALU_Src
	//output 			BRANCH,				// Branch_flag
	output 			PC_SRC,
	output			JUMP,
	output 			DATA_MEM_WR_EN		// Mem_Write	
);

wire [1:0]  ALU_OP_wr;
wire 		BRANCH_wr;

////////////////////// Main_Decoder ///////////////////////
Single_MIPS_Main_Decoder	 Main_Decoder 
(
.OP_CODE         (OP_CODE),
.REG_FILE_WR_EN  (REG_FILE_WR_EN),
.REG_FILE_WD3_SEL(REG_FILE_WD3_SEL),
.REG_FILE_A3_SEL (REG_FILE_A3_SEL),
.ALU_SRC_B_SEL   (ALU_SRC_B_SEL),
.BRANCH          (BRANCH_wr),
.JUMP			 (JUMP),
.DATA_MEM_WR_EN  (DATA_MEM_WR_EN),
.ALU_OP          (ALU_OP_wr)	
);

////////////////////// ALU_Decoder ///////////////////////
Single_MIPS_ALU_Decoder		ALU_Decoder
(
.ALU_OP  (ALU_OP_wr),
.FUNCT   (FUNCT),
.ALU_CTRL(ALU_CTRL)
); 

assign PC_SRC = BRANCH_wr & ZERO_FLAG;

endmodule : Single_MIPS_Control_Unit_TOP