vlib work

vlog -f source_file.txt

vsim -voptargs=+acc work.Single_MIPS_With_External_Memory_TOP_TB

add wave *

add wave -position insertpoint sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/*

add wave -position insertpoint sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/Data_Path/ALU/*

add wave -position insertpoint sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/Control_Unit/*

add wave -position insertpoint sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/Data_Path/Sign_Extend/*

add wave -position insertpoint  \
sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/Data_Path/Reg_File/input_addr_3 \
sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/Data_Path/Reg_File/write_data

add wave -position insertpoint  \
sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/Instruction_Memory/ins_addr

add wave -position insertpoint  \
sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/MIPS_Processor/Data_Path/Reg_File/REG_FILE
add wave -position insertpoint  \
sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/Data_Memory/DATA_MEM
add wave -position insertpoint  \
sim:/Single_MIPS_With_External_Memory_TOP_TB/DUT/Instruction_Memory/INS_MEM

run -all