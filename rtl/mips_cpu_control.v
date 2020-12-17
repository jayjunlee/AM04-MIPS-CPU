module mips_cpu_control(
    input logic[31:0] Instr,
    input logic ALUCond,
    
    output logic[1:0] CtrlRegDst,
    output logic[1:0] CtrlPC,
    output logic CtrlMemRead,
    output logic[2:0] CtrlMemtoReg,
    output logic[4:0] CtrlALUOp,
    output logic[4:0] Ctrlshamt,
    output logic CtrlMemWrite,
    output logic[1:0] CtrlALUSrc,
    output logic CtrlRegWrite,
    output logic CtrlSpcRegWriteEn
);

typedef enum logic[5:0]{
    SPECIAL = 6'd0,
    REGIMM  = 6'd1,
    J       = 6'd2,
    JAL     = 6'd3,
    BEQ     = 6'd4,
    BNE     = 6'd5,
    BLEZ    = 6'd6,
    BGTZ    = 6'd7,
    ADDI    = 6'd8,
    ADDIU   = 6'd9,
    SLTI    = 6'd10,
    SLTIU   = 6'd11,
    ANDI    = 6'd12,
    ORI     = 6'd13,
    XORI    = 6'd14,
    LUI     = 6'd15,
    LB      = 6'd32,
    LH      = 6'd33,
    LWL     = 6'd34,
    LW      = 6'd35,
    LBU     = 6'd36,
    LHU     = 6'd37,
    LWR     = 6'd38,
    SB      = 6'd40,
    SH      = 6'd41,
    SW      = 6'd43
} op_enum;
op_enum op;


typedef enum logic[5:0]{
    SLL     = 6'd0,
    SRL     = 6'd2,
    SRA     = 6'd3,
    SLLV    = 6'd4,
    SRLV    = 6'd6,
    SRAV    = 6'd7,
    JR      = 6'd8,
    JALR    = 6'd9,
    MFLO    = 6'd18,
    MFHI    = 6'd16,
    MTHI    = 6'd17,
    MTLO    = 6'd19,
    MULT    = 6'd24,
    MULTU   = 6'd25,
    DIV     = 6'd26,
    DIVU    = 6'd27,
    ADDU    = 6'd33,
    SUBU    = 6'd35,
    AND     = 6'd36,
    OR      = 6'd37,
    XOR     = 6'd38,
    SLT     = 6'd42,
    SLTU    = 6'd43
} funct_enum;
funct_enum funct;


typedef enum logic[4:0]{
    BLTZ    = 5'd0,
    BGEZ    = 5'd1,
    BLTZAL  = 5'd16,
    BGEZAL  = 5'd17
} rt_enum;
rt_enum rt;


