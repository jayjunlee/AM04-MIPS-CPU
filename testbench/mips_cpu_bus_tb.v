module mips_cpu_bus_tb;

parameter INSTR_INIT_FILE = "";
parameter DATA_INIT_FILE = "";
parameter TIMEOUT_CYCLES = 1000; // Timeout cycles are higher to account for memory stall delays

logic clk, reset, active, write, read, waitrequest;
logic[31:0] address, register_v0, writedata, readdata;
logic[3:0] byteenable;

mips_cpu_bus_memory #(INSTR_INIT_FILE, DATA_INIT_FILE) memInst( //Avalon memory mapped bus controller (slave)
    .clk(clk), // clk input to mem
    .reset(reset), // reset input to stall mem during cpu reset
    .address(address), // addr input to mem
    .write(write), // write flag input
    .read(read), // read flag input
    .waitrequest(waitrequest), // mem stall output
    .writedata(writedata), // data to be written
    .byteenable(byteenable), // byteenable bus for writes
    .readdata(readdata) // read output port
);

mips_cpu_bus cpuInst(
    .clk(clk), // clk input to cpu wrapper
    .reset(reset), // reset input
    .active(active), // active output flag
    .register_v0(register_v0), // debug $2 or $v0 output bus
    .address(address), // mem addr output
    .write(write), // mem write output flag
    .read(read), // mem read output flag
    .waitrequest(waitrequest), // mem stall input flag
    .writedata(writedata), // data to write to mem output
    .byteenable(byteenable), // bytes to write output
    .readdata(readdata) // data from mem input
);

// Setup and clock
initial begin
    $dumpfile("mips_cpu_bus.vcd");
    $dumpvars(0,mips_cpu_bus_tb);
    clk=0;

    repeat (TIMEOUT_CYCLES) begin
        #10;
        clk = !clk;
        #10;
        clk = !clk;
    end

    $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
end

initial begin    
    reset <= 1;
    @(posedge clk);
    reset <= 0;

    @(posedge clk);
    assert(active==1)
    else $display("TB : CPU did not set active=1 after reset.");

    while (active) begin
        //$display("Clk: %d", clk);
        @(posedge clk);
        //$display("Register v0: %d", register_v0);
        //$display("Reg File Write data: %d", cpuInst.in_writedata);
        $display("Reg File Out Read data: %h", cpuInst.mips_cpu_harvard.out_readdata1);
        $display("Reg File opcode: %b", cpuInst.mips_cpu_harvard.regfile.opcode);
        //$display("ALU output: %h", cpuInst.out_ALURes);
        //$display("ALU input B: %h", cpuInst.alu.B);
    end

    @(posedge clk);
    $display("TB: CPU Halt; active=0");
    $display("Output:");
    $display("%d",register_v0);
    $finish;
end

endmodule