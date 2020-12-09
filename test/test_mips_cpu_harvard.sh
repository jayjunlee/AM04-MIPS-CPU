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
    TESTCASES=$(ls ./inputs | grep ".txt");
    echo ${TESTCASES}
    for TESTCASE in ${TESTCASES}
    do
    # Run Each Testcase File
    echo ${TESTCASE}
/mnt/c/Windows/System32/cmd.exe /C \
iverilog -Wall -g2012 \
    -s mips_cpu_harvard_tb \
    -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/${TESTCASE}.txt\" \
    -o exec/mips_cpu_harvard_tb_${TESTCASE} testbench/mips_cpu_harvard_tb.v \
    ${SRC}
/mnt/c/Windows/System32/cmd.exe /C vvp ./exec/mips_cpu_harvard_tb_${TESTCASE};
    done

else
    # Run Testcase File Of Specified Instruction
    echo ${INSTR};
/mnt/c/Windows/System32/cmd.exe /C \
iverilog -Wall -g2012 \
    -s mips_cpu_harvard_tb \
    -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/${INSTR}.txt\" \
    -o exec/mips_cpu_harvard_tb_${INSTR} testbench/mips_cpu_harvard_tb.v \
    ${SRC}
/mnt/c/Windows/System32/cmd.exe /C vvp ./exec/mips_cpu_harvard_tb_${INSTR};
fi

