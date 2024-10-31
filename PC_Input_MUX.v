module PC_Input_MUX 

# (
	parameter ADDR_WIDTH = 32
)	
(
	input 								PC_SRC_SEL,
	input 			[ADDR_WIDTH-1:0]	PC_Branch,
	input 			[ADDR_WIDTH-1:0]	PC_Plus_4,

	output 	reg 	[ADDR_WIDTH-1:0]	New_PC	//PC'
);


always @(*) begin 
	
	if (PC_SRC_SEL) begin // only at beq instruction

		New_PC = PC_Branch;
	end

	else begin 
		New_PC = PC_Plus_4;
	end
end

endmodule : PC_Input_MUX