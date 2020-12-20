module mips_cpu_alu(
    input logic clk, //clock for special registers Hi and Lo
    input logic rst,
    input logic[31:0] A, //Bus A - Input from the Readdata1 output from the reg file which corresponds to rs. 
    input logic[31:0] B, //Bus B - Input from the Readdata2 output from the reg file which corresponds to rt. Or from the 16-bit immediate sign extended to 32-bit value taken from Instr[15-0].
    input logic [4:0] ALUOp, // 5-bit output from Control that tells the alu what operation to do from a list of 20 distinct alu operations(see below).
    input logic [4:0] shamt, //5-bit input used to specify shift amount for shift operations. Taken directly from the R-type instruction (Non-Variable) or from GPR rs (Variable)
    input logic[31:0] Hi_in,
    input logic[31:0] Lo_in,
    input logic SpcRegWriteEn,

    output logic ALUCond, //If a relevant condition is met, this output goes high(Active High). Note: Relevant as in related to current condition being tested.
    output logic[31:0] ALURes, // The ouput of the ALU
    output logic[31:0] ALUHi, //Special Hi Register output
    output logic[31:0] ALULo //Special Hi Register output
);

/*  

Alu Operations:
-Manipulation Operations: They perform an operation on a value(s) and have an output to ALURes.
    - Addition (unsigned)
    - Subtraction (unsigned)
    - Multiplication
    - Division
    - Bitwise AND
    - Bitwise OR
    - Bitwise XOR
    - Shift Left Logical
    - Shift Left Logical Variable
    - Shift Right Logical
    - Shift Right Logical Variable
    - Shift Right Arithmetic
    - Shift Right Arithmetic Variable
    - Set On Less Than (signed)
    - Set On Less Than Unsigned
    - Multiplication (unsigned)
    - Division (unsigned)
-Condtional Check Operations: They check conditions and have an output to ALUCond
    - Equality (=) (signed)
    - Less Than (<) (signed)
    - Less Than or Equal To (<=) (signed)
    - Greater Than (>) (signed)
    - Greater Than or Equal to (>=) (signed)
    - Negative Equality(=/=) (signed)
-Implementation Operation: A design choice used for implmentation.
    - MTHI (move the contents of GPR rs to special register Hi)
    - MTLO (move the contents of GPR rs to special register Lo)

 */

logic signed[63:0] SMulRes;//signed result of multiplication.
logic[63:0] UMulRes;//unsigned result of multiplication.
logic[31:0] temp_Hi;
logic[31:0] temp_Lo;

reg [31:0] Hi;
reg [31:0] Lo;

assign ALUHi = Hi;//combinatorial read of Hi register
assign ALULo = Lo;//combinatorial read of Lo register

initial begin
  Hi <= 32'd0;
  Lo <= 32'd0;
end

  always @(*) begin
    case(ALUOp)
      5'd0: begin
          ALURes = $signed(A) + $signed(B);
      end
      
      5'd1: begin
          ALURes = $signed(A) - $signed(B); 
      end        

      5'd2: begin
          SMulRes = $signed(A) * $signed(B);
          temp_Hi   = SMulRes[63:32];
          temp_Lo   = SMulRes[31:0];
      end

      5'd3: begin
          temp_Lo = $signed(A) / $signed(B);
          temp_Hi = $signed(A) % $signed(B);
      end

      5'd4: begin
          ALURes = A & B;
      end

      5'd5: begin
          ALURes = A | B;
      end

      5'd6: begin
          ALURes = A^B;
      end

      5'd7: begin
          ALURes = B << shamt;
      end

      5'd8: begin
          ALURes = B << A;
      end

      5'd9: begin
          ALURes = B >> shamt;
      end

      5'd10: begin
          ALURes = B >> A;
      end

      5'd11: begin
          ALURes = $signed(B) >>> shamt;
      end

      5'd12: begin
          ALURes = $signed(B) >>> A;
      end
   
      5'd13: begin
          if ($signed(A) == $signed(B)) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      5'd14: begin
          if ($signed(A) < $signed(B)) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      5'd15: begin
          if ($signed(A) <= $signed(B)) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      5'd16: begin
          if ($signed(A) > $signed(B)) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      5'd17: begin
          if ($signed(A) >= $signed(B)) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      5'd18: begin
          if ($signed(A) != $signed(B)) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end
/*
      PAS: begin
        ALURes = A;
      end
*/
      5'd20: begin
        if ($signed(A) < $signed(B)) begin
          ALURes = 1;
        end
        else begin
          ALURes = 0;
        end
      end

      5'd21: begin
        if (A < B) begin
          ALURes = 1;
        end
        else begin
          ALURes = 0;
        end
      end

      5'd22: begin
          UMulRes = A * B;
          temp_Hi   = UMulRes[63:32];
          temp_Lo   = UMulRes[31:0];
      end

      5'd23: begin
          temp_Lo = A / B;
          temp_Hi = A % B;
      end

      5'd24: begin
        temp_Hi = Hi_in;
      end

      5'd25: begin
        temp_Lo = Lo_in;
      end
		
		default: begin
		end
    endcase
  end

  always_ff @(posedge clk) begin
    if(rst)begin
      Hi <= 0;
      Lo <= 0;
    end else if (SpcRegWriteEn) begin
      Hi <= temp_Hi;
      Lo <= temp_Lo;
    end
    
  end
endmodule