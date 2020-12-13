module mips_cpu_pc(
	input logic clk,
	input logic rst,
	input logic[1:0] pc_ctrl,
	input logic[31:0] pc_in,
	input logic[31:0] instr,
	input logic[31:0] reg_readdata,
	output logic[31:0] pc_out,
	output logic active
);

reg [31:0] pc_next, pc_lit_next;

initial begin
	pc_out = pc_in;
	pc_next = pc_out + 32'd4;
end

assign pc_lit_next = pc_out + 32'd4;

always_ff @(posedge clk) begin
	if (rst) begin
		active <= 1;
		pc_out <= 32'hBFC00000;
	end else begin
		if(pc_out == 32'd0) begin
			active <= 0;
		end
		pc_out <= pc_next;
		case(pc_ctrl)
			default: begin
				pc_next <= pc_out + 32'd4;
			end
			2'd1: begin // Branch
				pc_next <= pc_out + 32'd4 + {{14{instr[15]}},instr[15:0],2'b00};
			end
			2'd2: begin // Jump
				pc_next <= {pc_lit_next[31:28], instr[25:0], 2'b00};
				$display("JUMPING");
				$display("pc_lit_next: %h", pc_lit_next[31:28]);
				$display("instr: %b", instr[25:0]);
				$display("%h",pc_next);
			end
			2'd3: begin // Jump using Register
				pc_next <= reg_readdata;
			end
		endcase
	end
end

endmodule // pc