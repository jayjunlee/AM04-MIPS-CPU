module mips_cpu_harvard_tb;
    timeunit 1ns / 10ps;

    parameter RAM_INIT_FILE = "inputs/";
    parameter TIMEOUT_CYCLES = 10000;

    logic clk, clk_enable, reset, active;
    logic[31:0] register_v0;
    logic[31:0] instr_address, instr_readdata;
    logic data_read, data_write;
    logic[31:0] data_readdata, data_writedata, data_address;

    mips_cpu_memory #(RAM_INIT_FILE) ramInst(
        .clk(clk), 
        .data_address(data_address), 
        .data_write(data_write), 
        .data_read(data_read), 
        .data_writedata(data_writedata), 
        .data_readdata(data_readdata), 
        .instr_address(instr_address), 
        .instr_readdata(instr_readdata)
    );    
    mips_cpu_harvard cpuInst(
        .clk(clk), 
        .reset(reset), 
        .active(active), 
        .register_v0(register_v0), 
        .clk_enable(clk_enable), 
        .instr_address(instr_address), 
        .instr_readdata(instr_readdata), 
        .data_address(data_address), 
        .data_write(data_write), 
        .data_read(data_read), 
        .data_writedata(data_writedata), 
        .data_readdata(data_readdata)
    );

    // Generate clock
    initial begin
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
        reset <= 0;

        @(posedge clk);
        reset <= 1;

        @(posedge clk);
        reset <= 0;

        @(posedge clk);
        assert(active==1) // Is this assert still valid?
        else $display("TB : CPU did not set active=1 after reset.");

        while (active) begin
            @(posedge clk);
        end

        $display("TB : finished; running=0");
        $display("%d",register_v0);
        $finish;

    end
endmodule