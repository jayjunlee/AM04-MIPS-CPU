module pc(
input logic clk,
input logic rst,
input logic[31:0] Instr,
input logic[31:0] JumpReg,
input logic[1:0] pc_ctrl
output logic[31:0] pc_out
);

logic[31:0] out_cpc_out;
logic[31:0] out_npc_out;
logic[31:0] in_npc_in;

assign pc_out = out_cpc_out;

always_comb begin
    case(pc_ctrl)
        2'd0: begin
            in_npc_in = out_npc_out + 32'd4;//No branch or jump or load.
        end
        2'd1: begin
            in_npc_in = out_npc_out + {{14{Instr[15]}}, Instr[15:0], 2'b00};
        end
        2'd2: begin
            in_npc_in = {out_npc_out[31:28], Instr[25:0], 2'b00};
        end
        2'd3: begin
            in_npc_in = JumpReg;
        end
    endcase	
end

mips_cpu_cpc cpc(
//Inputs for cpc
	.clk(clk),
	.rst(rst),
	.cpc_in(out_npc_out),
//Outputs for cpc
	.cpc_out(out_cpc_out)
);

mips_cpu_cpc npc(
//Inputs for npc
	.clk(clk),
	.rst(rst),
	.npc_in(in_npc_in),
//Outputs for npc
	.npc_out(out_npc_out)
);

endmodule