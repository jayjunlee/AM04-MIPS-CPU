module regfile(
input logic clk, //clock input for triggering write port
input logic[4:0] readreg1, //read port 1 selector
input logic[4:0] readreg2, //read port 2 selector
input logic[4:0] writereg, //write port selector
input logic[31:0] writedata, //write port input data
input logic regwrite, //enable line for write port
output logic[31:0] readdata1, //read port 1 output
output logic[31:0] readdata2, //read port 2 output
output logic[31:0] regv0 //debug output of $v0 or $2 (third register in file/ first register for returning function results)
);

reg[31:0] memory [31:0]; //32 register slots, 32-bits wide

initial begin
	integer i; //Initialise to zero by default
    for (i = 0; i < 31; i++) begin
        memory[i] = 0;
    end
end

assign regv0 = memory[2]; //assigning debug $v0 line to $2 of memory

always_comb begin
	readdata1 = memory[readreg1]; //combinatorially output register value based on read port 1 selector
	readdata2 = memory[readreg2]; //combinatorially output register value based on read port 2 selector
end

always_ff @(posedge clk) begin
	if (regwrite) begin
		memory[writereg] <= writedata;
	end
end

endmodule : regfile