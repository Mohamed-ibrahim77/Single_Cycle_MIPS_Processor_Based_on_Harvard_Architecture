module Single_MIPS_TOP 

#(
	ADDR_WIDTH = 32,
	DATA_WIDTH = 32,
	REG_FILE_DEPTH = 32
)
(
	input 			CLK,    			// Clock
	input 			RST_N,  			// Asynchronous reset active low
);

/***********************************************************************
************************* Internal Wires *******************************		
***********************************************************************/

////////////////////// PC Internal Wires ///////////////////////
wire [ADDR_WIDTH-1]		PC_to_ins_mem_wr,
	 					PC_Plus_4_wr,
	 					PC_Branch_wr,
	 					New_PC_wr;

////////////////////// Ins Mem Internal Wires ///////////////////////

wire [DATA_WIDTH-1:0]	ins_mem_RD_wr;		// ins_addr[25:21] (rs {src_reg or base_addr}) 
											// ins_addr[15:0]  (immediate {offest}) 
											// ins_addr[20:16] (rt {dest_reg})
											// ins_addr[15:11] (rd )
											// ins_addr[5:0]   (funct)
											// ins_addr[31:26] (opcode)

////////////////////// Reg File Internal Wires ///////////////////////
wire [DATA_WIDTH-1:0]	reg_file_RD1_wr,
	 					reg_file_RD2_wr,
	 					Reg_File_WD3_wr;

wire [4:0]			 	Reg_File_A3_wr;

////////////////////// Sign Extend Internal Wires ///////////////////////
wire [DATA_WIDTH-1:0]	signd_immediate_field_wr;

////////////////////// Data Memory Internal Wires ///////////////////////	
wire [DATA_WIDTH-1:0]	data_mem_RD_wr;

////////////////////// ALU Internal Wires ///////////////////////
wire [DATA_WIDTH-1:0]	ALU_Src_B_wr,
	 					ALU_Result_wr;

wire					Zero_Flag_wr;

////////////////////// Control Unit Internal Wires ///////////////////////
wire 		REG_FILE_WR_EN_wr,	// Reg_Write
 			REG_FILE_WD3_SEL_wr,// Mem_to_Reg
 			REG_FILE_A3_SEL_wr,	// Reg_Dst
 	[2:0]	ALU_CTRL_wr,		// ALU_Control
 			ALU_SRC_B_SEL_wr,	// ALU_Src
 			BRANCH_wr,			// Branch_flag
 			DATA_MEM_WR_EN_wr;	// Mem_Write

/***********************************************************************
*********************** Blocks Connections *****************************		
***********************************************************************/

////////////////////// Program Counter //////////////////////
Single_MIPS_Program_Counter #(.ADDR_WIDTH(ADDR_WIDTH))	PC 
(
.CLK             (CLK),
.RST_N           (RST_N),
.next_ins_addr   (New_PC_wr),
.current_ins_addr(PC_to_ins_mem_wr)
);

////////////////////// PC_Adder //////////////////////
PC_Adder #(.ADDR_WIDTH(ADDR_WIDTH)) PC_Adder
(
.Current_PC(PC_to_ins_mem_wr),
.PC_Plus_4 (PC_Plus_4_wr)	
);

////////////////////// PC_BEQ_Adder //////////////////////
PC_BEQ_Adder #(.ADDR_WIDTH(ADDR_WIDTH))	PC_BEQ_Adder
(
.signd_immediate_field(signd_immediate_field_wr),
.PC_Plus_4            (PC_Plus_4_wr),
.PC_Branch            (PC_Branch_wr)
);

//////////////////// PC_Input_MUX ////////////////////
PC_Input_MUX #(.ADDR_WIDTH(ADDR_WIDTH))	PC_Input_MUX
(
.PC_SRC_SEL(Zero_Flag_wr & BRANCH_wr),
.PC_Branch (PC_Branch_wr),
.PC_Plus_4 (PC_Plus_4_wr),
.New_PC    (New_PC_wr)
);

/////////////////// instruction Memory ///////////////////
Single_MIPS_Ins_Memory #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))	Ins_Mem
(
.ins_addr (PC_to_ins_mem_wr),
.read_data(ins_mem_RD_wr)	
);

/////////////////// Reg_File_A3_MUX ///////////////////
Reg_File_A3_MUX RF_A3_MUX
(
.REG_FILE_A3_SEL(REG_FILE_A3_SEL_wr),
.rd_field       (ins_mem_RD[15:11]),
.rt_field       (ins_mem_RD[20:16]),
.Reg_File_A3    (Reg_File_A3_wr)
);

