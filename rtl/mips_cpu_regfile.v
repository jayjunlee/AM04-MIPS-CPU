module regfile(
input logic clk, //clock input for triggering write port
input logic[4:0] readreg1, //read port 1 selector
input logic[4:0] readreg2, //read port 2 selector
input logic[4:0] writereg, //write port selector
input logic[31:0] writedata, //write port input data
input logic regwrite, //enable line for write port
input[5:0] opcode, //opcode input for controlling partial load weirdness
output logic[31:0] readdata1, //read port 1 output
output logic[31:0] readdata2, //read port 2 output
output logic[31:0] regv0 //debug output of $v0 or $2 (third register in file/ first register for returning function results)
);

reg[31:0] memory [31:0]; //32 register slots, 32-bits wide

initial begin
	integer i; //Initialise to zero by default
    for (i = 0; i < 32; i++) begin
        memory[i] = 0;
    end
end

assign regv0 = memory[2]; //assigning debug $v0 line to $2 of memory

always_comb begin
	readdata1 = memory[readreg1]; //combinatorially output register value based on read port 1 selector
	readdata2 = memory[readreg2]; //combinatorially output register value based on read port 2 selector
end

always_ff @(negedge clk) begin
	if (regwrite) begin
		case (opcode)
			6'b100000: begin //lb, load byte
				memory[writereg] <= {{24{writedata[7]}}, writedata[7:0]};
			end
			6'b100100: begin //lbu, load byte unsigned
				memory[writereg] <= {{24{1'b0}}, writedata[7:0]};
			end
			6'b100001: begin //lh, load half-word
				memory[writereg] <= {{16{writedata[15]}}, writedata[15:0]};
			end
			6'b100101: begin //lhu, load half-word unsigned
				memory[writereg] <= {{16{1'b0}}, writedata[15:0]};
			end
			6'b100010: begin //lwl, load word left
				case (readdata1[1:0])
					2'b00: memory[writereg][31:24] <= writedata[7:0];
					2'b01: memory[writereg][31:16] <= writedata[15:0];
					2'b10: memory[writereg][31:8] <= writedata[23:0];
					2'b11: memory[writereg][31:0] <= writedata[31:0];
				endcase // readdata1[1:0]
			end
			6'b100110: begin //lwr, load word right
				case (readdata1[1:0])
					2'b00: memory[writereg][31:0] <= writedata[31:0];
					2'b01: memory[writereg][23:0] <= writedata[31:8];
					2'b10: memory[writereg][15:0] <= writedata[31:16];
					2'b11: memory[writereg][7:0] <= writedata[31:24];
				endcase // readdata1[1:0]
			end
			default: memory[writereg] <= writedata; //most instructions
		endcase // opcode
	end
end

endmodule : regfile