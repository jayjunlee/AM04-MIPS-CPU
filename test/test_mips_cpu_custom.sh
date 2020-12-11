#!/bin/bash

bash test/test_mips_cpu_harvard.sh rtl addu             #Pass
bash test/test_mips_cpu_harvard.sh rtl addiu            #Pass
bash test/test_mips_cpu_harvard.sh rtl ori              #Pass
#bash test/test_mips_cpu_harvard.sh rtl sw
bash test/test_mips_cpu_harvard.sh rtl and              #Pass
bash test/test_mips_cpu_harvard.sh rtl andi             #Pass
bash test/test_mips_cpu_harvard.sh rtl or               #Pass
bash test/test_mips_cpu_harvard.sh rtl xor              #Pass
bash test/test_mips_cpu_harvard.sh rtl xori             #Pass
bash test/test_mips_cpu_harvard.sh rtl sll
bash test/test_mips_cpu_harvard.sh rtl slti
bash test/test_mips_cpu_harvard.sh rtl sltiu            #Pass
#bash test/test_mips_cpu_harvard.sh rtl slt             # missing
bash test/test_mips_cpu_harvard.sh rtl sltu             #Pass
bash test/test_mips_cpu_harvard.sh rtl sra
bash test/test_mips_cpu_harvard.sh rtl srav
bash test/test_mips_cpu_harvard.sh rtl srl
bash test/test_mips_cpu_harvard.sh rtl srlv
bash test/test_mips_cpu_harvard.sh rtl subu             #Pass