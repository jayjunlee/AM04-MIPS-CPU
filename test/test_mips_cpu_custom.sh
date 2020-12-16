#!/bin/bash

# arithmetic
./test/test_mips_cpu_harvard.sh rtl addu             #Pass
./test/test_mips_cpu_harvard.sh rtl addiu            #Pass
./test/test_mips_cpu_harvard.sh rtl subu             #Pass
./test/test_mips_cpu_harvard.sh rtl and              #Pass
./test/test_mips_cpu_harvard.sh rtl andi             #Pass
./test/test_mips_cpu_harvard.sh rtl or               #Pass
./test/test_mips_cpu_harvard.sh rtl ori              #Pass
./test/test_mips_cpu_harvard.sh rtl xor              #Pass
./test/test_mips_cpu_harvard.sh rtl xori             #Pass
./test/test_mips_cpu_harvard.sh rtl div              #Pass
./test/test_mips_cpu_harvard.sh rtl divu             #pass
./test/test_mips_cpu_harvard.sh rtl mthi             #Pass
./test/test_mips_cpu_harvard.sh rtl mtlo             #Pass
./test/test_mips_cpu_harvard.sh rtl mult             #Pass
./test/test_mips_cpu_harvard.sh rtl multu            #Pass


# branches
./test/test_mips_cpu_harvard.sh rtl beq              #Pass
./test/test_mips_cpu_harvard.sh rtl bgez             #Pass
#./test/test_mips_cpu_harvard.sh rtl bgezal          #Place return address thing how??
./test/test_mips_cpu_harvard.sh rtl bgtz             #Pass
./test/test_mips_cpu_harvard.sh rtl blez             #Pass
./test/test_mips_cpu_harvard.sh rtl bltz             #Pass
./test/test_mips_cpu_harvard.sh rtl bltzal           #Pass
./test/test_mips_cpu_harvard.sh rtl bne              #Pass

# jumps
./test/test_mips_cpu_harvard.sh rtl j                #Pass
#./test/test_mips_cpu_harvard.sh rtl jalr            #Again how to link?
./test/test_mips_cpu_harvard.sh rtl jal              #Pass
./test/test_mips_cpu_harvard.sh rtl jr               #Pass

# shift
./test/test_mips_cpu_harvard.sh rtl sll              #Pass
./test/test_mips_cpu_harvard.sh rtl srl              #Pass
./test/test_mips_cpu_harvard.sh rtl sra              #Pass
./test/test_mips_cpu_harvard.sh rtl srav             #Pass
./test/test_mips_cpu_harvard.sh rtl sllv             #Pass
./test/test_mips_cpu_harvard.sh rtl srlv             #Pass



# load & store
./test/test_mips_cpu_harvard.sh rtl lw               #Pass
./test/test_mips_cpu_harvard.sh rtl lb               #Pass
./test/test_mips_cpu_harvard.sh rtl lbu              #Pass
./test/test_mips_cpu_harvard.sh rtl lh               #Pass
./test/test_mips_cpu_harvard.sh rtl lhu              #Pass
./test/test_mips_cpu_harvard.sh rtl lui              #Pass
./test/test_mips_cpu_harvard.sh rtl lwl              #Pass
./test/test_mips_cpu_harvard.sh rtl lwr              #Pass
./test/test_mips_cpu_harvard.sh rtl sw               #Pass
#./test/test_mips_cpu_harvard.sh rtl sb              #Once switched to bus
#./test/test_mips_cpu_harvard.sh rtl sh              #Once switched to bus


# set on less than **Branch delay slots dont work on these...
./test/test_mips_cpu_harvard.sh rtl slti             #Pass
./test/test_mips_cpu_harvard.sh rtl sltiu            #Pass
./test/test_mips_cpu_harvard.sh rtl slt              #Pass
./test/test_mips_cpu_harvard.sh rtl sltu             #Pass


