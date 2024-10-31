module Single_MIPS_With_External_Memory_TOP_TB ();

	parameter 	ADDR_WIDTH = 32,
				DATA_WIDTH = 32,
				REG_FILE_DEPTH = 32;

	reg 						CLK_TB;    			// Clock
	reg							RST_N_TB;  			// Asynchronous reset active low	

	wire	[DATA_WIDTH-1:0]	reg_file_RD2_TB;    // writ_data
	wire	[ADDR_WIDTH-1:0]	ALU_Result_TB;	    // data_addr
	wire						DATA_MEM_WR_EN_TB;  // mem_write

// instantiate device to be tested
Single_MIPS_With_External_Memory_TOP	#(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH),.REG_FILE_DEPTH(REG_FILE_DEPTH))	
DUT
(
.CLK  		   (CLK_TB),
.RST_N   	   (RST_N_TB),
.reg_file_RD2  (reg_file_RD2_TB),
.ALU_Result	   (ALU_Result_TB),
.DATA_MEM_WR_EN(DATA_MEM_WR_EN_TB)
); 	
	
// initialize test
initial begin
	RST_N_TB <= 0;
	# 22;
	RST_N_TB <= 1;
end

// generate clock to sequence tests
always begin
	CLK_TB <= 1; 
	# 5; 
	CLK_TB <= 0; 
	# 5;
end

initial begin

	$readmemh("machine_code_ins_mem_file.dat", DUT.Instruction_Memory.INS_MEM);
end

// check results
always @(negedge CLK_TB) begin
	
	$display("PC = %d, Instr = %h, ALUResult = %d, WriteData = %d, DataAddress = %d, MemWrite = %b",
			DUT.PC_to_ins_mem_wr, DUT.ins_mem_RD_wr, DUT.ALU_Result, reg_file_RD2_TB, ALU_Result_TB, DATA_MEM_WR_EN_TB);

	if (DATA_MEM_WR_EN_TB) begin
		if (ALU_Result_TB === 84 & reg_file_RD2_TB === 7) begin
			$display("Simulation succeeded value (7) is written in address (84)");
			$stop;
		end
		else if (ALU_Result_TB !== 80) begin
			$display("Simulation failed");
			$stop;
		end
	end
end	

endmodule : Single_MIPS_With_External_Memory_TOP_TB

