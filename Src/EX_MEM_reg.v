module EX_MEM_reg (
    input clk, rst,
    input [31:0] ex_mem_ALU_out_in, ex_mem_rs2_in, branch_calc_out_in,
    input [4:0]ex_mem_rd_in,
    input zero_in1, Branch_in2, MemRead_in2, MemtoReg_in2, MemWrite_in2, ALUSrc_in2, RegWrite_in2, LUI_en_in2, AUIPC_en_in2, JAL_en_in2, JALr_en_in2,
    input [1:0] ALUOp_in2, 

    output reg[31:0] ex_mem_ALU_out_out, ex_mem_rs2_out, branch_calc_out_out,
    output reg[4:0]ex_mem_rd_out,
    output reg zero_out1, Branch_out2, MemRead_out2, MemtoReg_out2, MemWrite_out2, ALUSrc_out2, RegWrite_out2, LUI_en_out2, AUIPC_en_out2, JAL_en_out2, JALr_en_out2,
    output reg [1:0] ALUOp_out2
);

   always @(posedge clk or posedge rst) begin
        if(rst) begin
            ex_mem_ALU_out_out <= 32'b00;
            ex_mem_rs2_out <= 32'b00;
            ex_mem_rd_out <= 5'b00;
            branch_calc_out_out <= 32'b00;
            zero_out1 <= 1'b0;

            Branch_out2 <= 1'b0;
            MemRead_out2 <= 1'b0;
            MemtoReg_out2 <= 1'b0;
            MemWrite_out2 <= 1'b0;
            ALUSrc_out2 <= 1'b0; 
            RegWrite_out2 <= 1'b0; 
            LUI_en_out2 <= 1'b0; 
            AUIPC_en_out2 <= 1'b0;
            JAL_en_out2 <= 1'b0;
            JALr_en_out2 <= 1'b0;
            ALUOp_out2 <= 2'b0; 
        end else begin
            ex_mem_ALU_out_out <= ex_mem_ALU_out_in;
            ex_mem_rs2_out <= ex_mem_rs2_in;
            ex_mem_rd_out <= ex_mem_rd_in;
            branch_calc_out_out <= branch_calc_out_in;
            zero_out1 <= zero_in1;

            Branch_out2 <= Branch_in2;
            MemRead_out2 <= MemRead_in2;
            MemtoReg_out2 <= MemtoReg_in2;
            MemWrite_out2 <= MemWrite_in2;
            ALUSrc_out2 <=  ALUSrc_in2;
            RegWrite_out2 <=  RegWrite_in2; 
            LUI_en_out2 <=  LUI_en_in2;
            AUIPC_en_out2 <= AUIPC_en_in2;
            JAL_en_out2 <= JAL_en_in2;
            JALr_en_out2 <= JALr_en_in2;
            ALUOp_out2 <= ALUOp_in2;
        end  
    end
endmodule

//alu_result, rs2_val, rd, ctrl_signals