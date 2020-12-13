#!/bin/bash

#**Delete command for windows before submission**
#rm inputs/*.log.txt inputs/*.out.txt

# Source File & Source Directory Parsing
SRC_DIR=${1?Error: no source directory given in argument};      # e.g. rtl
SRC=$(ls ${SRC_DIR} | grep -E "harvard|memory|alu|regfile|pc|control");
SRC_TEMP="";
for src in ${SRC}
do
    SRC_TEMP+=${SRC_DIR}/${src}" ";
done
SRC=${SRC_TEMP}
#echo ${SRC};

# Instruction Argument
INSTR=${2:-"No instruction specified: running all testcases"};  # e.g. addiu

# Start Testing
if [[ ${INSTR} == "No instruction specified: running all testcases" ]];
then
    # All Testcase Files
    TESTCASES=$(find ./inputs ! -name '*ref*'  ! -name '*log*' ! -name '*out*' ! -name 'inputs' ! -name 'data' | sed 's#.*/##');
    #echo ${TESTCASES}
    for TESTCASE in ${TESTCASES}
    do
        # Run Each Testcase File
        TESTCASE="${TESTCASE%%.*}";
        #echo ${TESTCASE};
/mnt/c/Windows/System32/cmd.exe /C \
iverilog -Wall -g2012 \
    -s mips_cpu_harvard_tb \
    -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/${TESTCASE}.txt\" \
    -P mips_cpu_harvard_tb.MEM_INIT_FILE=\"inputs/${TESTCASE}.data.txt\" \
    -o exec/mips_cpu_harvard_tb_${TESTCASE} testbench/mips_cpu_harvard_tb.v \
    ${SRC} 2> /dev/null
/mnt/c/Windows/System32/cmd.exe /C vvp ./exec/mips_cpu_harvard_tb_${TESTCASE} &> ./inputs/${TESTCASE}.log.txt;       # log file for debugging (contains $display)
echo "$(tail -1 ./inputs/${TESTCASE}.log.txt)" > ./inputs/${TESTCASE}.out.txt;                                       # register v0 output to compare with reference
if diff -w ./inputs/${TESTCASE}.out.txt ./inputs/${TESTCASE}.ref.txt &> /dev/null                                    # compare
then 
    echo ${TESTCASE} ${TESTCASE} "Pass";
else 
    printf '%s %s %s%d %s%d%s\n' "${TESTCASE}" "${TESTCASE}" "Fail Output=" "$(tail -1 ./inputs/${TESTCASE}.out.txt)" "Ref=" "$(tail -1 ./inputs/${TESTCASE}.ref.txt)" 2> /dev/null;
fi
    done

else
    # Run Testcase File Of Specified Instruction
/mnt/c/Windows/System32/cmd.exe /C \
iverilog -Wall -g2012 \
    -s mips_cpu_harvard_tb \
    -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"inputs/${INSTR}.txt\" \
    -P mips_cpu_harvard_tb.MEM_INIT_FILE=\"inputs/${INSTR}.data.txt\" \
    -o exec/mips_cpu_harvard_tb_${INSTR} testbench/mips_cpu_harvard_tb.v \
    ${SRC} #2> /dev/null
/mnt/c/Windows/System32/cmd.exe /C vvp ./exec/mips_cpu_harvard_tb_${INSTR} &> ./inputs/${INSTR}.log.txt;            # log file for debugging (contains $display)
echo "$(tail -1 ./inputs/${INSTR}.log.txt)" > ./inputs/${INSTR}.out.txt;                                            # register v0 output to compare with reference
if diff -w ./inputs/${INSTR}.out.txt ./inputs/${INSTR}.ref.txt &> /dev/null                                         # compare
then 
    echo ${INSTR} ${INSTR} "Pass";
else 
    printf '%s %s %s%d %s%d%s\n' "${INSTR}" "${INSTR}" "Fail Output=" "$(tail -1 ./inputs/${INSTR}.out.txt)" "Ref=" "$(tail -1 ./inputs/${INSTR}.ref.txt)" 2> /dev/null;
fi

fi
