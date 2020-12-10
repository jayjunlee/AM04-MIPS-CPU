module mips_cpu_memory(
    input logic clk,

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

    reg [31:0] data_memory [0:63];
    reg [31:0] instr_memory [0:63];

    initial begin
        integer i;
        //Initialise to zero by default
        for (i=0; i<$size(data_memory); i++) begin
            data_memory[i] = 0;
        end
        for (i=0; i<$size(instr_memory); i++) begin
            instr_memory[i] = 0;
        end
        //Load contents from file if specified
        if (RAM_INIT_FILE != "") begin
            $display("RAM: Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, instr_memory);
        end

        for (integer j = 0; j<$size(instr_memory); j++) begin
            $display("byte +%h: %h", 32'hBFC00000+j*4, instr_memory[j]);
        end
    end

    //Combinatorial read path for data and instruction.
    assign data_readdata = data_read ? data_memory[data_address>>2] : 32'hxxxxxxxx;
    assign instr_readdata = (instr_address >= 32'hBFC00000 && instr_address < 32'hBFC00000+$size(instr_memory)) ? instr_memory[(instr_address-32'hBFC00000)>>2] : 32'hxxxxxxxx;


    //Synchronous write path
    always_ff @(posedge clk) begin
        $display("Instruction Read: %h", instr_readdata);
        //$display("RAM : INFO : data_read=%h, data_address = %h, mem=%h", data_read, data_address, memory[data_address]);
        if (!data_read & data_write) begin              //cannot read and write to memory in the same cycle
            if (instr_address != data_address) begin    //cannot modify the instruction being read
                data_memory[data_address] <= data_writedata;            
            end
        end
    end
endmodule
