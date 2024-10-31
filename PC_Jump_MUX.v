module PC_Jump_MUX 

# (
	parameter ADDR_WIDTH = 32
)	
(
	input 								JUMP,
	input 			[ADDR_WIDTH-1:0]	PC_Branch_PLUS4_MUX_out,
	input 			[ADDR_WIDTH-1:0]	Jump_addr,	//instr_addr[25:0]

	output 	reg 	[ADDR_WIDTH-1:0]	New_PC_2	//PC'
);

always @(*) begin 
	
	if (JUMP) begin // only at jump instruction

		New_PC_2 = Jump_addr;
	end

	else begin 
		New_PC_2 = PC_Branch_PLUS4_MUX_out;
	end
end

endmodule : PC_Jump_MUX