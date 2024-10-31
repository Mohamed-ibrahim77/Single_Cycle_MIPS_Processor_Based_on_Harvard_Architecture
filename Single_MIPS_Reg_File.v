module Single_MIPS_Reg_File 

# (
	parameter 	DATA_WIDTH = 32,
				REG_FILE_DEPTH = 32
)
(	
	input 								CLK,    		// Clock
//	input 								RST_N,  		// Asynchronous reset active low
	input 								WR_EN,  		// WE3 (write enable or reg_write)
	input 			[4:0]				input_addr_1,	// A1 (read port 1)
	input 			[4:0]				input_addr_2,	// A2 (read port 2)
	input 			[4:0]				input_addr_3,	// A3 (write port)
	input 			[DATA_WIDTH-1:0]	write_data,		// WD (write port)
	
	output 		 	[DATA_WIDTH-1:0]	read_data_1,	// RD1 
	output 		 	[DATA_WIDTH-1:0]	read_data_2		// RD2
);
	
	reg [DATA_WIDTH-1:0] REG_FILE [REG_FILE_DEPTH-1:0];

always @(posedge CLK) begin 

	if(WR_EN) begin
		REG_FILE[input_addr_3] <= write_data;
	end
	//else begin
	//	read_data_1 <= REG_FILE[input_addr_1];
	//	read_data_2 <= REG_FILE[input_addr_2];
	//end
end

// read is combinantional
assign  read_data_1 = (input_addr_1!=0)? REG_FILE[input_addr_1] : 0;
assign  read_data_2 = (input_addr_2!=0)? REG_FILE[input_addr_2] : 0;

endmodule : Single_MIPS_Reg_File

