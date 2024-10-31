module PC_Adder 

# (
	parameter ADDR_WIDTH = 32
)
(
	input 	[ADDR_WIDTH-1:0]	Current_PC ,
	
	output	[ADDR_WIDTH-1:0]	PC_Plus_4	// PC' (Next PC)
);

assign PC_Plus_4 = Current_PC + 4;

endmodule : PC_Adder