module Single_MIPS_Data_Memory 

#(
	parameter 	ADDR_WIDTH = 32,
				DATA_WIDTH = 32
)
(	
	input 								CLK,    		// Clock
//	input 								RST_N,  		// Asynchronous reset active low
	input 								WR_EN,  		// WE (write enable oe MEM_write)
	input 			[ADDR_WIDTH-1:0]	input_addr,		// A (read port)
	input 			[DATA_WIDTH-1:0]	write_data,		// WD (write port)
	
	output 		 	[DATA_WIDTH-1:0]	read_data		// RD 
);
	
	reg [DATA_WIDTH-1:0] DATA_MEM [ADDR_WIDTH*2-1:0];

// read from data mem (RF read from DM)(load lw instr)
assign read_data = DATA_MEM[input_addr[31:2]];

always @(posedge CLK) begin 

	if(WR_EN) begin // write into data mem (RF write into DM)(store sw instr)
		DATA_MEM[input_addr[31:2]] <= write_data;
	end
	//else begin 
	//	read_data <= DATA_MEM[input_addr];
	//end (wrong because read data is compinantional)
end

endmodule : Single_MIPS_Data_Memory