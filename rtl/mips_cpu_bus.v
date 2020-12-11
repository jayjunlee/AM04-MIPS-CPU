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

logic[31:0] instr_reg; // instruction register / single-word cache for current instruction
logic clk_internal; // modulated clock to be passed to harvard cpu

always_ff @(posedge clk) begin // how/when to pass through negedge?
    if (waitrequest) begin //if waitrequest is high, do nothing
    end else begin
        //update outputs?
    end
end

always_comb begin

end

mips_cpu_harvard mips_cpu_harvard( // Harvard CPU within wrapper
.clk(clk_internal), // modulated clock input to allow waiting for valid data from memory, input
.reset(reset), // CPU reset, input
.active(active), // Is CPU active, output
.register_v0(register_v0), // $2 / $v0 debug bus, output
.clk_enable(1'b0), // unused clock enable, input
.instr_address(######), // output
.instr_readdata(instr_reg), // cached instruction passed into harvard cpu, input
.data_address(######), // output
.data_write(######), // output
.data_read(######), // output
.data_writedata(######), // output
.data_readdata(######) // input
);

endmodule : mips_cpu_bus
