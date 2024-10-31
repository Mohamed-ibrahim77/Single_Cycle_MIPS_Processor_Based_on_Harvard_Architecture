module Single_MIPS_Processor_TOP 

#(
	parameter 	ADDR_WIDTH = 32,
				DATA_WIDTH = 32,
				REG_FILE_DEPTH = 32
)
(
	input 						CLK,    			// Clock
	input 						RST_N,  			// Asynchronous reset active low
	input 	[DATA_WIDTH-1:0]	data_mem_RD,
	input 	[DATA_WIDTH-1:0]	ins_mem_RD,
 	
 	output						DATA_MEM_WR_EN,		// Mem_Write
	output	[ADDR_WIDTH-1:0]	PC_to_ins_mem,		// PC
	output	[DATA_WIDTH-1:0]	ALU_Result,			// ALU_Out
	output	[DATA_WIDTH-1:0]	reg_file_RD2		// RD2 to WD of data memory (Write_data)
);	

/***********************************************************************
************************* Internal Wires *******************************		
***********************************************************************/

/////////////////// Control Unit to Data Path Wires ////////////////////
wire 			REG_FILE_WR_EN_wr,	// Reg_Write
 				REG_FILE_WD3_SEL_wr,// Mem_to_Reg
 				REG_FILE_A3_SEL_wr,	// Reg_Dst
 				ALU_SRC_B_SEL_wr,	// ALU_Src
 				//BRANCH_wr,			// Branch_flag
 				Zero_Flag_wr,		// Zero_flag
 				PC_SRC_wr,
 				JUMP_wr;
 				//DATA_MEM_WR_EN_wr;	// Mem_Write

wire 	[2:0]	ALU_CTRL_wr;		// ALU_Control

/***********************************************************************
*********************** Blocks Connections *****************************		
***********************************************************************/

/////////////////////// Control Unit ///////////////////////
Single_MIPS_Control_Unit_TOP	Control_Unit	
(
.OP_CODE         (ins_mem_RD[31:26]),
.FUNCT           (ins_mem_RD[5:0]),
.ZERO_FLAG       (Zero_Flag_wr),
.REG_FILE_WD3_SEL(REG_FILE_WD3_SEL_wr),
.ALU_CTRL        (ALU_CTRL_wr),
.ALU_SRC_B_SEL   (ALU_SRC_B_SEL_wr),
.REG_FILE_A3_SEL (REG_FILE_A3_SEL_wr),
.JUMP            (JUMP_wr),
//.BRANCH          (BRANCH_wr),
.PC_SRC          (PC_SRC_wr),
.DATA_MEM_WR_EN  (DATA_MEM_WR_EN),
.REG_FILE_WR_EN  (REG_FILE_WR_EN_wr)

);

/////////////////////// Data_Path ///////////////////////
Single_MIPS_Data_Path_TOP 	Data_Path
(
.CLK             (CLK),
.RST_N           (RST_N),
.REG_FILE_WR_EN  (REG_FILE_WR_EN_wr),
.REG_FILE_A3_SEL (REG_FILE_A3_SEL_wr),
.ALU_SRC_B_SEL   (ALU_SRC_B_SEL_wr),
.ALU_CTRL        (ALU_CTRL_wr),
.REG_FILE_WD3_SEL(REG_FILE_WD3_SEL_wr),
.PC_SRC_SEL      (PC_SRC_wr),
.data_mem_RD     (data_mem_RD),
.ins_mem_RD      (ins_mem_RD),
.JUMP            (JUMP_wr),
.Zero_Flag       (Zero_Flag_wr),
.PC_to_ins_mem   (PC_to_ins_mem),
.ALU_Result      (ALU_Result),
.reg_file_RD2    (reg_file_RD2)	
);

endmodule : Single_MIPS_Processor_TOP
