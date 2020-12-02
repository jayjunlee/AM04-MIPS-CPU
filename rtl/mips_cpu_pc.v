module pc(
input logic clk,
input logic rst,
input logic[31:0] pc_in,
output logic[31:0] pc_out
);

reg[31:0] pc_curr;

initial begin
	pc_curr = 32'hBFC00000;
end : initial

always_comb begin
	if (rst) begin
		pc_curr = 32'hBFC00000;
	end
	pc_out = pc_curr;
end

always_ff @(posedge clk) begin
	pc_curr <= pc_in;
end

endmodule : pc