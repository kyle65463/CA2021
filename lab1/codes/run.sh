python3 utils/assembler.py instruction_raw.txt > instruction.txt
iverilog -o CPU.out *.v
./CPU.out &> /dev/null