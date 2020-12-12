#!/bin/bash

#arithmetic
bash test/test_mips_cpu_harvard.sh rtl addu             #Pass
bash test/test_mips_cpu_harvard.sh rtl addiu            #Pass
bash test/test_mips_cpu_harvard.sh rtl ori              #Pass
bash test/test_mips_cpu_harvard.sh rtl and              #Pass
bash test/test_mips_cpu_harvard.sh rtl andi             #Pass
bash test/test_mips_cpu_harvard.sh rtl or               #Pass
bash test/test_mips_cpu_harvard.sh rtl xor              #Pass
bash test/test_mips_cpu_harvard.sh rtl xori             #Pass
bash test/test_mips_cpu_harvard.sh rtl subu             #Pass


#load & store
bash test/test_mips_cpu_harvard.sh rtl beq              #Pass
bash test/test_mips_cpu_harvard.sh rtl bgez             #Pass
#bash test/test_mips_cpu_harvard.sh rtl bgezal
bash test/test_mips_cpu_harvard.sh rtl bgtz             #Pass
bash test/test_mips_cpu_harvard.sh rtl blez             #Pass
#bash test/test_mips_cpu_harvard.sh rtl bltz
bash test/test_mips_cpu_harvard.sh rtl bltzal           #Pass
bash test/test_mips_cpu_harvard.sh rtl bne              #Pass


# shift
#bash test/test_mips_cpu_harvard.sh rtl sll
#bash test/test_mips_cpu_harvard.sh rtl srl
#bash test/test_mips_cpu_harvard.sh rtl sra
#bash test/test_mips_cpu_harvard.sh rtl srav
#bash test/test_mips_cpu_harvard.sh rtl srlv



# 
#bash test/test_mips_cpu_harvard.sh rtl sw


#bash test/test_mips_cpu_harvard.sh rtl slti
#bash test/test_mips_cpu_harvard.sh rtl sltiu           
#bash test/test_mips_cpu_harvard.sh rtl slt             # missing
bash test/test_mips_cpu_harvard.sh rtl sltu             #Pass


