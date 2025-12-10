module MEM_WB_reg (
    input clk, rst,
    input [31:0] mem_wb_mem_read_data_in, mem_wb_alu_result_in, 
    input [4:0] mem_wb_rd_in,
    input Branch_in3, MemRead_in3, MemtoReg_in3, MemWrite_in3, ALUSrc_in3, RegWrite_in3, LUI_en_in3, AUIPC_en_in3, JAL_en_in3, JALr_en_in3,
    input [1:0] ALUOp_in3, 

    output reg [31:0] mem_wb_mem_read_data_out, mem_wb_alu_result_out,
    output reg[4:0] mem_wb_rd_out,
    output reg Branch_out3, MemRead_out3, MemtoReg_out3, MemWrite_out3, ALUSrc_out3, RegWrite_out3, LUI_en_out3, AUIPC_en_out3, JAL_en_out3, JALr_en_out3,
    output reg [1:0] ALUOp_out3
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            mem_wb_mem_read_data_out <= 32'b00;
            mem_wb_alu_result_out <= 32'b00;
            mem_wb_rd_out <= 32'b00;

            Branch_out3 <= 1'b0;
            MemRead_out3 <= 1'b0;
            MemtoReg_out3 <= 1'b0;
            MemWrite_out3 <= 1'b0;
            ALUSrc_out3 <= 1'b0; 
            RegWrite_out3 <= 1'b0; 
            LUI_en_out3 <= 1'b0; 
            AUIPC_en_out3 <= 1'b0;
            JAL_en_out3 <= 1'b0;
            JALr_en_out3 <= 1'b0;
            ALUOp_out3 <= 2'b0; 
        end else begin
            mem_wb_mem_read_data_out <= mem_wb_mem_read_data_in;
            mem_wb_alu_result_out <= mem_wb_alu_result_in;
            mem_wb_rd_out <= mem_wb_rd_in;

            Branch_out3 <= Branch_in3;
            MemRead_out3 <= MemRead_in3;
            MemtoReg_out3 <= MemtoReg_in3;
            MemWrite_out3 <= MemWrite_in3;
            ALUSrc_out3 <=  ALUSrc_in3;
            RegWrite_out3 <=  RegWrite_in3; 
            LUI_en_out3 <=  LUI_en_in3;
            AUIPC_en_out3 <= AUIPC_en_in3;
            JAL_en_out3 <= JAL_en_in3;
            JALr_en_out3 <= JALr_en_in3;
            ALUOp_out3 <= ALUOp_in3;
        end
    end
    
endmodule

//mem_read_data, alu_result, rd, ctrl_signals