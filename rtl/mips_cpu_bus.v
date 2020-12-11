module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

logic[1:0] state; // current state of cpu within cycle
logic[1:0] n_state; // state to be set at next clk edge
logic[31:0] instr_reg; // instruction register / single-word cache for current instruction
logic clk_internal; // modulated clock to be passed to harvard cpu
logic[31:0] harvard_instr_address; // instr addr from pc
logic harvard_read; // harvard cpu read flag
logic harvard_write; // harvard cpu write flag

initial begin
    clk_internal = 1'b0;
    n_state = 2'b00;
    state = 2'b00;
    instr_reg = 32'h00000000;
    address = 32'h00000000;
    write = 1'b0;
    read = 1'b0;
    writedata = 32'h00000000;
    byteenable = 4'b0000;
end

always_ff @(posedge clk) begin // CLK Rising Edge
    if (waitrequest) begin
    end else begin
        case (n_state)
            2'b00: begin // fetch
                clk_internal <= 1'b1;
                state <= 2'b00;
            end
            2'b01: begin // execute
                state <= 2'b10;
                instr_reg <= readdata;
            end
            2'b10: begin // read
            end
            2'b11: begin // write
            end
        endcase // state
    end
end

always_ff @(negedge clk) begin // CLK Falling Edge
    case (state)
        2'b00: // nothing happens on fetch negedge
        2'b01: begin // execute negedge
            if (!harvard_read && !harvard_write) begin // instruction complete, trigger writeback
                clk_internal <= 1'b0;
            end // otherwise do nothing
        end
    endcase
end

always_comb begin
    if (reset) begin
        clk_internal = 1'b0;
        n_state = 2'b00;
        state = 2'b00;
        instr_reg = 32'h00000000;
        address = 32'h00000000;
        write = 1'b0;
        read = 1'b0;
        writedata = 32'h00000000;
        byteenable = 4'b0000;
    end else begin
        case (state)
            2'b00: begin
                address = harvard_instr_address;
                read = 1'b1;
                byteenable = 4'b1111;
                n_state = 2'b01;
            end
            2'b01: begin
                address = 32'h00000000;
                read = 1'b0;
                byteenable = 4'b0000;
                if (harvard_read) begin
                    n_state = 2'b10; // next state is read
                end else if (harvard_write) begin
                    n_state = 2'b11; // next state is write
                end else begin
                    n_state 2'b00; // next state is fetch
                end
            end
        endcase // state
    end
end

mips_cpu_harvard mips_cpu_harvard( // Harvard CPU within wrapper
.clk(clk_internal), // modulated clock input to allow waiting for valid data from memory, input
.reset(reset), // CPU reset, input
.active(active), // Is CPU active, output
.register_v0(register_v0), // $2 / $v0 debug bus, output
.clk_enable(1'b0), // unused clock enable, input
.instr_address(harvard_instr_address), // instr addr from pc, output
.instr_readdata(instr_reg), // cached instruction passed into harvard cpu, input
.data_address(######), // output
.data_write(harvard_write), // harvard write flag, output
.data_read(harvard_read), // harvard read flag, output
.data_writedata(######), // output
.data_readdata(######) // input
);

endmodule : mips_cpu_bus
