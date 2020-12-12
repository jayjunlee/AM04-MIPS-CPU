#!/bin/bash
#:'
# arithmetic
bash test/test_mips_cpu_harvard.sh rtl addu             #Pass
bash test/test_mips_cpu_harvard.sh rtl addiu            #Pass
bash test/test_mips_cpu_harvard.sh rtl ori              #Pass
bash test/test_mips_cpu_harvard.sh rtl and              #Pass
bash test/test_mips_cpu_harvard.sh rtl andi             #Pass
bash test/test_mips_cpu_harvard.sh rtl or               #Pass
bash test/test_mips_cpu_harvard.sh rtl xor              #Pass
bash test/test_mips_cpu_harvard.sh rtl xori             #Pass
bash test/test_mips_cpu_harvard.sh rtl subu             #Pass
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
#bash test/test_mips_cpu_harvard.sh rtl j
#bash test/test_mips_cpu_harvard.sh rtl jalr
#bash test/test_mips_cpu_harvard.sh rtl jal
#bash test/test_mips_cpu_harvard.sh rtl jr

# shift
bash test/test_mips_cpu_harvard.sh rtl sll              #Pass
bash test/test_mips_cpu_harvard.sh rtl srl              #Pass
#bash test/test_mips_cpu_harvard.sh rtl sra
#bash test/test_mips_cpu_harvard.sh rtl srav
#bash test/test_mips_cpu_harvard.sh rtl srlv
#'


# load & store
bash test/test_mips_cpu_harvard.sh rtl lw               #Pass
bash test/test_mips_cpu_harvard.sh rtl lb
bash test/test_mips_cpu_harvard.sh rtl lbu
bash test/test_mips_cpu_harvard.sh rtl lh
bash test/test_mips_cpu_harvard.sh rtl lhu
bash test/test_mips_cpu_harvard.sh rtl lui
bash test/test_mips_cpu_harvard.sh rtl lwl
bash test/test_mips_cpu_harvard.sh rtl lwr
#bash test/test_mips_cpu_harvard.sh rtl sw
#bash test/test_mips_cpu_harvard.sh rtl sb
#bash test/test_mips_cpu_harvard.sh rtl sh


# set on less than
#bash test/test_mips_cpu_harvard.sh rtl slti
#bash test/test_mips_cpu_harvard.sh rtl sltiu           
#bash test/test_mips_cpu_harvard.sh rtl slt             # missing
#bash test/test_mips_cpu_harvard.sh rtl sltu             #Pass


