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

logic[5:0] op, funct;
logic[4:0] rt;

assign op = Instr[31:26];
assign funct = Instr[5:0];
assign rt = Instr[20:16];

always @(*) begin
    //CtrlRegDst logic
    if((op==6'd9) || (op==6'd12) || (op==6'd32) || (op==6'd36) || (op==6'd33) || (op==6'd37) || (op==6'd15) || (op==6'd35) || (op==6'd34) || (op==6'd38) || (op==6'd13) || (op==6'd10) || (op==6'd11) || (op==6'd14))begin
        CtrlRegDst = 2'd0; //Write address comes from rt
    end else if ((op==6'd0)&&((funct==6'd33) || (funct==6'd36) || (funct==6'd9) || (funct==6'd18) || (funct==6'd16) || (funct==6'd37) || (funct==6'd0) || (funct==6'd4) || (funct==6'd42) || (funct==6'd43) || (funct==6'd3) || (funct==6'd7) || (funct==6'd2) || (funct==6'd6) || (funct==6'd35) || (funct==6'd38)))begin
        CtrlRegDst = 2'd1; //Write address comes from rd
    end else if ((op == 6'd3) || ((op==6'd1)&&((rt==5'd17) || (rt==5'd16))))begin
        CtrlRegDst = 2'd2; //const reg 31, for writing to the link register
    end else begin CtrlRegDst = 1'bx; end//Not all instructions are encompassed so, added incase for debug purposes

    //CtrlPC logic
    if(ALUCond && ((op==6'd4) || (op==6'd7) || (op==6'd6) || (op==6'd5) || ((op==6'd1)&&((rt==5'd1) || (rt==5'd17) || (rt==5'd0) || (rt==5'd16)))))begin
        CtrlPC = 2'd1; // Branches - Jumps relative to PC
    end else if((op==6'd2) || (op==6'd3))begin
        CtrlPC = 2'd2; // Jumps within 256MB Region using 26-bit immediate in 6'd2 type instruction
    end else if((op==6'd0)&&((funct==6'd8) || (funct==6'd9)))begin
        CtrlPC = 2'd3; // Jumps using Register.
    end else begin CtrlPC = 2'd0; end // No jumps or branches, just increment to next word
    
    //CtrlMemRead and CtrlMemtoReg logic -- Interesting quirk that they have the same logic where both are concerned. Makes sense bc you'd only want to select the read data out when the memory itself is read enabled.
    if((op==6'd32) || (op==6'd36) || (op==6'd33) || (op==6'd37) || (op==6'd35) || (op==6'd34) || (op==6'd38))begin
        CtrlMemRead = 1;//Memory is read enabled
        CtrlMemtoReg = 3'd1;//write data port of regfile is fed from data memory
    end else if ((op==6'd9) || (op==6'd12) || (op==6'd13) || (op==6'd15) || (op==6'd10) || (op==6'd11) || (op==6'd14) || ((op==6'd0)&&((funct==6'd33) || (funct==6'd36) ||  (funct==6'd37) ||  (funct==6'd0) ||  (funct==6'd4) ||  (funct==6'd42) ||  (funct==6'd43) ||  (funct==6'd3) ||  (funct==6'd7) ||  (funct==6'd2) || (funct==6'd6) ||  (funct==6'd35) ||  (funct==6'd38))))begin
        CtrlMemRead = 0;//Memory is read disabled
        CtrlMemtoReg = 3'd0;//write data port of regfile is fed from ALURes
    end else if ((op==6'd3) || ((op==6'd0)&&(funct == 6'd9)) || ((op==6'd1)&&((rt==5'd17) || (rt==5'd16))))begin
        CtrlMemtoReg = 3'd2;//write data port of regfile is fed from PC + 8
    end else if ((op==6'd0)&&(funct == 6'd16))begin
        CtrlMemtoReg = 3'd3;//write data port of regfile is fed from ALUHi
    end else if ((op==6'd0)&&(funct == 6'd18))begin
        CtrlMemtoReg = 3'd4;//write data port of regfile is fed from ALULo
    end else if (((op==6'd0)&&(funct == 6'd8)) || (op == 6'd4) || (op==6'd43) ||((op==6'd1)&&(rt==5'd1)) || (op==6'd7) || ((op==6'd1)&&(rt==5'd0)) || (op==6'd6) || (op==6'd5) || (op==6'd2) || ((op==6'd0)&&(funct==6'd17)) || ((op==6'd0)&&(funct==6'd19)) || ((op==6'd0)&&(funct==6'd24)) || ((op==6'd0)&&(funct==6'd25)) || ((op==6'd0)&&(funct==6'd26)) || ((op==6'd0)&&(funct==6'd27)) || (op==6'd40) || (op==6'd41))begin
        CtrlMemRead = 0;//Read disabled during jump
    end else begin CtrlMemRead = 1'bx;end//Not all instructions are encompassed so, added incase for debug purposes

    //CtrlALUOp Logic
    if((op==6'd9) || ((op==6'd0)&&(funct==6'd33)))begin
        CtrlALUOp = 5'd0; //ADD from ALUOps
    end else if((op==6'd12) || ((op==6'd0)&&(funct==6'd36)))begin
        CtrlALUOp = 5'd4;//6'd36 from ALUOps
    end else if(op==6'd4) begin
        CtrlALUOp = 5'd13;//EQ from ALUOps
    end else if((op==6'd1)&&((rt==5'd1) || (rt==5'd17)))begin
        CtrlALUOp = 5'd17;//GEQ from ALUOps
    end else if(op==6'd7)begin
        CtrlALUOp = 5'd16;//GRT from ALUOps
    end else if(op==6'd6)begin
        CtrlALUOp = 5'd15;//LEQ from ALUOps
    end else if((op==6'd1)&&((rt==5'd0) || (rt==5'd16)))begin
        CtrlALUOp = 5'd14;//LES from ALUOps
    end else if(op==6'd5)begin
        CtrlALUOp = 5'd18;//NEQ from ALUOps
    end else if((op==6'd0)&&(funct==6'd26))begin
        CtrlALUOp = 5'd3;//6'd26 from ALUOps
    end else if((op==6'd0)&&(funct==6'd27))begin
        CtrlALUOp = 5'd23;//6'd27 from ALUOps
    end else if((op==6'd32) || (op==6'd36) || (op==6'd33) || (op==6'd37) || (op==6'd35) || (op==6'd34) || (op==6'd38) || (op==6'd40) || (op==6'd41) || (op==6'd43))begin
        CtrlALUOp = 5'd0;//ADD from ALUOps
    end else if(op==6'd15)begin
        CtrlALUOp = 5'd7;//6'd0 from ALUOps
    end else if((op==6'd0)&&((funct==6'd17)))begin
        CtrlALUOp = 5'd24;//6'd17 from ALUOps
    end else if((op==6'd0)&&((funct==6'd19)))begin
        CtrlALUOp = 5'd25;//6'd19 from ALUOps
    end else if((op==6'd0)&&(funct==6'd24))begin
        CtrlALUOp = 5'd2;//MUL from ALUOps
    end else if((op==6'd0)&&(funct==6'd25))begin
        CtrlALUOp = 5'd22;//MULU from ALUOps
    end else if((op==6'd13) || ((op==6'd0)&&(funct==6'd37)))begin
        CtrlALUOp = 5'd5;//6'd37 from ALUOps
    end else if((op==6'd0)&&(funct==6'd0))begin
        CtrlALUOp = 5'd7;//6'd0 from ALUOps
    end else if((op==6'd0)&&(funct==6'd4))begin
        CtrlALUOp = 5'd8;//6'd4 from ALUOps
    end else if((op==6'd0)&&(funct==6'd3))begin
        CtrlALUOp = 5'd11;//6'd3 from ALUOps
    end else if((op==6'd0)&&(funct==6'd7))begin
        CtrlALUOp = 5'd12;//6'd7 from ALUOps
    end else if((op==6'd0)&&(funct==6'd2))begin
        CtrlALUOp = 5'd9;//6'd2 from ALUOps
    end else if((op==6'd0)&&(funct==6'd6))begin
        CtrlALUOp = 5'd10;//6'd6 from ALUOps
    end else if((op==6'd10) || ((op==6'd0)&&(funct==6'd42)))begin
        CtrlALUOp = 5'd20;//6'd42 from ALUOps
    end else if((op==6'd11) || ((op==6'd0)&&(funct==6'd43)))begin
        CtrlALUOp = 5'd21;//6'd43 from ALUOps
    end else if((op==6'd0)&&(funct==6'd35))begin
        CtrlALUOp = 5'd1;//SUB from ALUOps
    end else if((op==6'd14) || ((op==6'd0)&&(funct==6'd38)))begin
        CtrlALUOp = 5'd6;//6'd38 from ALUOps
    end else begin
        CtrlALUOp = 5'bxxxxx;
    end

    //Ctrlshamt logic
    if((op==6'd0)&&((funct==6'd3) || (funct==6'd2) || (funct==6'd0)))begin
        Ctrlshamt = Instr[10:6];// Shift amount piped in from the instruction
    end else if(op == 6'd15)begin
        Ctrlshamt = 5'd16;//Used specifically to implement 6'd15 as the instruction itslef does not include shamt
    end else begin Ctrlshamt = 5'bxxxxx;end

    //CtrlMemWrite logic
    if((op==6'd40) || (op==6'd41) || (op==6'd43))begin
        CtrlMemWrite = 1;//Memory is write enabled
    end else begin CtrlMemWrite = 0;end//default is 0 to ensure no accidental overwriting.
    
    //CtrlSpcRegWriteEn logic
    if((op==6'd0)&&((funct==6'd17) || (funct==6'd19) || (funct==6'd24) || (funct==6'd25) || (funct==6'd26) || (funct==6'd27)))begin
        CtrlSpcRegWriteEn = 1;//Special register Hi and Lo are write enabled
    end else begin CtrlSpcRegWriteEn = 0;end//default is 0 to ensure no accidental overwriting.
    
    //CtrlALUSrc logic
    if((op==6'd9) || (op==6'd15) || (op==6'd10) || (op==6'd11) || (op==6'd32) || (op==6'd36) || (op==6'd33) || (op==6'd37) || (op==6'd35) || (op==6'd34) || (op==6'd38) || (op==6'd40) || (op==6'd41) || (op==6'd43))begin
        CtrlALUSrc = 1;//ALU Bus B is fed from the 16-bit immediate sign extended to 32-bit value taken from Instr[15-0]
    end else if((op==6'd4) || (op==6'd7) || (op==6'd6) || (op==6'd5) || ((op==6'd0)&&((funct==6'd33) || (funct==6'd36) || (funct==6'd26) || (funct==6'd27) || (funct==6'd24) || (funct==6'd25) || (funct==6'd37) || (funct==6'd0) || (funct==6'd4) || (funct==6'd42) || (funct==6'd43) || (funct==6'd3) || (funct==6'd7) || (funct==6'd2) || (funct==6'd6) || (funct==6'd35) || (funct==6'd38))) || ((op==6'd1)&&((rt==5'd1) || (rt==5'd17) || (rt==5'd0) || (rt==5'd16))))begin 
        CtrlALUSrc = 0;///ALU Bus B is fed from rt.
    end else if ((op==6'd13) || (op==6'd12) || (op==6'd14)) begin
        CtrlALUSrc = 2;
    end else begin CtrlALUSrc = 1'bx;end
       
    //CtrlRegWrite logic
    if((op==6'd9) || (op==6'd12) || (op==6'd32) || (op==6'd36) || (op==6'd33) || (op==6'd37) || (op==6'd15) || (op==6'd35) || (op==6'd34) || (op==6'd38) || (op==6'd13) || (op==6'd3) || (op==6'd10) || (op==6'd14) || ((op==6'd1)&&((rt==5'd17) || (rt==5'd16))) || ((op==6'd0)&&((funct==6'd33) || (funct==6'd36) || (funct==6'd18) || (funct==6'd16) || (funct==6'd37) || (funct==6'd0) || (funct==6'd4) || (funct==6'd42) || (funct==6'd43) || (funct==6'd3) || (funct==6'd7) || (funct==6'd2) || (funct==6'd6) || (funct==6'd35) || (funct==6'd9) || (funct==6'd38)))) begin
        CtrlRegWrite = 1;//The Registers are Write Enabled
    end else begin CtrlRegWrite = 0;end // The Registers are Write Disabled
end
endmodule