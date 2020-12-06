/*
Instr
*0:  XOR SUBU SRLV SRL SRAV SRA SLTU SLT SLLV
    SLL OR MULTU MULT MTLO MTHI JR JALR DIVU 
    DIV AND ADDU 
1:  BLTZAL BLTZ BGEZAL BGEZ
2:  J   
3:  JAL
4:  BEQ
5:  BNE
6:  BLEZ
7:  BGTZ
*9:  ADDIU
10: SLTI
11: SLTIU
12: ANDI
13: ORI
14: XORI
15: LUI
32: LB
33: LH
34: LWL
*35: LW
36: LBU
37: LHU
38: LWR
40: SB 
41: SH
*43: SW
*/

/*
Regdst:
00:Instr[20-16]
01:Instr[15-11]
10:2'd31
*/

/*
Memtoreg:
00: Alu output
01: Memory output
10: PC+4 output
*/

//Commented signals represents dont care(x)

module mips_cpu_control(
    input logic[5:0] Instr,
    input logic[5:0] rt,
    output logic[1:0] Regdst,
    output logic Branch,
    output logic Memread,
    output logic[1:0] Memtoreg,
    output logic Memwrite,
    output logic Alusrc,
    output logic Regwrite,
    output logic Jump
    );

    always_comb begin
        case(Instr)
            6'd0: begin
                Regdst=2'b01;
                Branch=0;
                Memread=0;               
                Memwrite=0;
                Memtoreg=2'b00;
                Alusrc=0;
                Regwrite=1;
                Jump=0;
            end
            6'd1: begin
                Regdst=2'b10;
                Branch=1;
                Memread=0;
                Memwrite=0;
                if(rt[5]==1)begin
                    Memtoreg=2'b10;
                    Regwrite=1;
                end
                Alusrc=0;
                Jump=0;
            end
            6'd2: begin
                //Regdst=2'b;
                Branch=0;
                Memread=0;
                //Memtoreg=;
                Memwrite=0;
                //Alusrc=;
                Regwrite=0;
                Jump=1;
            end
            6'd3: begin
                Regdst=2'b10;
                Branch=0;
                Memread=0;
                Memtoreg=2'b10;
                Memwrite=0;
                //Alusrc=;
                Regwrite=1;
                Jump=1;
            end
            6'd4: begin
                //Regdst=2'b;
                Branch=1;
                Memread=0;
                //Memtoreg=;
                Memwrite=0;
                Alusrc=0;
                Regwrite=0;
                Jump=0;
            end
            6'd5: begin
                //Regdst=2'b;
                Branch=1;
                Memread=0;
                //Memtoreg=;
                Memwrite=0;
                Alusrc=0;
                Regwrite=0;
                Jump=0;
            end
            6'd6: begin
                //Regdst=2'b;
                Branch=1;
                Memread=0;
                //Memtoreg=;
                Memwrite=0;
                Alusrc=0;
                Regwrite=0;
                Jump=0;
            end
            6'd7: begin
                //Regdst=2'b;
                Branch=1;
                Memread=0;
                //Memtoreg=;
                Memwrite=0;
                Alusrc=0;
                Regwrite=0;
                Jump=0;
            end
            6'd9: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd10: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd11: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd12: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd13: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd14: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd15: begin
                Regdst=2'b00;
                Branch=0;
                Memread=0;
                Memtoreg=2'b00;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd32: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd33: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd34: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd35: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd36: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd37: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd38: begin
                Regdst=2'b00;
                Branch=0;
                Memread=1;
                Memtoreg=2'b01;
                Memwrite=0;
                Alusrc=1;
                Regwrite=1;
                Jump=0;
            end
            6'd40: begin
                //Regdst=2'b;
                Branch=0;
                Memread=0;
                //Memtoreg=;
                Memwrite=1;
                Alusrc=1;
                Regwrite=0;
                Jump=0;
            end
            6'd41: begin
                //Regdst=2'b;
                Branch=0;
                Memread=0;
                //Memtoreg=;
                Memwrite=1;
                Alusrc=1;
                Regwrite=0;
                Jump=0;
            end
            6'd43: begin
                //Regdst=2'b;
                Branch=0;
                Memread=0;
                //Memtoreg=;
                Memwrite=1;
                Alusrc=1;
                Regwrite=0;
                Jump=0;
            end
        endcase
    end
   
   
endmodule
