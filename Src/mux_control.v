module mux_control (
    input LUI_en, AUIPC_en, JAL_en, JALr_en,
    input [31:0]rs1, 
    input [31:0]pc, 
    input [31:0]imm, 
    input [31:0]mc_ALU_in,
    output [31:0] ALU_result
);

    assign ALU_result = (LUI_en) ? imm :
    (AUIPC_en) ? (pc + imm) :
    (JAL_en) ? (pc + imm) :
    (JALr_en) ? (rs1 + imm) :
    mc_ALU_in;
    
endmodule