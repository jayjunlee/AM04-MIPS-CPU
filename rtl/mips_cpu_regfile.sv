module mips_cpu_regfile(
input logic clk, //clock input for triggering write port
input logic rst,
input logic[4:0] readreg1, //read port 1 register selector
input logic[4:0] readreg2, //read port 2 register selector
input logic[4:0] writereg, //write port register selector
input logic[31:0] writedata, //write port input data
input logic regwrite, //enable line for write port
input[5:0] opcode, //opcode input for controlling partial load weirdness
output logic[31:0] readdata1, //read port 1 output
output logic[31:0] readdata2, //read port 2 output
input logic[1:0] vaddr, //partial read offset from ALUout
output logic[31:0] regv0 //debug output of $v0 or $2 (third register in file/ first register for returning function results)
);

logic[31:0] memory [0:31]; //32 register slots, 32-bits wide

initial begin
	integer i; //Initialise to zero by default
    for (i = 0; i < 32; i++) begin
        memory[i] = 0;
    end
end

assign regv0 = memory[2]; //assigning debug $v0 line to $2 of memory

assign readdata1 = memory[readreg1]; //combinatorially output register value based on read port 1 selector
assign readdata2 = memory[readreg2]; //combinatorially output register value based on read port 2 selector

always_ff @(posedge rst or negedge clk) begin
	if(rst) begin
		integer i; //Initialise to zero when reset
		for (i = 0; i < 32; i++) begin
			memory[i] = 0;
		end
	end else begin
		if (writereg == 5'b00000) begin
			// skip writing if rd is $0
		end else if (regwrite) begin
			case (opcode)
				6'b100000: begin //lb, load byte
					case (vaddr)	
						2'b00: memory[writereg] <= {{24{writedata[7]}}, writedata[7:0]};
						2'b01: memory[writereg] <= {{24{writedata[15]}}, writedata[15:8]};
						2'b10: memory[writereg] <= {{24{writedata[23]}}, writedata[23:16]};
						2'b11: memory[writereg] <= {{24{writedata[31]}}, writedata[31:24]};
					endcase // readdata1[1:0]
				end
				6'b100100: begin //lbu, load byte unsigned
					case (vaddr)
						2'b00: memory[writereg] <= {{24{1'b0}}, writedata[7:0]};
						2'b01: memory[writereg] <= {{24{1'b0}}, writedata[15:8]};
						2'b10: memory[writereg] <= {{24{1'b0}}, writedata[23:16]};
						2'b11: memory[writereg] <= {{24{1'b0}}, writedata[31:24]};
					endcase // readdata1[1:0]
				end
				6'b100001: begin //lh, load half-word
					case (vaddr) // must be half-word aligned, readdata1[0] = 0
						2'b00: memory[writereg] <= {{16{writedata[15]}}, writedata[15:0]};
						2'b10: memory[writereg] <= {{16{writedata[31]}}, writedata[31:16]};
					endcase // readdata1[1:0]
				end
				6'b100101: begin //lhu, load half-word unsigned
					case (vaddr) // must be half-word aligned, readdata1[0] = 0
						2'b00: memory[writereg] <= {{16{1'b0}}, writedata[15:0]};
						2'b10: memory[writereg] <= {{16{1'b0}}, writedata[31:16]};
					endcase // readdata1[1:0]
				end
				6'b100010: begin //lwl, load word left
					case (vaddr)
						2'b00: memory[writereg][31:24] <= writedata[7:0];
						2'b01: memory[writereg][31:16] <= writedata[15:0];
						2'b10: memory[writereg][31:8] <= writedata[23:0];
						2'b11: memory[writereg][31:0] <= writedata[31:0];
					endcase // readdata1[1:0]
				end
				6'b100110: begin //lwr, load word right
					case (vaddr)
						2'b00: memory[writereg][31:0] <= writedata[31:0];
						2'b01: memory[writereg][23:0] <= writedata[31:8];
						2'b10: memory[writereg][15:0] <= writedata[31:16];
						2'b11: memory[writereg][7:0] <= writedata[31:24];
					endcase // readdata1[1:0]
				end
				default: begin 
					memory[writereg] <= writedata; //most instructions
				end
			endcase // opcode
		end
	end
end

endmodule
