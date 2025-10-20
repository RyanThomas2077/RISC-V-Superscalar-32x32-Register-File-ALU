`define ADD 0
`define SUB 1
`define XOR 10
`define OR 11
`define AND 100
`define SLL 101
`define SRL 110
`define SRA 111
`define SLT 1000
`define SLTU 1001
// 
`define ADDI 1010
`define XORI 1011
`define ORI 1100
`define ANDI 1101
`define SLLI 1110
`define SRLI 1111
`define SRAI 10000
`define SLTI 10001
`define SLTIU 10010
//
`define UNUSED_FIELD 11110
`define INVALID_INSTRUCTION 11111

module ControlUnit (
  input userInstruction.DUT Instruction,
  output bit [4:0] ALUop,
  output bit WriteEn,
  output bit [4:0] ReadReg1, ReadReg2, WriteReg,
  output bit ReadBank1, ReadBank2, WriteBank,
  output bit [31:0] WriteData
);

  assign WriteReg = Instruction.rd_inst;
  assign ReadReg1 = Instruction.rs1_inst;
  assign ReadBank1 = ReadReg1[0];
  assign ReadBank2 = ReadReg2[0];
  assign WriteBank = WriteReg[0];


  always_comb begin
    WriteEn = 1'b0;
    ALUop = 5'b0;

    case(Instruction.opcode_inst) begin
      7'b0110011: begin
	WriteEn = 1'b1;
	ReadReg2 = Instruction.rs2_inst;
	case({Instruction.funct7_inst, Instruction.funct3_inst})
	  10'b0000000_000: ALUop = ADD;  
	  10'b0100000_000: ALUop = SUB;
	  10'b0000000_100: ALUop = XOR;
	  10'b0000000_110: ALUop = OR;
	  10'b0000000_111: ALUop = AND;
	  10'b0000000_001: ALUop = SLL;
	  10'b0000000_101: ALUop = SRL;
	  10'b0100000_101: ALUop = SRA;
	  10'b0000000_010: ALUop = SLT;
	  10'b0000000_011: ALUop = SLTU;
	  default: ALUop = INVALID_INSTRUCTION;
	endcase
      end
      7'b0010011: begin
	WriteEn = 1'b1;
	ReadReg2 = 1'b0; // unused
	casez({Instruction.imm_inst[11:5], Instruction.funct3_inst})
	  10'b???????_000: ALUop = ADDI;
	  10'b???????_100: ALUop = XORI;
	  10'b???????_110: ALUop = ORI;
	  10'b???????_111: ALUop = ANDI;
	  10'b0000000_001: ALUop = SLLI;
	  10'b0000000_101: ALUop = SRLI;
	  10'b0100000_101: ALUop = SRAI;
	  10'b???????_010: ALUop = SLTI;
	  10'b???????_011: ALUop = SLTIU;
	  default: ALUop = INVALID_INSTRUCTION;
	endcase
      end
      default: begin
        WriteEn = 1'b0;
	ALUop = INVALID_INSTRUCTION;
      end
      endcase 
  end

endmodule : ControlUnit
