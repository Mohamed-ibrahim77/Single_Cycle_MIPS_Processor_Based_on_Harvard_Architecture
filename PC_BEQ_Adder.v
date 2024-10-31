module PC_BEQ_Adder 

# (
	parameter ADDR_WIDTH = 32
)
(
	input 	[ADDR_WIDTH-1:0]	signd_immediate_field, 
	input 	[ADDR_WIDTH-1:0]	PC_Plus_4,	//PC'

	output	[ADDR_WIDTH-1:0]	PC_Branch
);

assign PC_Branch = (signd_immediate_field << 2) + PC_Plus_4; // PC′ = PC + 4 + SignImm × 4

endmodule : PC_BEQ_Adder