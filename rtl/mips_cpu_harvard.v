module mips_cpu_harvard(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic [31:0] register_v0,

    /* New clock enable. See below. */
    input logic clk_enable,

    /* Combinatorial read access to instructions */
    output logic[31:0] instr_address,
    input logic[31:0] instr_readdata,

    /* Combinatorial read and single-cycle write access to instructions */
    output logic[31:0] data_address,
    output logic data_write,
    output logic data_read,
    output logic[31:0] data_writedata,
    input logic[31:0] data_readdata
);

//Control Flags
logic Jump, Branch, ALUSrc, ALUZero, RegWrite;
logic[5:0] ALUOp = instr_readdata[31:26];
logic[999999999999999999999999999999999999999999999999999999999999999999:0] ALUFlags;
logic[1:0] RegDst, MemtoReg;

//PC wires
logic[31:0] pc_curr;
logic[31:0] pc_next = Jump ? Jump_addr : PCSrc ? {pc_curr+4+{{14{instr_readdata[15]}}, instr_readdata[15:0], 2'b00}} : {pc_curr+4};
logic[31:0] Jump_addr = {{pc_curr+4}[31:28], instr_readdata[25:0], 2'b00};
logic PCSrc = Branch && ALUZero;

//Instruction MEM
assign instr_address = pc_curr;

//deconstruction of instruction :)
logic[5:0] opcode = instr_readdata[31:26];
logic[4:0] rs = instr_readdata[25:21];
logic[4:0] rt = instr_readdata[20:16];
logic[4:0] rd = RegDst==2'b10 ? 5'b11111 : RegDst==2'b01 ? instr_readdata[15:11] : instr_readdata[20:16];
logic[15:0] immediate = instr_readdata[15:0];
logic[10:6] shamt = instr_readdata[10:6]; // Shamt needed for the sll instruction


//ALU Data
logic[31:0] alu_in1 = read_data1;
logic[31:0] alu_in2 = ALUSrc ? {{16{in[15]}},immediate} : read_data2;
logic[31:0] ALUOut;

//Data MEM
assign data_address = ALUOut; //address to be written to comes from ALU
assign data_writedata = read_data2; //data to be written comes from reg read bus 2

//Writeback logic
logic[31:0] writeback = MemtoReg==2'b10 ? {pc_curr+4} : MemtoReg==2'b01 ? data_readdata : ALUOut;

pc pc(
.clk(clk),
.pc_in(pc_next),
.pc_out(pc_curr)
);

control control( //control flags block
.opcode(opcode), //opcode to be decoded
.jump(Jump), //jump flag: 0 - increment or branch, 1 - J-type jump
.branch(Branch), //branch flag: 0 - increment, 1 - branch if ALU.Zero == 1
.memread(data_read), //tells data memory to read out data at dMEM[ALUout]
.memtoreg(MemtoReg), //0: writeback = ALUout, 1: writeback = data_readdata
.memwrite(data_write), //tells data memory to store data_writedata at data_writeaddress
.alusrc(ALUSrc), //0: ALUin2 = read_data2, 1: ALUin2 = signextended(instr_readdata[15:0])
.regwrite(RegWrite), //tells register file to write writeback to rd
.regdst(RegDst) //select Rt, Rd or $ra to store to
);

regfile regfile(
.clk(clk), //clock input for triggering write port
.readreg1(rs), //read port 1 selector
.readreg2(rt), //read port 2 selector
.writereg(rd), //write port selector
.writedata(writeback), //write port input data
.regwrite(RegWrite), //enable line for write port
.opcode(opcode), //opcode input for controlling partial load weirdness
.readdata1(read_data1), //read port 1 output
.readdata2(read_data2), //read port 2 output
.regv0(register_v0) //debug output of $v0 or $2 (first register for returning function results
);

alucontrol alucontrol(
.ALUOp(ALUOp), //opcode of instruction
.funct(immediate[5:0]), //funct of instruction
.aluflags(ALUFlags) //ALU Control flags
);

alu alu(
.aluflags(ALUFlags), //selects the operation carried out by the ALU
.in1(alu_in1), //operand 1
.in2(alu_in2), //operand 2
.zero(ALUZero), //is the result zero, used for checks
.out(ALUOut) //output/result of operation
);
endmodule : mips_cpu_harvard