always @(*) begin
    assign op = Instr[31:26];
    assign funct = Instr[5:0];
    assign rt = Instr[20:16];
    //CtrlRegDst logic
    if((op==ADDIU) || (op==ANDI) || (op==LB) || (op==LBU) || (op==LH) || (op==LHU) || (op==LUI) || (op==LW) || (op==LWL) || (op==LWR) || (op==ORI) || (op==SLTI) || (op==SLTIU) || (op==XORI))begin
        CtrlRegDst = 2'd0; //Write address comes from rt
        $display("CTRLREGDST: Rt");
    end else if ((op==SPECIAL)&&((funct==ADDU) || (funct==AND) || (funct==JALR) || (funct==MFLO) || (funct==MFHI) || (funct==OR) || (funct==SLL) || (funct==SLLV) || (funct==SLT) || (funct==SLTU) || (funct==SRA) || (funct==SRAV) || (funct==SRL) || (funct==SRLV) || (funct==SUBU) || (funct==XOR)))begin
        CtrlRegDst = 2'd1; //Write address comes from rd
        $display("CTRLREGDST: Rd");
    end else if ((op == JAL) || ((op==REGIMM)&&((rt==BGEZAL) || (rt==BLTZAL))))begin
        CtrlRegDst = 2'd2; //const reg 31, for writing to the link register
        $display("CTRLREGDST: Link");
    end else begin CtrlRegDst = 1'bx; end//Not all instructions are encompassed so, added incase for debug purposes

    //CtrlPC logic
    if(ALUCond && ((op==BEQ) || (op==BGTZ) || (op==BLEZ) || (op==BNE) || ((op==REGIMM)&&((rt==BGEZ) || (rt==BGEZAL) || (rt==BLTZ) || (rt==BLTZAL)))))begin
        CtrlPC = 2'd1; // Branches - Jumps relative to PC
    end else if((op==J) || (op==JAL))begin
        CtrlPC = 2'd2; // Jumps within 256MB Region using 26-bit immediate in J type instruction
        $display("Jump PC Ctrl");
    end else if((op==SPECIAL)&&((funct==JR) || (funct==JALR)))begin
        CtrlPC = 2'd3; // Jumps using Register.
        //$display("Ctrl PC Jump Register");
    end else begin CtrlPC = 2'd0; /*/$display("Ctrl PC No Jump/Branch");*/end // No jumps or branches, just increment to next word

    //CtrlMemRead and CtrlMemtoReg logic -- Interesting quirk that they have the same logic where both are concerned. Makes sense bc you'd only want to select the read data out when the memory itself is read enabled.
    if((op==LB) || (op==LBU) || (op==LH) || (op==LHU) || (op==LW) || (op==LWL) || (op==LWR))begin
        CtrlMemRead = 1;//Memory is read enabled
        CtrlMemtoReg = 3'd1;//write data port of regfile is fed from data memory
        $display("Memory read enabled");
    end else if ((op==ADDIU) || (op==ANDI) || (op==ORI) || (op==LUI) || (op==SLTI) || (op==SLTIU) || (op==XORI) || ((op==SPECIAL)&&((funct==ADDU) || (funct==AND) ||  (funct==OR) ||  (funct==SLL) ||  (funct==SLLV) ||  (funct==SLT) ||  (funct==SLTU) ||  (funct==SRA) ||  (funct==SRAV) ||  (funct==SRL) || (funct==SRLV) ||  (funct==SUBU) ||  (funct==XOR))))begin
        CtrlMemRead = 0;//Memory is read disabled
        CtrlMemtoReg = 3'd0;//write data port of regfile is fed from ALURes
        $display("Memory read disabled");
    end else if ((op==JAL) || ((op==SPECIAL)&&(funct == JALR)) || ((op==REGIMM)&&((rt==BGEZAL) || (rt==BLTZAL))))begin
        CtrlMemtoReg = 3'd2;//write data port of regfile is fed from PC + 8
    end else if ((op==SPECIAL)&&(funct == MFHI))begin
        CtrlMemtoReg = 3'd3;//write data port of regfile is fed from ALUHi
    end else if ((op==SPECIAL)&&(funct == MFLO))begin
        CtrlMemtoReg = 3'd4;//write data port of regfile is fed from ALULo
    end else begin CtrlMemRead = 1'bx;end//Not all instructions are encompassed so, added incase for debug purposes
    //$display("OP: %d, Funct: %d", op, funct);
    //CtrlALUOp Logic
    if((op==ADDIU) || ((op==SPECIAL)&&(funct==ADDU)))begin
        CtrlALUOp = 5'd0; //ADD from ALUOps
        $display("ALU OP = 0 (ADDU/ADDIU)");
    end else if((op==ANDI) || ((op==SPECIAL)&&(funct==AND)))begin
        CtrlALUOp = 5'd4;//AND from ALUOps
    end else if(op==BEQ) begin
        CtrlALUOp = 5'd13;//EQ from ALUOps
    end else if((op==REGIMM)&&((rt==BGEZ) || (rt==BGEZAL)))begin
        CtrlALUOp = 5'd17;//GEQ from ALUOps
    end else if(op==BGTZ)begin
        CtrlALUOp = 5'd16;//GRT from ALUOps
    end else if(op==BLEZ)begin
        CtrlALUOp = 5'd15;//LEQ from ALUOps
    end else if((op==REGIMM)&&((rt==BLTZ) || (rt==BLTZAL)))begin
        CtrlALUOp = 5'd14;//LES from ALUOps
    end else if(op==BNE)begin
        CtrlALUOp = 5'd18;//NEQ from ALUOps
    end else if((op==SPECIAL)&&(funct==DIV))begin
        CtrlALUOp = 5'd3;//DIV from ALUOps
        $display("DIV CONTROL ALUOps");
    end else if((op==SPECIAL)&&(funct==DIVU))begin
        CtrlALUOp = 5'd23;//DIVU from ALUOps
    end else if((op==LB) || (op==LBU) || (op==LH) || (op==LHU) || (op==LW) || (op==LWL) || (op==LWR) || (op==SB) || (op==SH) || (op==SW))begin
        CtrlALUOp = 5'd0;//ADD from ALUOps
        $display("LB IN CONTROL");
    end else if(op==LUI)begin
        CtrlALUOp = 5'd7;//SLL from ALUOps
    end else if((op==SPECIAL)&&((funct==MTHI)))begin
        CtrlALUOp = 5'd24;//MTHI from ALUOps
    end else if((op==SPECIAL)&&((funct==MTLO)))begin
        CtrlALUOp = 5'd25;//MTLO from ALUOps
    end else if((op==SPECIAL)&&(funct==MULT))begin
        CtrlALUOp = 5'd2;//MUL from ALUOps
    end else if((op==SPECIAL)&&(funct==MULTU))begin
        CtrlALUOp = 5'd22;//MULU from ALUOps
    end else if((op==ORI) || ((op==SPECIAL)&&(funct==OR)))begin
        CtrlALUOp = 5'd5;//OR from ALUOps
    end else if((op==SPECIAL)&&(funct==SLL))begin
        CtrlALUOp = 5'd7;//SLL from ALUOps
        $display("ALU Op = 7 (SLL)");
    end else if((op==SPECIAL)&&(funct==SLLV))begin
        CtrlALUOp = 5'd8;//SLLV from ALUOps
        $display("ALU Op = 9 (SLLV)");
    end else if((op==SPECIAL)&&(funct==SRA))begin
        CtrlALUOp = 5'd11;//SRA from ALUOps
        $display("ALU Op = 11 (SRA)");
    end else if((op==SPECIAL)&&(funct==SRAV))begin
        CtrlALUOp = 5'd12;//SRAV from ALUOps
    end else if((op==SPECIAL)&&(funct==SRL))begin
        $display("ALU Op = 7 (SRL)");
        CtrlALUOp = 5'd9;//SRL from ALUOps
    end else if((op==SPECIAL)&&(funct==SRLV))begin
        CtrlALUOp = 5'd10;//SRLV from ALUOps
    end else if((op==SLTI) || ((op==SPECIAL)&&(funct==SLT)))begin
        CtrlALUOp = 5'd20;//SLT from ALUOps
        $display("ALU Op = 20 (SLT/SLTI)");
    end else if((op==SLTIU) || ((op==SPECIAL)&&(funct==SLTU)))begin
        CtrlALUOp = 5'd21;//SLTU from ALUOps
        $display("ALU Op = 21 (SLTU/SLTIU)");
    end else if((op==SPECIAL)&&(funct==SUBU))begin
        CtrlALUOp = 5'd1;//SUB from ALUOps
    end else if((op==XORI) || ((op==SPECIAL)&&(funct==XOR)))begin
        CtrlALUOp = 5'd6;//XOR from ALUOps
        $display("ALU Op = 6 (XOR)");
    end else begin
        CtrlALUOp = 5'bxxxxx;
    end

    //Ctrlshamt logic
    if((op==SPECIAL)&&((funct==SRA) || (funct==SRL) || (funct==SLL)))begin
        Ctrlshamt = Instr[10:6];// Shift amount piped in from the instruction
    end else if(op == LUI)begin
        Ctrlshamt = 5'd16;//Used specifically to implement LUI as the instruction itslef does not include shamt
        $display("LUI SHIFTING");
    end else begin Ctrlshamt = 5'bxxxxx;end

    //CtrlMemWrite logic
    if((op==SB) || (op==SH) || (op==SW))begin
        CtrlMemWrite = 1;//Memory is write enabled
    end else begin CtrlMemWrite = 0;end//default is 0 to ensure no accidental overwriting.
    
    //CtrlSpcRegWriteEn logic
    if((op==SPECIAL)&&((funct==MTHI) || (funct==MTLO) || (funct==MULT) || (funct==MULTU) || (funct==DIV) || (funct==DIVU)))begin
        CtrlSpcRegWriteEn = 1;//Special register Hi and Lo are write enabled
        $display("Temp being written");
    end else begin CtrlSpcRegWriteEn = 0;end//default is 0 to ensure no accidental overwriting.
    
    //CtrlALUSrc logic
    if((op==ADDIU) || (op==LUI) || (op==SLTI) || (op==SLTIU) || (op==LB) || (op==LBU) || (op==LH) || (op==LHU) || (op==LW) || (op==LWL) || (op==LWR) || (op==SB) || (op==SH) || (op==SW))begin
        CtrlALUSrc = 1;//ALU Bus B is fed from the 16-bit immediate sign extended to 32-bit value taken from Instr[15-0]
    end else if((op==BEQ) || (op==BGTZ) || (op==BLEZ) || (op==BNE) || ((op==SPECIAL)&&((funct==ADDU) || (funct==AND) || (funct==DIV) || (funct==DIVU) || (funct==MULT) || (funct==MULTU) || (funct==OR) || (funct==SLL) || (funct==SLLV) || (funct==SLT) || (funct==SLTU) || (funct==SRA) || (funct==SRAV) || (funct==SRL) || (funct==SRLV) || (funct==SUBU) || (funct==XOR))) || ((op==REGIMM)&&((rt==BGEZ) || (rt==BGEZAL) || (rt==BLTZ) || (rt==BLTZAL))))begin 
        CtrlALUSrc = 0;///ALU Bus B is fed from rt.
    end else if ((op==ORI) || (op==ANDI) || (op==XORI)) begin
        CtrlALUSrc = 2;
    end else begin CtrlALUSrc = 1'bx;end
       
    //CtrlRegWrite logic
    if((op==ADDIU) || (op==ANDI) || (op==LB) || (op==LBU) || (op==LH) || (op==LHU) || (op==LUI) || (op==LW) || (op==LWL) || (op==LWR) || (op==ORI) || (op==JAL) || (op==SLTI) || (op==XORI) || ((op==REGIMM)&&((rt==BGEZAL) || (rt==BLTZAL))) || ((op==SPECIAL)&&((funct==ADDU) || (funct==AND) || (funct==MFLO) || (funct==MFHI) || (funct==OR) || (funct==SLL) || (funct==SLLV) || (funct==SLT) || (funct==SLTU) || (funct==SRA) || (funct==SRAV) || (funct==SRL) || (funct==SRLV) || (funct==SUBU) || (funct==JALR) || (funct==XOR)))) begin
        CtrlRegWrite = 1;//The Registers are Write Enabled
        $display("OPcode mflo: %h", op);
    end else begin CtrlRegWrite = 0;end // The Registers are Write Disabled
end
endmodule