/////////////////// Sign Extend ///////////////////
Single_MIPS_Sign_Extend Sign_Extend 
(
.CLK                  (CLK),
.RST_N                (RST_N),
.immediate_field      (ins_mem_RD[15:0]),
.signd_immediate_field(signd_immediate_field_wr)
);

/////////////////////// register File ///////////////////////
Single_MIPS_Reg_File #(.REG_FILE_DEPTH(REG_FILE_DEPTH), .DATA_WIDTH(DATA_WIDTH)) Reg_File
(
.CLK         (CLK),
.RST_N       (RST_N),
.WR_EN       (REG_FILE_WR_EN_wr),	//reg_write
.input_addr_1(ins_mem_RD_wr[25:21]),
.input_addr_2(ins_mem_RD_wr[20:16]),
.input_addr_3(Reg_File_A3_wr),
.write_data  (Reg_File_WD3_wr),
.read_data_1 (reg_file_RD1_wr),
.read_data_2 (reg_file_RD2_wr)
);

////////////////////////// ALU_Src_B_MUX //////////////////////////
ALU_Src_B_MUX #(.DATA_WIDTH(DATA_WIDTH))	ALU_Src_B_MUX
(
.ALU_SRC_B_SEL        (ALU_SRC_B_SEL_wr),
.signd_immediate_field(signd_immediate_field_wr),
.Reg_File_RD2         (reg_file_RD2_wr),
.ALU_Src_B            (ALU_Src_B_wr)
);

////////////////////////// ALU //////////////////////////
Single_MIPS_ALU #(.DATA_WIDTH(DATA_WIDTH))	ALU
(
//.CLK       (CLK),
//.RST_N     (RST_N),
.ALU_CTRL  (ALU_CTRL_wr),
.src_A     (reg_file_RD1_wr),
.src_B     (ALU_Src_B_wr),
.ALU_Result(ALU_Result_wr),
.Zero_Flag (Zero_Flag_wr)	
);

/////////////////////// Data Memory ///////////////////////
Single_MIPS_Data_Memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) Data_Mem
(
.CLK       (CLK),
.RST_N     (RST_N),
.WR_EN     (DATA_MEM_WR_EN_wr),
.input_addr(ALU_Result_wr),
.write_data(reg_file_RD2_wr),
.read_data (data_mem_RD_wr)
);

/////////////////////// Reg_File_WD3_MUX ///////////////////////
Reg_File_WD3_MUX #(.DATA_WIDTH(DATA_WIDTH))	RF_WD3_MUX
(
.REG_FILE_WD3_SEL(REG_FILE_WD3_SEL_wr),
.ALU_Result      (ALU_Result_wr),
.data_mem_RD_wr  (data_mem_RD_wr),
.Reg_File_WD3    (Reg_File_WD3_wr)	
);

/////////////////////// Control Unit ///////////////////////
Single_MIPS_Control_Unit_TOP	Control_Unit	
(
.OP_CODE         (ins_mem_RD_wr[31:26]),
.FUNCT           (ins_mem_RD_wr[5:0]),
.REG_FILE_WD3_SEL(REG_FILE_WD3_SEL_wr),
.ALU_CTRL        (ALU_CTRL_wr),
.ALU_SRC_B_SEL   (ALU_SRC_B_SEL_wr),
.REG_FILE_A3_SEL (REG_FILE_A3_SEL_wr),
.BRANCH          (BRANCH_wr),
.DATA_MEM_WR_EN  (DATA_MEM_WR_EN_wr),
.REG_FILE_WR_EN  (REG_FILE_WR_EN_wr)	
);

endmodule : Single_MIPS_TOP
/*
module Single_MIPS_Control_Unit_TOP (

	input 	[5:0]	OP_CODE, 			// intr_addr[31:26]
	input 	[5:0]	FUNCT,				// intr_addr[5:0]
	input 			ZERO_FLAG,

	output 			REG_FILE_WR_EN,		// Reg_Write
	output 			REG_FILE_WD3_SEL,	// Mem_to_Reg
	output 			REG_FILE_A3_SEL,	// Reg_Dst
	output 	[2:0]	ALU_CTRL,			// ALU_Control
	output 			ALU_SRC_B_SEL,		// ALU_Src
	//output 			BRANCH,				// Branch_flag
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
.BRANCH          (BRANCH),
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

endmodule : Single_MIPS_Control_Unit_TOP
*/