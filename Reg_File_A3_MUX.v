module Reg_File_A3_MUX (	
	
	input					REG_FILE_A3_SEL, // RegDst
	input		 	[4:0]	rd_field, 		 // instr_addr[15:11]
	input 			[4:0]	rt_field,		 // instr_addr[20:16]

	output	reg 	[4:0]	Reg_File_A3
);

always @(*) begin 
	
	if (REG_FILE_A3_SEL) begin // at R-Type instuctions

		Reg_File_A3 = rd_field;
	end

	else begin // only at lw instruction
		Reg_File_A3 = rt_field;
	end
end

endmodule : Reg_File_A3_MUX