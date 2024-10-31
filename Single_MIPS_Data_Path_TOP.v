module Single_MIPS_Data_Path_TOP 

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
	input 						REG_FILE_WR_EN,		// Reg_Write
	input 						REG_FILE_WD3_SEL,	// Mem_to_Reg
	input 						REG_FILE_A3_SEL,	// Reg_Dst
	input 	[2:0]				ALU_CTRL,			// ALU_Control
	input 						ALU_SRC_B_SEL,		// ALU_Src
	input 						PC_SRC_SEL,			// Branch_flag & zero flag
	input 						JUMP,				

	output						Zero_Flag,
	output	[ADDR_WIDTH-1:0]	PC_to_ins_mem,		// PC
	output	[DATA_WIDTH-1:0]	ALU_Result,			// ALU_Out
	output	[DATA_WIDTH-1:0]	reg_file_RD2		// RD2 to WD of data memory
);

/***********************************************************************
************************* Internal Wires *******************************		
***********************************************************************/

////////////////////// PC Internal Wires ///////////////////////
wire [ADDR_WIDTH-1:0]	//PC_to_ins_mem_wr,
						PC_Plus_4_wr,
	 					PC_Branch_wr,
	 					New_PC_wr,
	 					New_PC_2_wr;

////////////////////// Reg File Internal Wires ///////////////////////
wire [DATA_WIDTH-1:0]	reg_file_RD1_wr,
	 					Reg_File_WD3_wr;

wire [4:0]			 	Reg_File_A3_wr;

////////////////////// Sign Extend Internal Wires ///////////////////////
wire [DATA_WIDTH-1:0]	signd_immediate_field_wr;

////////////////////// ALU Internal Wires ///////////////////////
wire [DATA_WIDTH-1:0]	ALU_Src_B_wr;

/***********************************************************************
*********************** Blocks Connections *****************************		
***********************************************************************/

////////////////////// Program Counter //////////////////////
Single_MIPS_Program_Counter #(.ADDR_WIDTH(ADDR_WIDTH))	PC 
(
.CLK             (CLK),
.RST_N           (RST_N),
.next_ins_addr   (New_PC_2_wr), /* see here */
.current_ins_addr(PC_to_ins_mem) //////**/////// output to ins memory
);

////////////////////// PC_Adder //////////////////////
PC_Adder #(.ADDR_WIDTH(ADDR_WIDTH)) PC_Adder
(
.Current_PC(PC_to_ins_mem),      //////**/////// wire
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
.PC_SRC_SEL(PC_SRC_SEL),
.PC_Branch (PC_Branch_wr),
.PC_Plus_4 (PC_Plus_4_wr),
.New_PC    (New_PC_wr) /* see here */
);

//////////////////// PC_Jump_MUX ////////////////////
PC_Jump_MUX #(.ADDR_WIDTH(ADDR_WIDTH))	PC_Jump_MUX
(
.JUMP                   (JUMP),
.Jump_addr              ({(PC_Plus_4_wr[31:28]), (ins_mem_RD[25:0]), 2'b00}),
.PC_Branch_PLUS4_MUX_out(New_PC_wr),   /**/
.New_PC_2               (New_PC_2_wr) /**/
);

/////////////////// Reg_File_A3_MUX ///////////////////
Reg_File_A3_MUX RF_A3_MUX
(
.REG_FILE_A3_SEL(REG_FILE_A3_SEL),  /* debug error (it was wire not input REG_FILE_A3_SEL_wr)*/
.rd_field       (ins_mem_RD[15:11]),
.rt_field       (ins_mem_RD[20:16]),
.Reg_File_A3    (Reg_File_A3_wr)
);

/////////////////// Sign Extend ///////////////////
Single_MIPS_Sign_Extend Sign_Extend 
(
.immediate_field      (ins_mem_RD[15:0]),
.signd_immediate_field(signd_immediate_field_wr)
);

/////////////////////// register File ///////////////////////
Single_MIPS_Reg_File #(.REG_FILE_DEPTH(REG_FILE_DEPTH), .DATA_WIDTH(DATA_WIDTH)) Reg_File
(
.CLK         (CLK),
//.RST_N       (RST_N),
.WR_EN       (REG_FILE_WR_EN),	//reg_write
.input_addr_1(ins_mem_RD[25:21]),
.input_addr_2(ins_mem_RD[20:16]),
.input_addr_3(Reg_File_A3_wr),
.write_data  (Reg_File_WD3_wr),
.read_data_1 (reg_file_RD1_wr),
.read_data_2 (reg_file_RD2)
);

////////////////////////// ALU_Src_B_MUX //////////////////////////
ALU_Src_B_MUX #(.DATA_WIDTH(DATA_WIDTH))	ALU_Src_B_MUX
(
.ALU_SRC_B_SEL        (ALU_SRC_B_SEL),
.signd_immediate_field(signd_immediate_field_wr),
.Reg_File_RD2         (reg_file_RD2),
.ALU_Src_B            (ALU_Src_B_wr)
);

////////////////////////// ALU //////////////////////////
Single_MIPS_ALU #(.DATA_WIDTH(DATA_WIDTH))	ALU
(
//.CLK       (CLK),
//.RST_N     (RST_N),
.ALU_CTRL  (ALU_CTRL),
.src_A     (reg_file_RD1_wr),
.src_B     (ALU_Src_B_wr),
.ALU_Result(ALU_Result),
.Zero_Flag (Zero_Flag)	
);

/////////////////////// Reg_File_WD3_MUX ///////////////////////
Reg_File_WD3_MUX #(.DATA_WIDTH(DATA_WIDTH))	RF_WD3_MUX
(
.REG_FILE_WD3_SEL(REG_FILE_WD3_SEL),
.ALU_Result      (ALU_Result),
.Data_Mem_RD  	 (data_mem_RD),
.Reg_File_WD3    (Reg_File_WD3_wr)	
);

endmodule : Single_MIPS_Data_Path_TOP