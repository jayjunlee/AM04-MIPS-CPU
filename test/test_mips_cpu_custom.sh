#!/bin/bash

# arithmetic
bash test/test_mips_cpu_harvard.sh rtl addu             #Pass
bash test/test_mips_cpu_harvard.sh rtl addiu            #Pass
bash test/test_mips_cpu_harvard.sh rtl subu             #Pass
bash test/test_mips_cpu_harvard.sh rtl and              #Pass
bash test/test_mips_cpu_harvard.sh rtl andi             #Pass
bash test/test_mips_cpu_harvard.sh rtl or               #Pass
bash test/test_mips_cpu_harvard.sh rtl ori              #Pass
bash test/test_mips_cpu_harvard.sh rtl xor              #Pass
bash test/test_mips_cpu_harvard.sh rtl xori             #Pass
#bash test/test_mips_cpu_harvard.sh rtl div
#bash test/test_mips_cpu_harvard.sh rtl divu
#bash test/test_mips_cpu_harvard.sh rtl mthi
#bash test/test_mips_cpu_harvard.sh rtl mtlo
#bash test/test_mips_cpu_harvard.sh rtl mult
#bash test/test_mips_cpu_harvard.sh rtl multu


# branches
bash test/test_mips_cpu_harvard.sh rtl beq              #Pass
bash test/test_mips_cpu_harvard.sh rtl bgez             #Pass
#bash test/test_mips_cpu_harvard.sh rtl bgezal          #Place return address thing how??
bash test/test_mips_cpu_harvard.sh rtl bgtz             #Pass
bash test/test_mips_cpu_harvard.sh rtl blez             #Pass
#bash test/test_mips_cpu_harvard.sh rtl bltz            #Probably fails due to jump register thing?
bash test/test_mips_cpu_harvard.sh rtl bltzal           #Pass
bash test/test_mips_cpu_harvard.sh rtl bne              #Pass

# jumps
#bash test/test_mips_cpu_harvard.sh rtl j               #Need new testcase
#bash test/test_mips_cpu_harvard.sh rtl jalr            #Again how to link?
#bash test/test_mips_cpu_harvard.sh rtl jal             #how to link?
bash test/test_mips_cpu_harvard.sh rtl jr               #Pass

# shift
bash test/test_mips_cpu_harvard.sh rtl sll              #Pass
bash test/test_mips_cpu_harvard.sh rtl srl              #Pass
bash test/test_mips_cpu_harvard.sh rtl sra              #Pass
bash test/test_mips_cpu_harvard.sh rtl srav             #Pass
bash test/test_mips_cpu_harvard.sh rtl sllv             #Pass
bash test/test_mips_cpu_harvard.sh rtl srlv             #Pass



# load & store
bash test/test_mips_cpu_harvard.sh rtl lw               #Pass
bash test/test_mips_cpu_harvard.sh rtl lb               #Pass
bash test/test_mips_cpu_harvard.sh rtl lbu              #Pass
bash test/test_mips_cpu_harvard.sh rtl lh               #Pass
bash test/test_mips_cpu_harvard.sh rtl lhu              #Pass
bash test/test_mips_cpu_harvard.sh rtl lui              #Pass
bash test/test_mips_cpu_harvard.sh rtl lwl              #Pass
bash test/test_mips_cpu_harvard.sh rtl lwr              #Pass
bash test/test_mips_cpu_harvard.sh rtl sw               #Pass
#bash test/test_mips_cpu_harvard.sh rtl sb              #Once switched to bus
#bash test/test_mips_cpu_harvard.sh rtl sh              #Once switched to bus


# set on less than **Branch delay slots dont work on these...
bash test/test_mips_cpu_harvard.sh rtl slti             #Pass
bash test/test_mips_cpu_harvard.sh rtl sltiu            #Pass
bash test/test_mips_cpu_harvard.sh rtl slt              #Pass
bash test/test_mips_cpu_harvard.sh rtl sltu             #Pass


