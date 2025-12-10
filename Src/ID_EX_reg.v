module ID_EX_reg (
    input clk, rst,
    input [31:0] id_ex_PC_in, id_ex_imm_in, id_ex_rs1_in, id_ex_rs2_in,
    input [4:0] id_ex_r1_in, id_ex_r2_in, id_ex_rd_in,
    input Branch_in1, MemRead_in1, MemtoReg_in1, MemWrite_in1, ALUSrc_in1, RegWrite_in1, LUI_en_in1, AUIPC_en_in1, JAL_en_in1, JALr_en_in1, fun7_in,
    input [1:0] ALUOp_in1,
    input [2:0] fun3_in,
    input flush,

    output reg [31:0] id_ex_PC_out, id_ex_imm_out, id_ex_rs1_out, id_ex_rs2_out,
    output reg [4:0] id_ex_r1_out, id_ex_r2_out, id_ex_rd_out,
    output reg Branch_out1, MemRead_out1, MemtoReg_out1, MemWrite_out1, ALUSrc_out1, RegWrite_out1, LUI_en_out1, AUIPC_en_out1, JAL_en_out1, JALr_en_out1, fun7_out,
    output reg [1:0] ALUOp_out1, 
    output reg [2:0] fun3_out
);

    always @(posedge clk or posedge rst) begin
        if(rst | flush) begin
            id_ex_PC_out <= 32'b00;
            id_ex_imm_out <= 32'b00;
            id_ex_rs1_out <= 32'b00;
            id_ex_rs2_out <= 32'b00;
            id_ex_rd_out <= 5'b00;
            id_ex_r1_out <= 5'b00;
            id_ex_r2_out <= 5'b00;

            Branch_out1 <= 1'b0;
            MemRead_out1 <= 1'b0;
            MemtoReg_out1 <= 1'b0;
            MemWrite_out1 <= 1'b0;
            ALUSrc_out1 <= 1'b0; 
            RegWrite_out1 <= 1'b0; 
            LUI_en_out1 <= 1'b0; 
            AUIPC_en_out1 <= 1'b0;
            JAL_en_out1 <= 1'b0;
            JALr_en_out1 <= 1'b0;
            fun7_out <= 1'b0;
            ALUOp_out1 <= 2'b0;
            fun3_out <= 3'b00; 
        end else begin
            id_ex_PC_out <= id_ex_PC_in;
            id_ex_imm_out <= id_ex_imm_in;
            id_ex_rs1_out <= id_ex_rs1_in;
            id_ex_rs2_out <= id_ex_rs2_in;
            id_ex_rd_out <= id_ex_rd_in;
            id_ex_r1_out <= id_ex_r1_in;
            id_ex_r2_out <= id_ex_r2_in;

            Branch_out1 <= Branch_in1;
            MemRead_out1 <= MemRead_in1;
            MemtoReg_out1 <= MemtoReg_in1;
            MemWrite_out1 <= MemWrite_in1;
            ALUSrc_out1 <=  ALUSrc_in1;
            RegWrite_out1 <=  RegWrite_in1; 
            LUI_en_out1 <=  LUI_en_in1;
            AUIPC_en_out1 <= AUIPC_en_in1;
            JAL_en_out1 <= JAL_en_in1;
            JALr_en_out1 <= JALr_en_in1;
            fun7_out <= fun7_in;
            ALUOp_out1 <= ALUOp_in1;
            fun3_out <= fun3_in; 
        end  
    end    
endmodule

//pc, imm, rs1_val, rs2_val, rd, ctrl_signals