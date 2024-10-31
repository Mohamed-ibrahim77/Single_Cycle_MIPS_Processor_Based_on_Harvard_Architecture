module Single_MIPS_Program_Counter 

# (
	parameter ADDR_WIDTH = 32
)
(
	input 								CLK,    			// Clock
	input 								RST_N,  			// Asynchronous reset active low
	input 			[ADDR_WIDTH-1:0]	next_ins_addr,		// PC'

	output 	reg 	[ADDR_WIDTH-1:0]	current_ins_addr	// PC
);

always @(posedge CLK or negedge RST_N) begin 
	
	if(~RST_N) begin
		current_ins_addr <= 0;
	end 
	else begin
		current_ins_addr <= next_ins_addr ; // PC'= PC + 4
	end
end

endmodule : Single_MIPS_Program_Counter