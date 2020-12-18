#!/bin/bash

SRC_DIR=${1?Error: no source directory given in argument};
SRC=$(find ./${SRC_DIR}/*);
SRC_TEMP="";
for src in ${SRC}
do
    SRC_TEMP+=${src}" ";
done
SRC=${SRC_TEMP};


INSTR=${2:-"No instruction specified: running all testcases"};

if [[ ${INSTR} == "No instruction specified: running all testcases" ]];
then
    for DIR in inputs/*/
    do
        DIR=$(basename ${DIR});
        LOOP=$(find inputs/${DIR}/* ! -name '*ref*' ! -name '*log*' ! -name '*data*' ! -name '*out*' ! -name '*stderr*' ! -name '*diff*');
        for TESTCASE in ${LOOP}
        do
            TESTCASE=$([[ ${TESTCASE} =~ /([^./]+)\. ]] && echo "${BASH_REMATCH[1]}");
            iverilog -Wall -g2012 \
                -s mips_cpu_harvard_tb \
                -P mips_cpu_harvard_tb.INSTR_INIT_FILE=\"inputs/${DIR}/${TESTCASE}.instr.txt\" \
                -P mips_cpu_harvard_tb.DATA_INIT_FILE=\"inputs/${DIR}/${TESTCASE}.data.txt\" \
                -o exec/mips_cpu_harvard_tb_${TESTCASE} testbench/mips_cpu_harvard_tb.v testbench/mips_cpu_harvard_memory.v\
                ${SRC} 2> inputs/${DIR}/${TESTCASE}.stderr.txt
            ./exec/mips_cpu_harvard_tb_${TESTCASE} &> ./inputs/${DIR}/${TESTCASE}.log.txt;             # log file for debugging (contains $display)
            echo "$(tail -1 ./inputs/${DIR}/${TESTCASE}.log.txt)" > ./inputs/${DIR}/${TESTCASE}.out.txt;      # register v0 output to compare with reference
            if diff -w ./inputs/${DIR}/${TESTCASE}.out.txt ./inputs/${DIR}/${TESTCASE}.ref.txt &> inputs/${DIR}/${TESTCASE}.diff.txt   # compare
            then 
                echo ${TESTCASE} ${DIR} "Pass";
            else 
                printf '%s %s %s%d %s%d%s\n' "${TESTCASE}" "${DIR}" "Fail Output=" "$(tail -1 ./inputs/${DIR}/${TESTCASE}.out.txt)" "Ref=" "$(tail -1 ./inputs/${DIR}/${TESTCASE}.ref.txt)" 2> /dev/null;
            fi
        done
    done
else
    LOOP=$(find inputs/${INSTR}/* ! -name '*ref*' ! -name '*log*' ! -name '*data*' ! -name '*out*' ! -name '*stderr*' ! -name '*diff*');
    for TESTCASE in ${LOOP}
    do
        TESTCASE=$([[ ${TESTCASE} =~ /([^./]+)\. ]] && echo "${BASH_REMATCH[1]}");
        iverilog -Wall -g2012 \
        -s mips_cpu_harvard_tb \
        -P mips_cpu_harvard_tb.INSTR_INIT_FILE=\"inputs/${INSTR}/${TESTCASE}.instr.txt\" \
        -P mips_cpu_harvard_tb.DATA_INIT_FILE=\"inputs/${INSTR}/${TESTCASE}.data.txt\" \
        -o exec/mips_cpu_harvard_tb_${TESTCASE} testbench/mips_cpu_harvard_tb.v testbench/mips_cpu_harvard_memory.v\
        ${SRC} 2> inputs/${INSTR}/${TESTCASE}.stderr.txt
        ./exec/mips_cpu_harvard_tb_${TESTCASE} &> ./inputs/${INSTR}/${TESTCASE}.log.txt;             # log file for debugging (contains $display)
        echo "$(tail -1 ./inputs/${INSTR}/${TESTCASE}.log.txt)" > ./inputs/${INSTR}/${TESTCASE}.out.txt;      # register v0 output to compare with reference
        if diff -w ./inputs/${INSTR}/${TESTCASE}.out.txt ./inputs/${INSTR}/${TESTCASE}.ref.txt &> inputs/${INSTR}/${TESTCASE}.diff.txt   # compare
        then 
            echo ${TESTCASE} ${INSTR} "Pass";
        else 
            printf '%s %s %s%d %s%d%s\n' "${TESTCASE}" "${INSTR}" "Fail Output=" "$(tail -1 ./inputs/${INSTR}/${TESTCASE}.out.txt)" "Ref=" "$(tail -1 ./inputs/${INSTR}/${TESTCASE}.ref.txt)" 2> /dev/null;
        fi
    done
fi