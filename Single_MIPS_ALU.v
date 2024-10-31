module Single_MIPS_ALU 
#(	
	parameter DATA_WIDTH = 32
)(
	input 			[2:0]				ALU_CTRL,  	// Asynchronous reset active low	
	input 			[DATA_WIDTH-1:0]	src_A,		// First  operand
	input 			[DATA_WIDTH-1:0]	src_B,		// Second operand

	output	reg 	[DATA_WIDTH-1:0]	ALU_Result,	
	output	reg 						Zero_Flag	
);
always @(*) begin 
	case (ALU_CTRL)
		
		// and
		3'b000 : begin 

			ALU_Result = src_A & src_B;
		end

		// or
		3'b001 : begin 

			ALU_Result = src_A | src_B;
		end 

		// add the base addr and offest
		3'b010 : begin 

			ALU_Result = src_A + src_B;
		end

		// beq instruction (subtract to get zero flag) 
		3'b110 : begin
			ALU_Result = src_A - src_B;
		end	

		// set less than
		3'b111 : begin
        	ALU_Result = (src_A < src_B) ? 1'b1 : 1'b0;  // Set SLT if src_A < src_B
		end	

		default : begin
			ALU_Result = 0;
		end	
	endcase

	if (ALU_Result == 0) begin
		Zero_Flag = 1;
	end
	else begin
		Zero_Flag = 0;
	end
end
endmodule : Single_MIPS_ALU