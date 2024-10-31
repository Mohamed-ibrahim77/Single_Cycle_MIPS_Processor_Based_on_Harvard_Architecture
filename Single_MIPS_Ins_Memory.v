module Single_MIPS_Ins_Memory 

# (
	parameter 	ADDR_WIDTH = 32,
				DATA_WIDTH = 32
)
(	
	input 		[5:0]	ins_addr,	// A
	
	output 		[DATA_WIDTH-1:0]	read_data	// RD
);

	reg [DATA_WIDTH-1:0] INS_MEM [ADDR_WIDTH*2-1:0];

assign read_data = INS_MEM[ins_addr];

endmodule : Single_MIPS_Ins_Memory