#!/bin/bash

# arithmetic
./test/test_mips_cpu_bus.sh rtl addu             #Pass
./test/test_mips_cpu_bus.sh rtl addiu            #Pass
./test/test_mips_cpu_bus.sh rtl subu             #Pass
./test/test_mips_cpu_bus.sh rtl and              #Pass
./test/test_mips_cpu_bus.sh rtl andi             #Pass
./test/test_mips_cpu_bus.sh rtl or               #Pass
./test/test_mips_cpu_bus.sh rtl ori              #Pass
./test/test_mips_cpu_bus.sh rtl xor              #Pass
./test/test_mips_cpu_bus.sh rtl xori             #Pass
./test/test_mips_cpu_bus.sh rtl div              #Pass
./test/test_mips_cpu_bus.sh rtl divu             #pass
./test/test_mips_cpu_bus.sh rtl mthi             #Pass
./test/test_mips_cpu_bus.sh rtl mtlo             #Pass
./test/test_mips_cpu_bus.sh rtl mult             #Pass
./test/test_mips_cpu_bus.sh rtl multu            #Pass


# branches
./test/test_mips_cpu_bus.sh rtl beq              #Pass
./test/test_mips_cpu_bus.sh rtl bgez             #Pass
./test/test_mips_cpu_bus.sh rtl bgezal           #Pass
./test/test_mips_cpu_bus.sh rtl bgtz             #Pass
./test/test_mips_cpu_bus.sh rtl blez             #Pass
./test/test_mips_cpu_bus.sh rtl bltz             #Pass
./test/test_mips_cpu_bus.sh rtl bltzal           #Pass
./test/test_mips_cpu_bus.sh rtl bne              #Pass

# jumps
./test/test_mips_cpu_bus.sh rtl j                #Pass
./test/test_mips_cpu_bus.sh rtl jalr             #Pass
./test/test_mips_cpu_bus.sh rtl jal              #Pass
./test/test_mips_cpu_bus.sh rtl jr               #Pass

# shift
./test/test_mips_cpu_bus.sh rtl sll              #Pass
./test/test_mips_cpu_bus.sh rtl srl              #Pass
./test/test_mips_cpu_bus.sh rtl sra              #Pass
./test/test_mips_cpu_bus.sh rtl srav             #Pass
./test/test_mips_cpu_bus.sh rtl sllv             #Pass
./test/test_mips_cpu_bus.sh rtl srlv             #Pass



# load & store
./test/test_mips_cpu_bus.sh rtl lw               #Pass
./test/test_mips_cpu_bus.sh rtl lb               #Pass
./test/test_mips_cpu_bus.sh rtl lbu              #Pass
./test/test_mips_cpu_bus.sh rtl lh               #Pass
./test/test_mips_cpu_bus.sh rtl lhu              #Pass
./test/test_mips_cpu_bus.sh rtl lui              #Pass
./test/test_mips_cpu_bus.sh rtl lwl              #Pass
./test/test_mips_cpu_bus.sh rtl lwr              #Pass
./test/test_mips_cpu_bus.sh rtl sw               #Pass
./test/test_mips_cpu_bus.sh rtl sb              #Once switched to bus
./test/test_mips_cpu_bus.sh rtl sh              #Once switched to bus


# set on less than **Branch delay slots dont work on these...
./test/test_mips_cpu_bus.sh rtl slti             #Pass
./test/test_mips_cpu_bus.sh rtl sltiu            #Pass
./test/test_mips_cpu_bus.sh rtl slt              #Pass
./test/test_mips_cpu_bus.sh rtl sltu             #Pass


