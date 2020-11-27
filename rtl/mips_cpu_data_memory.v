/*  
Data Memory for Harvard Interface
- RAM Size: 32 x 2^32 = 32 x 4294967296
- Zero-cycle / combinatorial reads
- Instruction in binaries or hex -> RAM_INIT_FILE

Needs checking with:
-- clk_enable input being used instead of clk
-- whether there is a more efficient way of initialising memory to zero (line 32)
-- how to implement given that you cannot read and write in the same cycle (line 48)
-- special memory locations: 0x00000000 (CPU halt), 0xBFC00000 (start execution after reset)
        -> Should PC be 0xBFC00000 at the start and 0x00000000 at the end?
        -> And should instructions start from 0xBFC00000?
        -> Put halt instruction at 0x00000000 by default? - What is the halt instruction?
*/

module mips_cpu_data_memory(
    input logic clk_enable,
    input logic[31:0] data_address,
    input logic data_write,
    input logic data_read,
    input logic[31:0] data_writedata,
    output logic[31:0] data_readdata
);
    parameter RAM_INIT_FILE = "";

    reg [31:0] memory [4294967295:0];

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<4294967296; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
    end

    /* Combinatorial read path. */
    assign data_readdata = data_read ? memory[data_address] : 16'hxxxx;

    /* Synchronous write path */
    always_ff @(posedge clk_enable) begin
        //$display("RAM : INFO : data_read=%h, data_addr = %h, mem=%h", data_read, data_address, memory[data_address]);
        if (!data_read & data_write) begin
            memory[data_address] <= data_writedata;
        end
    end
endmodule