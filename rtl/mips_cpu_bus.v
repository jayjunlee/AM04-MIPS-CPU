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
logic[31:0] harvard_data_address; // data addr from ALU
logic[31:0] harvard_readdata; // <= data read from Avalon MM Device
logic[31:0] harvard_writedata; // data to be written to Avalon MM Device
logic[3:0] write_byteenable; // byteenable calculator for partial write
logic clk_state; // make sure posedge and negedge of clk do not occur repeatedly
logic partial_write; // flag to control datapath when doing a partial write
logic[31:0] partial_writedata; // modified data for partial writes (StoreHalfword or StoreByte)
logic[31:0] write_data_address; // modified data address for partial writes

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
    clk_state = 0;
end

always_ff @(posedge clk) begin // CLK Rising Edge
    if (!waitrequest && !clk_state) begin
        case (n_state)
            2'b00: begin // fetch
                clk_internal <= 1'b1;
                state <= 2'b00;
            end
            2'b01: begin // execute
                state <= 2'b01;
                instr_reg <= readdata;
            end
            2'b10: begin // read
                state <= 2'b10;
            end
            2'b11: begin // write
                state <= 2'b11;
            end
        endcase // state
    end
    clk_state <= 1'b1;
end

always_ff @(negedge clk) begin // CLK Falling Edge
    if (!waitrequest && clk_state) begin
        case (state)
            2'b00: begin // nothing happens on fetch negedge
            end
            2'b01: begin // execute negedge
                if (!harvard_read && !harvard_write) begin // instruction complete, trigger writeback
                    clk_internal <= 1'b0;
                end // otherwise do nothing
            end
            2'b10: begin
                clk_internal <= 1'b0;
            end
            2'b11: begin
                clk_internal <= 1'b0;
            end
        endcase
    end
    clk_state <= 1'b0;
end

always_comb begin
    case (instr_reg[31:26])
        6'b101000: begin // Store Byte
            partial_write = 1'b1;
            case (harvard_data_address[1:0])
                2'b00: begin
                    partial_writedata = {{24{1'b0}}, harvard_writedata[7:0]};
                    write_byteenable = 4'b0001;
                    write_data_address = {harvard_data_address[31:2], 2'b00};
                end
                2'b01: begin
                    partial_writedata = {{16{1'b0}}, harvard_writedata[7:0], {8{1'b0}}};
                    write_byteenable = 4'b0010;
                    write_data_address = {harvard_data_address[31:2], 2'b00};
                end
                2'b10: begin
                    partial_writedata = {{8{1'b0}}, harvard_writedata[7:0], {16{1'b0}}};
                    write_byteenable = 4'b0100;
                    write_data_address = {harvard_data_address[31:2], 2'b00};
                end
                2'b11: begin
                    partial_writedata = {harvard_writedata[7:0], {24{1'b0}}};
                    write_byteenable = 4'b1000;
                    write_data_address = {harvard_data_address[31:2], 2'b00};
                end
            endcase
        end
        6'b101001: begin // Store Halfword
            partial_write = 1'b1;
            case (harvard_data_address[1:0])
                2'b00: begin
                    partial_writedata = {{16{1'b0}}, harvard_writedata[15:0]};
                    write_byteenable = 4'b0011;
                    write_data_address = {harvard_data_address[31:2], 2'b00};
                end
                2'b01: begin // halfword address must be matrually aligned, last bit must be 0
                    partial_writedata = 32'hxxxxxxxx;
                    write_byteenable = 4'bxxxx;
                    write_data_address = 32'hxxxxxxxx;
                end
                2'b10: begin
                    partial_writedata = {harvard_writedata[15:0], {16{1'b0}}};
                    write_byteenable = 4'b1100;
                    write_data_address = {harvard_data_address[31:2], 2'b00};
                end
                2'b11: begin // halfword address must be matrually aligned, last bit must be 0
                    partial_writedata = 32'hxxxxxxxx;
                    write_byteenable = 4'bxxxx;
                    write_data_address = 32'hxxxxxxxx;
                end
            endcase
        end
        default: begin // Store Word OR All other instructions (These flags are ignored outside the write state)
            partial_write = 1'b0;
            partial_writedata = 32'h00000000;
            write_byteenable = 4'b1111;
            write_data_address = harvard_data_address;
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
            2'b00: begin // connecting wires when in fetch state
                address = harvard_instr_address;
                read = 1'b1;
                write = 1'b0;
                byteenable = 4'b1111;
                harvard_readdata = 32'h00000000;
                writedata = 32'h00000000;
                n_state = 2'b01;
            end
            2'b01: begin // connecting wires when in execute state
                address = 32'h00000000;
                read = 1'b0;
                write = 1'b0;
                byteenable = 4'b0000;
                harvard_readdata = 32'h00000000;
                writedata = 32'h00000000;
                if (harvard_read) begin
                    n_state = 2'b10; // next state is read
                end else if (harvard_write) begin
                    n_state = 2'b11; // next state is write
                end else begin
                    n_state = 2'b00; // next state is fetch
                end
            end
            2'b10: begin // connecting wires when in read state
                address = harvard_data_address;
                read = 1'b1;
                write = 1'b0;
                byteenable = 4'b1111;
                harvard_readdata = readdata;
                writedata = 32'h00000000;
                n_state = 2'b00;
            end
            2'b11: begin // connecting wires when in write state
                address = write_data_address;
                read = 1'b0;
                write = 1'b1;
                byteenable = write_byteenable;
                harvard_readdata = 32'h00000000;
                writedata = partial_write ? partial_writedata : harvard_writedata;
                n_state = 2'b00;
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
.data_address(harvard_data_address), // harvard data memory address, output
.data_write(harvard_write), // harvard write flag, output
.data_read(harvard_read), // harvard read flag, output
.data_writedata(harvard_writedata), // data output from regfile readport2, output
.data_readdata(harvard_readdata) // data in from read instruction, input
);

endmodule
