module ProgramCounter(

	input logic			rst, 
	input logic			clk, 
	
	input logic[31:0]	pcWriteAddr,
	input logic			pcWriteEn,

	output logic[31:0]  pcRes,

	);

	logic[31:0] pcIncr;

	initial begin
	
		pcRes <= 32'h00000000;
	end

	always_comb begin
		pcIncr = pcRes + 32'h00000004
	end

    always @(posedge clk)
    begin
    	if (rst == 1)
    	begin
    		pcRes <= 32'h00000000;
    	end
    	else
    	begin
			if (pcWriteEn == 1) begin
				pcRes <= pcWriteAddr;
			end
			else begin
				pcRes <= pcIncr;
			end
    	end

		$display("pc = %h",pcRes);
    end

endmodule