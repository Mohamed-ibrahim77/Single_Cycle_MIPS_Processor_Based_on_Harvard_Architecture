module Single_MIPS_With_External_Memory_TOP 

#(
	parameter 	ADDR_WIDTH = 32,
				DATA_WIDTH = 32,
				REG_FILE_DEPTH = 32
)(	
	input 					CLK,     		// Clock
	input 					RST_N,   		// Asynchronous reset active low	

	output [DATA_WIDTH-1:0]	reg_file_RD2,   // writ_data
	output [ADDR_WIDTH-1:0]	ALU_Result,	    // data_addr
	output 					DATA_MEM_WR_EN  // mem_write
);

/***********************************************************************
************************* Internal Wires *******************************		
***********************************************************************/

////////////////////// MIPS_Processor Internal Wires ///////////////////////	
wire [ADDR_WIDTH-1:0]	PC_to_ins_mem_wr;
//						ALU_Result_wr; // data_addr

//wire [DATA_WIDTH-1:0]	reg_file_RD2_wr; //writ_edata

////////////////////// Ins Mem Internal Wires ///////////////////////

wire [DATA_WIDTH-1:0]	ins_mem_RD_wr;		// ins_addr[25:21] (rs {src_reg or base_addr}) 
											// ins_addr[15:0]  (immediate {offest}) 
											// ins_addr[20:16] (rt {dest_reg})
											// ins_addr[15:11] (rd )
											// ins_addr[5:0]   (funct)
											// ins_addr[31:26] (opcode)

////////////////////// Data Memory Internal Wires ///////////////////////	
wire [DATA_WIDTH-1:0]	data_mem_RD_wr;

////////////////////// Control Unit Internal Wires ///////////////////////	
//wire 					DATA_MEM_WR_EN_wr; 	// MEM_Write

/***********************************************************************
*********************** Blocks Connections *****************************		
***********************************************************************/

///////////////////// MIPS_Processor /////////////////////
Single_MIPS_Processor_TOP 	#(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .REG_FILE_DEPTH(REG_FILE_DEPTH)) 
MIPS_Processor
(
.CLK           (CLK),
.RST_N         (RST_N),
.data_mem_RD   (data_mem_RD_wr),
.ins_mem_RD    (ins_mem_RD_wr),
.DATA_MEM_WR_EN(DATA_MEM_WR_EN),
.PC_to_ins_mem (PC_to_ins_mem_wr),
.ALU_Result    (ALU_Result),
.reg_file_RD2  (reg_file_RD2)	
);

/////////////////// instruction Memory ///////////////////
Single_MIPS_Ins_Memory #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))	
Instruction_Memory
(
.ins_addr (PC_to_ins_mem_wr[7:2]),
.read_data(ins_mem_RD_wr)	
);

/////////////////////// Data Memory ///////////////////////
Single_MIPS_Data_Memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) 
Data_Memory
(
.CLK       (CLK),
//.RST_N     (RST_N),
.WR_EN     (DATA_MEM_WR_EN),
.input_addr(ALU_Result),
.write_data(reg_file_RD2),
.read_data (data_mem_RD_wr)
);

endmodule : Single_MIPS_With_External_Memory_TOP