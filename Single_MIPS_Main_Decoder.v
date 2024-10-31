module Single_MIPS_Main_Decoder (

	input 			[5:0]	OP_CODE,			// Opcode (instr_addr[31:26])
		
	output 	reg				REG_FILE_WR_EN,		// Reg_Write
	output 	reg				REG_FILE_WD3_SEL,	// Mem_to_Reg
	output 	reg				REG_FILE_A3_SEL,	// Reg_Dst
	output 	reg				ALU_SRC_B_SEL,		// ALU_Src
	output 	reg				BRANCH,				// Branch_flag
	output  reg				JUMP,	
	output 	reg				DATA_MEM_WR_EN,		// Mem_Write
	output	reg 	[1:0]	ALU_OP 				// ALUOP

);

always @(*) begin 

	case (OP_CODE)
		
		6'b000000 : begin	// R_Type instruction

			REG_FILE_WR_EN = 1;		// Reg_Write
			REG_FILE_WD3_SEL = 0;	// Mem_to_Reg  
			REG_FILE_A3_SEL = 1;	// Reg_Dst
			ALU_SRC_B_SEL = 0;		// ALU_Src
			BRANCH = 0;				// Branch_flag
			DATA_MEM_WR_EN = 0;		// Mem_Write
			ALU_OP = 2'b10; 		// ALUOP			
			JUMP = 0;

		end	
		
		6'b100_011 : begin  // load (lw) instruction

			REG_FILE_WR_EN = 1;		// Reg_Write
			REG_FILE_WD3_SEL = 1;	// Mem_to_Reg
			REG_FILE_A3_SEL = 0;	// Reg_Dst
			ALU_SRC_B_SEL = 1;		// ALU_Src
			BRANCH = 0;				// Branch_flag
			DATA_MEM_WR_EN = 0;		// Mem_Write
			ALU_OP = 2'b00; 		// ALUOP			
			JUMP = 0;

		end	
		
		6'b101_011 : begin  // store (sw) instruction

			REG_FILE_WR_EN = 0;		// Reg_Write
			REG_FILE_WD3_SEL = 1'bx;// Mem_to_Reg
			REG_FILE_A3_SEL = 1'bx;	// Reg_Dst
			ALU_SRC_B_SEL = 1;		// ALU_Src
			BRANCH = 0;				// Branch_flag
			DATA_MEM_WR_EN = 1;		// Mem_Write
			ALU_OP = 2'b00; 		// ALUOP			
			JUMP = 0;

		end	
		
		6'b000_100 : begin  // beq instruction

			REG_FILE_WR_EN = 0;		// Reg_Write
			REG_FILE_WD3_SEL = 1'bx;// Mem_to_Reg
			REG_FILE_A3_SEL = 1'bx; // Reg_Dst
			ALU_SRC_B_SEL = 0;		// ALU_Src
			BRANCH = 1;				// Branch_flag
			DATA_MEM_WR_EN = 0;		// Mem_Write
			ALU_OP = 2'b01; 		// ALUOP			
			JUMP = 0;

		end	
		
		6'b001_000 : begin  // addi instruction

			REG_FILE_WR_EN = 1;		// Reg_Write
			REG_FILE_WD3_SEL = 0;	// Mem_to_Reg
			REG_FILE_A3_SEL = 0;	// Reg_Dst
			ALU_SRC_B_SEL = 1;		// ALU_Src
			BRANCH = 0;				// Branch_flag
			DATA_MEM_WR_EN = 0;		// Mem_Write
			ALU_OP = 2'b00; 		// ALUOP			
			JUMP = 0;

		end	

		6'b000_010 : begin  // jump instruction

			REG_FILE_WR_EN = 0;		// Reg_Write
			REG_FILE_WD3_SEL = 1'bx;// Mem_to_Reg
			REG_FILE_A3_SEL = 1'bx;	// Reg_Dst
			ALU_SRC_B_SEL = 1'bx;	// ALU_Src
			BRANCH = 1'bx;			// Branch_flag
			DATA_MEM_WR_EN = 0;		// Mem_Write
			ALU_OP = 2'bxx; 		// ALUOP			
			JUMP = 1;
		end	

		default : begin

			REG_FILE_WR_EN = 1'bx;		// Reg_Write
			REG_FILE_WD3_SEL = 1'bx;	// Mem_to_Reg
			REG_FILE_A3_SEL = 1'bx;		// Reg_Dst
			ALU_SRC_B_SEL = 1'bx;		// ALU_Src
			BRANCH = 1'bx;				// Branch_flag
			DATA_MEM_WR_EN = 1'bx;		// Mem_Write
			ALU_OP = 2'bxx; 			// ALUOP			
			JUMP = 1'bx;
		end
	endcase
end
endmodule : Single_MIPS_Main_Decoder