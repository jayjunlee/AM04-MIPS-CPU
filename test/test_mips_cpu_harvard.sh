#!/bin/bash

# should not create any files in the rtl dir
# but auxiliary files / dirs can be utilised


# Source File & Source Directory Parsing
SRC_DIR=${1?Error: no source directory given in argument};      # e.g. ./rtl
SRC=$(ls ${SRC_DIR} | grep -E "harvard|memory|alu|regfile|pc|control");
SRC_TEMP="";
for src in ${SRC}
do
    SRC_TEMP+=${SRC_DIR}/${src}" ";
done
SRC=${SRC_TEMP}
echo ${SRC}

# Instruction Argument
INSTR=${2:-"No instruction specified: running all testcases"};  # e.g. addiu
echo ${INSTR};

# Start Testing
if [[ ${INSTR} == "No instruction specified: running all testcases" ]];
then
    # All Testcase Files
    TESTCASES=$(ls ./inputs | grep ".hex.txt");
    echo ${TESTCASES}
    for TESTCASE in ${TESTCASES}
    do
        # Run Each Testcase File
        echo ${TESTCASE}
#        iverilog -g 2012 \
#        -s mips_cpu_harvard_tb \
#        -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/"${TESTCASE}\" \
#        -o program/mips_cpu_harvard_tb_${INSTR} testbench/mips_cpu_harvard_tb.v \
#           ${SRC}
    done

else
    echo "ELSE";
    # Run Testcase File Of Specified Instruction
#    iverilog -g 2012 \
#        -s mips_cpu_harvard_tb \
#        -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/${INSTR}.hex.txt\" \
#        -o program/mips_cpu_harvard_tb_${INSTR} testbench/mips_cpu_harvard_tb.v \
#           ${SRC}
fi

#/mnt/c/Windows/System32/cmd.exe /C \ # need this to run verilog on windows
#iverilog -g 2012 \
#   -s mips_cpu_harvard_tb \
#   -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/addiu.hex.txt\" \
#   -o program/mips_cpu_harvard_tb testbench/mips_cpu_harvard_tb.v test/mips_cpu_harvard.v \ 
#    test/mips_cpu_control.v test/mips_cpu_alu.v test/mips_cpu_memory.v test/mips_cpu_regfile.v test/mips_cpu_pc.v

