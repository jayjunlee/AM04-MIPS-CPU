module mips_cpu_npc(
input logic clk,
input logic rst,
input logic[31:0] npc_in,
output logic[31:0] npc_out
);

reg[31:0] npc_curr;

initial begin
	npc_curr = (32'hBFC00000 + 32'd4);
	npc_out = 32'hBFC00000;
end // initial

always_comb begin
	if (rst) begin
		npc_curr = (32'hBFC00000 + 32'd4);
	end else begin
		npc_curr = npc_in;
	end
	
end

always_ff @(posedge clk) begin
	npc_out <= npc_curr;
end

endmodule // pc