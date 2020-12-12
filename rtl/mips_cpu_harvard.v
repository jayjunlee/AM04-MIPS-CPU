module mips_cpu_harvard(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic [31:0] register_v0,

    /* New clock enable. See below. */
    input logic clk_enable,
    
    /* Combinatorial read access to instructions */
    output logic[31:0] instr_address,//Port from PC out to instruction memory address input.
    input logic[31:0] instr_readdata,//port from instruction memory out, going to various inputs.

    /* Combinatorial read and single-cycle write access to instructions */
    output logic[31:0] data_address,//Port from ALURes going into Data Memory 'Address' port
    output logic data_write,//Control line from 'control' CtrlMemWrite enabling/disabling write access for Data Memory.
    output logic data_read,//Control line from 'control' CtrlMemRead enabling/disabling read access for Data Memory.
    output logic[31:0] data_writedata,//Data from Register file 'Read data 2' port, aka rt's data, going to 'Write data' port on Data Memory.
    input logic[31:0] data_readdata//port from data memory out, going to the 'Write Register' port in regfile.
);

assign instr_address = in_pc_in;
assign data_address = out_ALURes;
assign data_write = out_MemWrite;
assign data_read = out_MemRead;
assign data_writedata = out_readdata2;

logic[31:0] in_pc_in, out_pc_out = 32'hBFC00000, out_ALURes, out_readdata1, out_readdata2, in_B, in_writedata;
logic[4:0]  in_readreg1, in_readreg2, in_writereg, out_shamt, out_ALUOp;
logic[5:0]  in_opcode;
logic out_ALUCond, out_RegWrite, out_ALUSrc, out_MemWrite, out_MemRead;
logic[1:0] out_RegDst, out_PC, out_MemtoReg;

assign in_readreg1 = instr_readdata[25:21];
assign in_readreg2 = instr_readdata[20:16];
assign in_opcode   = instr_readdata[31:26];

always @(*) begin
    //Picking what register should be written to.
    case(out_RegDst)
        2'd0: begin
            in_writereg = instr_readdata[20:16];//GPR rt
        end
        2'd1: begin
            in_writereg = instr_readdata[15:11];//GPR rd
        end
        2'd2: begin
            in_writereg = 5'd31;//Link Register 31.
        end
    endcase

    //Picking which output should be written to regfile.
    case(out_MemtoReg)
        2'd0:begin
            in_writedata = out_ALURes;//Output from ALU Result.
        end
        2'd1:begin
            in_writedata = data_readdata;//Output from Data Memory.
        end
        2'd2:begin
            in_writedata = (out_pc_out + 32'd8);//Output from PC +8.
        end
    endcase

    //Picking which output should be taken as the second operand for ALU.
    case(out_ALUSrc)
        1'b1:begin
            in_B = {{16{instr_readdata[15]}},instr_readdata[15:0]};//Output from the 16-bit immediate values sign extened to 32bits.
        end
        1'b0:begin
            in_B = out_readdata2;//Output from 'Read data 2' port of regfile.
        end
    endcase
end

mips_cpu_pc pc(
//PC inputs
    .clk(clk),//clk taken from the Standard signals
    .rst(reset),//clk taken from the Standard signals
    .instr(instr_readdata), //needed for branches and jumps
    .reg_readdata(out_readdata1), //needed for jump register
    .pc_ctrl(out_PC),
    .pc_in(out_pc_out),//what the pc will output on the next clock cycle taken from either: PC itself + 4(Normal/Default Operation); or 16-bit signed valued taken from Instr[15-0] sign extend to 32bit then shifted by 2 then added to PC + 4(Branch Operation); or 26-bit instruction address taken from J-type instr[25-0] shifted left by 2 then concatanated to form Jump Address (PC-region branch); or from the GPR rs.
//PC outputs
    .pc_out(in_pc_in),//What the pc outputs at every clock edge that goes into the 'Read address' port of Instruction Memory.
    .active(active)
);

mips_cpu_control control( //instance of the 'mips_cpu_control' module called 'control' in top level 'harvard'
//Inputs to control
    .Instr(instr_readdata), //Full instruction taken from the Instruction Memory.
    .ALUCond(out_ALUCond), //Active high condition check from ALU
//Outputs from control
    .CtrlRegDst(out_RegDst),
    .CtrlPC(out_PC),
    .CtrlMemRead(out_MemRead),
    .CtrlMemtoReg(out_MemtoReg),
    .CtrlALUOp(out_ALUOp),
    .Ctrlshamt(out_shamt),
    .CtrlMemWrite(out_MemWrite),
    .CtrlALUSrc(out_ALUSrc),
    .CtrlRegWrite(out_RegWrite)
);

mips_cpu_regfile regfile(
//Inputs to refile
    .clk(clk), //clock input for triggering write port
    .readreg1(in_readreg1), //read port 1 selector
    .readreg2(in_readreg2), //read port 2 selector
    .writereg(in_writereg), //write port selector
    .writedata(in_writedata), //write port input data
    .regwrite(out_RegWrite), //enable line for write port
    .opcode(in_opcode), //opcode input for controlling partial load weirdness
//Outputs from regfile
    .readdata1(out_readdata1), //read port 1 output
    .readdata2(out_readdata2), //read port 2 output
    .regv0(register_v0) //debug output of $v0 or $2 (first register for returning function results
);

mips_cpu_alu alu(
//Inputs to ALU
    .A(out_readdata1), //operand 1 taken from 'Read data 1' aka the data stored in GPR rs.
    .B(in_B), //operand 2 taken either from: 'Read data 2' aka the data stored in rt; or 16-bit immediate sign extended to 32 bits.
    .ALUOp(out_ALUOp), //Operation selection for ALU decided, and output by control.
    .shamt(out_shamt), //Shift amount required for shift instruction taken from control.
//Outputs from ALU
    .ALUCond(out_ALUCond), //condition used by control to decide on branch instructions.
    .ALURes(out_ALURes) //output/result of operation that goes to either: 'Address' port of Data Memory; or 'Write Data' port of the register file.
);

endmodule
