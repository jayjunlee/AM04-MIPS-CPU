module mips_cpu_bus_memory( //Avalon memory mapped bus controller (slave)
    input logic clk,
    input logic[31:0] address,
    input logic write,
    input logic read,
    output logic waitrequest,
    input logic[31:0] writedata,
    input logic[3:0] byteenable,
    output logic[31:0] readdata
);

parameter INSTR_INIT_FILE = "";
parameter DATA_INIT_FILE = "";

logic [31:0] data_memory [0:63]; // location 0x00001000 onwards
logic [31:0] instr_memory [0:63]; // location 0xBFC00000 onwards

initial begin
    for (integer i=0; i<$size(data_memory); i++) begin //Initialise data to zero by default
        data_memory[i] = 0;
    end

    for (integer i=0; i<$size(instr_memory); i++) begin //Initialise instr to zero by default
        instr_memory[i] = 0;
    end

    if (INSTR_INIT_FILE != "") begin //Load instr contents from file if specified
        $display("RAM: Loading RAM contents from %s", INSTR_INIT_FILE);
        $readmemh(INSTR_INIT_FILE, instr_memory);
    end

    for (integer i = 0; i<$size(instr_memory); i++) begin //Read out instr contents to log
        $display("byte +%h: %h", 32'hBFC00000+i*4, instr_memory[i]);
    end

    if (DATA_INIT_FILE != "") begin //Load data contents from file if specified
        $display("MEM: Loading MEM contents from %s", DATA_INIT_FILE);
        $readmemh(DATA_INIT_FILE, data_memory);
    end else begin
        $display("MEM FILE NOT GIVEN");
    end

    for (integer i = 0; i<$size(data_memory); i++) begin //Read out data contents to log
        $display("byte +%h: %h", 32'h00001000+i*4, data_memory[i]);
    end
end

always_ff @(posedge read or posedge write) begin
    waitrequest <= 1;
end

always_ff @(posedge clk) begin
    if (waitrequest) begin
        if (read) begin
            // read code
        end else if (write) begin
            // write code
        end else begin
            waitrequest = 1'bx;
            readdata = 32'hxxxxxxxx;
        end
    end else begin
        waitrequest = 1'b0;
        readdata = 32'h00000000;
    end
end


endmodule