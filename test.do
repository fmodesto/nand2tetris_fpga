vlib work
vlog src/alu.v src/register.v src/pc.v src/cpu.v test/alu_test.sv test/register_test.sv test/pc_test.sv test/cpu_test.sv
vsim work.ALU_test
run -all
vsim work.Register_test
run -all
vsim work.PC_test
run -all
vsim work.CPU_test
run -all
exit
