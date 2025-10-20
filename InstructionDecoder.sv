typedef struct packed {
  bit [6:0] funct7;
  bit [4:0] rs2;
  bit [4:0] rs1;
  bit [2:0] funct3;
  bit [4:0] rd;
  bit [6:0] opcode;
} R_Type_Instruction;

typedef struct packed {
  bit [11:0] imm;
  bit [4:0] rs1;
  bit [2:0] funct3;
  bit [4:0] rd;
  bit [6:0] opcode;
} I_Type_Instruction;

typedef enum {rType, iType} typeDecision;

typedef union packed {
  R_Type_Instruction R_Format;
  I_Type_Instruction I_Format;
} DecodedInstruction;

class InfoDecoder;
  DecodedInstruction field;
  typeDecision answer;

  function new ();
    this.field = 1'b0;
    this.answer = rType;
  endfunction

  function void decode (input bit [31:0] userInputInstruction);
    if(userInputInstruction[6:0] == 7'b0110011) begin
      this.field.R_Format = userInputInstruction;
      this.answer = rType;
    end
    else begin
      this.field.I_Format = userInputInstruction;
      this.answer = iType;
    end
  endfunction

  function getType ();
    return this.answer;
  endfunction
endclass

interface userInstruction (logic [31:0] RV32I_data); // net type must be 4-state
  bit [11:0] imm_inst; //only used if I-Format
  bit [6:0] funct7_inst; // only used if R-Format
  bit [4:0] rs2_inst; // only used if R-Format
  bit [4:0] rs1_inst;
  bit [2:0] funct3_inst;
  bit [4:0] rd_inst;
  bit [6:0] opcode_inst;

  modport TB (
    input imm_inst, funct7_inst, rs2_inst, rs1_inst, funct3_inst, rd_inst, opcode_inst,
    output RV32I_data
    );

  modport DUT (
    output imm_inst, funct7_inst, rs2_inst, rs1_inst, funct3_inst, rd_inst, opcode_inst, 
    input RV32I_data
    );
endinterface


module InstructionDecoder(
  userInstruction.DUT instruction1,
  userInstruction.DUT instruction2
);

  InfoDecoder decoder1;
  InfoDecoder decoder2;

  initial begin
    decoder1 = new();
    decoder2 = new();
  end

  always_comb begin
    decoder1.decode(instruction1.RV32I_data);
    decoder2.decode(instruction2.RV32I_data);

    instruction1.opcode_inst = decoder1.field.R_Format.opcode;
    instruction1.rd_inst = decoder1.field.R_Format.rd;
    instruction1.funct3_inst = decoder1.field.R_Format.funct3;
    instruction1.rs1_inst = decoder1.field.R_Format.rs1;
    if(decoder1.answer == rType) begin
      instruction1.rs2_inst = decoder1.field.R_Format.rs2;
      instruction1.funct7_inst = decoder1.field.R_Format.funct7;
    end else 
      instruction1.imm_inst = decoder1.field.I_Format.imm;

    instruction2.opcode_inst = decoder2.field.R_Format.opcode;
    instruction2.rd_inst = decoder2.field.R_Format.rd;
    instruction2.funct3_inst = decoder2.field.R_Format.funct3;
    instruction2.rs1_inst = decoder2.field.R_Format.rs1;
    if(decoder2.answer == rType) begin
      instruction2.rs2_inst = decoder2.field.R_Format.rs2;
      instruction2.funct7_inst = decoder2.field.R_Format.funct7;
    end else 
      instruction2.imm_inst = decoder2.field.I_Format.imm;
  end

endmodule 
