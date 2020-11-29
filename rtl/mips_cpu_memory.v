/*  
Memory for Harvard Interface
- RAM Size: 32 x 2^32 = 32 x 4294967296
- Instructions in binaries or hex -> RAM_INIT_FILE
- combinatorial read/fetch of instruction via instr_ port
- combinatorial read and single cycle write of data via data_ port

Constraints
read write
  0    0   -> nothing
  0    1   -> write
  1    0   -> read
  1    1   -> read ????? probs should never occur?

Instantiation of Memory Module
- mips_cpu_memory #(RAM_INIT_FILE) ramInst(clk, data_address, data_write, data_read, data_writedata, data_readdata, instr_address, instr_readdata);

Special Memory Locations
- Whether a particular address maps to RAM, ROM, or something else is entirely down to the top-level circuit outside your CPU.
- special memory locations: 0x00000000 (CPU halt), 0xBFC00000 (start execution after reset)
- PC should be 0xBFC00000 at the start and 0x00000000 at the end

Needs checking with:
-- clk or clk_enable?
-- constraint on not being able to read and write in the same cycle
-- whether there is a more efficient way of initialising memory to zero (line 32)
*/

module mips_cpu_memory(
    input logic clk_enable,

    //Data Memory
    input logic[31:0] data_address,
    input logic data_write,
    input logic data_read,
    input logic[31:0] data_writedata,
    output logic[31:0] data_readdata,

    //Instruction Memory
    input logic[31:0] instr_address,
    output logic[31:0] instr_readdata

);
    parameter RAM_INIT_FILE = "";

    reg [31:0] memory [4294967295:0];   // 2^32 memory locations of 32 bits size

    initial begin
        integer i;
        //Initialise to zero by default
        for (i=0; i<4294967296; i++) begin
            memory[i]=0;
        end
        //Load contents from file if specified
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
    end

    //Combinatorial read path for data and instruction.
    if (clk_enable == 1) begin
        assign data_readdata = data_read ? memory[data_address] : 16'hxxxx;
        assign instr_readdata = memory[instr_address];
    end
    else begin
        assign data_readdata = data_readdata;
        assign instr_readdata = instr_address;
    end


    //Synchronous write path
    always_ff @(posedge clk_enable) begin
        //$display("RAM : INFO : data_read=%h, data_address = %h, mem=%h", data_read, data_address, memory[data_address]);
        if (!data_read & data_write) begin              //cannot read and write to memory in the same cycle
            if (instr_address != data_address) begin    //cannot modify the instruction being read
                memory[data_address] <= data_writedata;            
            end
        end
    end
endmodule

