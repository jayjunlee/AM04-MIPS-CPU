module mips_cpu_harvard_tb;

    parameter RAM_INIT_FILE = "inputs/addiu.txt";
    parameter MEM_INIT_FILE = "inputs/addiu.data.txt";
    parameter TIMEOUT_CYCLES = 100;

    logic clk, clk_enable, reset, active, data_read, data_write;
    logic[31:0] register_v0, instr_address, instr_readdata, data_readdata, data_writedata, data_address;

    mips_cpu_memory #(RAM_INIT_FILE, MEM_INIT_FILE) ramInst(
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
        $dumpfile("mips_cpu_harvard.vcd");
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
        $display("Initial Reset 0");
        reset <= 0;
        
        
        $display("Initial Reset 1");
        @(posedge clk);
        reset <= 1;

        $display("Initial Reset 0: Start Program");
        @(posedge clk);
        reset <= 0;

        @(posedge clk);
        assert(active==1);
        else $display("TB: CPU did not set active=1 after reset.");

        while (active) begin
            //$display("Clk: %d", clk);
            @(posedge clk);
            //$display("Register v0: %d", register_v0);
            //$display("Reg File Write data: %d", cpuInst.in_writedata);
            $display("Reg File Out Read data: %h", cpuInst.out_readdata1);
            $display("Reg File opcode: %b", cpuInst.regfile.opcode);
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