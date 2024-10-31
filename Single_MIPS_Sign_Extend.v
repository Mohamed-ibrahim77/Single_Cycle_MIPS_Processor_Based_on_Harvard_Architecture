module Single_MIPS_Sign_Extend (
	
	input 	[15:0]	immediate_field,

	output	[31:0]	signd_immediate_field
);

/*assign signd_immediate_field[15:0] = immediate_field[15:0];
assign signd_immediate_field[31:16] = immediate_field[15];
*/
assign signd_immediate_field = {{16{immediate_field[15]}}, immediate_field} ;

endmodule : Single_MIPS_Sign_Extend