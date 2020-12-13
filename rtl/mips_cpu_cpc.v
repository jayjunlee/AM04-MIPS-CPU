module cpc(
input logic clk,
input logic rst,
input logic[31:0] cpc_in,
output logic[31:0] cpc_out
);

reg[31:0] cpc_curr;

initial begin
	cpc_curr = 32'hBFC00000;
end // initial

always_comb begin
	if (rst) begin
		cpc_curr = 32'hBFC00000;
	end else begin
		cpc_curr = cpc_in;
	end
	
end

always_ff @(posedge clk) begin
	cpc_out <= cpc_curr;
end

endmodule // pc