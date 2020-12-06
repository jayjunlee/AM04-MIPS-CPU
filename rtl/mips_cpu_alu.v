module mips_cpu_alu(
    input logic signed[31:0] A, //Bus A - Input from the Readdata1 output from the reg file which corresponds to rs. 
    input logic signed[31:0] B, //Bus B - Input from the Readdata2 output from the reg file which corresponds to rt.
    input logic[4:0] ALUOp, // 5-bit output from Control that tells the alu what operation to do from a list of 20 distinct alu operations(see below).
    input logic[4:0] shamt, //5-bit input used to specify shift amount for shift operations. Taken directly from the R-type instruction (Non-Variable) or from 

    output logic ALUCond, //If a relevant condition is met, this output goes high(Active High). Note: Relevant as in related to current condition being tested.
    output logic signed[31:0] ALURes // The ouput of the ALU 
);

/*  

Alu Operations:
-Manipulation Operations: The perform an operation on a value(s).
    - Addition
    - Subtraction
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
-Condtional Check Operations: They check conditions.
    - Equality (=)
    - Less Than (<)
    - Less Than or Equal To (<=)
    - Greater Than (>)
    - Greater Than or Equal to (>=)
    - Negative Equality(=/=)
-Implementation Operation:
    - Pass-through (Used to implement MTHI and MTLO, as these instructions do not need the ALU but the alu is in the pathway to the regfile, so the register value simply passes through.)

 */

  typedef enum logic [4:0]{ //Enum list to use words instead of numbers when refering to operations.

      ADD  = 5'd0,
      SUB  = 5'd1,
      MUL  = 5'd2,
      DIV  = 5'd3,
      AND  = 5'd4,
      OR   = 5'd5,
      XOR  = 5'd6,
      SLL  = 5'd7,
      SLLV = 5'd8,
      SRL  = 5'd9,
      SRLV = 5'd10,
      SRA  = 5'd11,
      SRAV = 5'd12,
      EQ   = 5'd13,
      LES  = 5'd14,
      LEQ  = 5'd15,
      GRT  = 5'd16,
      GEQ  = 5'd17,
      NEQ  = 5'd18,
      PAS  = 5'd19

  } Ops;

Ops ALUOps; //Note confusing naming to avoid potential duplicate variable naming errors, as a result of enum implemetnation quirks.

assign ALUOps = ALUOp;

  always_comb begin



    case(ALUOps)
      ADD: begin
          ALURes = A + B;
      end
      
      SUB: begin
          ALURes = A - B; 
      end        

      MUL: begin
          ALURes = A * B; 
      end

      DIV: begin
          ALURes = A / B;
      end

      AND: begin
          ALURes = A & B;
      end

      OR: begin
          ALURes = A | B;
      end

      XOR: begin
          ALURes = A^B;
      end

      SLL: begin
          ALURes = B << shamt;
      end

      SLLV: begin
          ALURes = B << A;
      end

      SRL: begin
          ALURes = B >> shamt;
      end

      SRLV: begin
          ALURes = B >> A;
      end

      SRA: begin
          ALURes = B >>> shamt;
      end

      SRAV: begin
          ALURes = B >>> A;
      end
   
      EQ: begin
          if (A == B) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      LES: begin
          if (A < B) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      LEQ: begin
          if (A <= B) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      GRT: begin
          if (A > B) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      GEQ: begin
          if (A >= B) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      NEQ: begin
          if (A != B) begin
            ALUCond = 1;
          end
          else begin
            ALUCond = 0;
          end
          
      end

      PAS: begin
        ALURes = A;
      end

    endcase
  end
endmodule