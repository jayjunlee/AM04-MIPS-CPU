module mips_cpu_harvard_tb;

    parameter INSTR_INIT_FILE = "";
    parameter DATA_INIT_FILE = "";
    parameter TESTCASE = "";
    parameter TIMEOUT_CYCLES = 100;

    logic clk, clk_enable, reset, active, data_read, data_write;
    logic[31:0] register_v0, instr_address, instr_readdata, data_readdata, data_writedata, data_address;

    assign clk_enable = 1'b1;

    mips_cpu_harvard_memory #(INSTR_INIT_FILE, DATA_INIT_FILE) ramInst(
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
        $dumpfile(TESTCASE);
        $dumpvars(0,mips_cpu_harvard_tb);
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
        assert(active==1);
        else $display("TB: CPU did not set active=1 after reset.");

        while (active) begin
            @(posedge clk);
        end
        @(posedge clk);
        $display("TB: CPU Halt; active=0");
        $display("Output:");
        $display("%d",register_v0);
        $finish;

    end
endmodule