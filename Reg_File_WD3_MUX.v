module Reg_File_WD3_MUX 

#(
	parameter DATA_WIDTH = 32
)
(	
	input								REG_FILE_WD3_SEL,	//MemtoReg
	input 			[DATA_WIDTH-1:0]	Data_Mem_RD,
	input 			[DATA_WIDTH-1:0]	ALU_Result,

	output	reg 	[DATA_WIDTH-1:0]	Reg_File_WD3
);

always @(*) begin 
	
	if (REG_FILE_WD3_SEL) begin // only at lw instruction

		Reg_File_WD3 = Data_Mem_RD;
	end

	else begin // at R-Type instuctions
		Reg_File_WD3 = ALU_Result;
	end
end

endmodule : Reg_File_WD3_MUX