module ALU_Src_B_MUX 

#(
	parameter DATA_WIDTH = 32
)
(	
	input								ALU_SRC_B_SEL,	// ALUSrc
	input 			[DATA_WIDTH-1:0]	Reg_File_RD2,
	input 			[DATA_WIDTH-1:0]	signd_immediate_field,

	output	reg 	[DATA_WIDTH-1:0]	ALU_Src_B
	
);

always @(*) begin 
	
	if (ALU_SRC_B_SEL) begin // only at lw and sw instructions

		ALU_Src_B = signd_immediate_field;
	end

	else begin // at R-Type instuctions
		ALU_Src_B = Reg_File_RD2;
	end
end

endmodule : ALU_Src_B_MUX