module pc(
input logic clk,
input logic rst,
input logic[1:0] pc_ctrl,
input logic[31:0] pc_in,
input logic[4:0] rs,
output logic[31:0] pc_out,
output logic active
);

reg [31:0] pc_curr;

initial begin
	pc_out = pc_in;
end // initial

always_ff @(posedge clk) begin
	if (rst) begin
		active <= 1;
		pc_out <= 32'hBFC00000;
	end else if (pc_out != 32'd0) begin
		active <= active;
		case(pc_ctrl)
			2'd0: begin
				pc_curr <= pc_out;
				pc_out <= pc_curr + 32'd4;//No branch or jump or load, so no delay slot.
				$display("New PC from %h to %h", pc_curr, pc_out);
			end
			2'd1: begin
				pc_out <= pc_in;//Branches
			end
			2'd2: begin
				pc_out <= pc_in;//Jumps
			end
			2'd3: begin
				$display("JUMP REGISTER");
				pc_out <= 32'd0;//Jumps using register
			end
		endcase
	end else if (pc_out == 32'd0) begin
		active <= 0;
		//$display("CPU Halt");
	end
end

endmodule // pc