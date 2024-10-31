module Single_MIPS_ALU_Decoder (
	
	input 		[1:0]	ALU_OP,
	input 		[5:0]	FUNCT,	// funct field (instr_addr[5:0])
	
	output 	reg	[2:0]	ALU_CTRL
);

always @(*) begin 
	
	casex (ALU_OP)
		
		2'b00 : begin	
			ALU_CTRL = 3'b010;	// add
		end
		
		2'bx1 : begin /* i change it*/
			ALU_CTRL = 3'b110;	// subtract
		end
		
		2'b1x : begin
			
			case (FUNCT)
			
				6'b10_0000 : begin
					ALU_CTRL = 3'b010;	// add
				end		
				
				6'b10_0010 : begin
					ALU_CTRL = 3'b110;	// subtract
				end		
				
				6'b10_0100 : begin
					ALU_CTRL = 3'b000;	// and
				end		
				
				6'b10_0101 : begin
					ALU_CTRL = 3'b001;	// or
				end		
				
				6'b10_1010 : begin
					ALU_CTRL = 3'b111;	// set less than (SLT)
				end		
				
				default : ALU_CTRL = 3'bxxx;
			endcase
		end
	
		default : ALU_CTRL = 3'bxxx;
	endcase
end
endmodule : Single_MIPS_ALU_Decoder