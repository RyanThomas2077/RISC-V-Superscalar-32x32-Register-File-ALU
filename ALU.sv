module ALU (
  input bit [4:0] ALUop,
  input bit [31:0] rs1,
  input bit [31:0] rs2,
  output logic [31:0] rd,
  output bit carryOut
);

  wire [32:0] temp;
  assign temp = {1'b0, rs1} + {1'b0, rs2};
  assign carryOut = temp[32];

  always_comb begin
    case(ALUop)
    5'b0: rd = rs1 + rs2;
    5'b1: rd = rs1 - rs2;
    5'b10: rd = rs1 ^ rs2;
    5'b11: rd = rs1 | rs2;
    5'b100: rd = rs1 & rs2;
    5'b101: rd = rs1 << rs2;
    5'b110: rd = rs1 >> rs2;
    5'b111: rd = rs1 >>> rs2;
    5'b1000: rd = (rs1 < rs2) ? 1 : 0; // signed 
    5'b1001: rd = (rs1 < rs2) ? 1 : 0; // unsigned
    // I-Type
    5'b1010: rd = rs1 + imm;
    5'b1011: rd = rs1 ^ imm;
    5'b1100: rd = rs1 | imm;
    5'b1101: rd = rs1 & imm;
    5'b1110: rd = rs1 << imm[4:0];
    5'b1111: rd = rs1 >> imm[4:0];
    5'b10000: rd = rs1 >>> imm[4:0];
    5'b10001: rd = (rs1 < imm) ? 1 : 0;
    5'b10010: rd = (rs1 > imm) ? 1 : 0; // signed
    5'b10011: rd = (rs1 > imm) ? 1 : 0; // unsigned
    default: rd = {32{1'bz}};
    endcase
  end

endmodule
