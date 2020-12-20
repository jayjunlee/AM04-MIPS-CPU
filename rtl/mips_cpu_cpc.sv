module mips_cpu_cpc(
input logic clk,
input logic rst,
input logic[31:0] cpc_in,
output logic[31:0] cpc_out,
output logic active
);

reg[31:0] cpc_curr;
reg is_active;

initial begin
	cpc_curr = 32'hBFC00000;
end // initial

always_comb begin
	if (rst) begin
		cpc_curr = 32'hBFC00000;
		is_active = 1;
	end else begin
		cpc_curr = cpc_in;
		if(cpc_in == 32'd0)begin
			is_active = 0;
		end else begin
			is_active = 1;
		end
	end	
end

always_ff @(posedge clk) begin
	cpc_out <= cpc_curr;
	active <= is_active;
end

endmodule // pc