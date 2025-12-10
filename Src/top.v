//IF stage
`include "program_counter.v"
`include "instruction_mem.v"
`include "PC_inc.v"
`include "PC_mux.v"

//IF_ID
`include "IF_ID_reg.v"

//ID stage
`include "inst_parser.v"
`include "reg_file.v"
`include "imm_gen.v"
`include "control_unit.v"

//ID_EX
`include "ID_EX_reg.v"

//EX stage
`include "ALU.v"
`include "ALU_control.v"
`include "branch_calc_adder.v"
`include "mux_a.v"
`include "mux_b.v"
`include "mux_b1.v"
`include "forwarding_unit.v"

//EX_MEM
`include "EX_MEM_reg.v"
`include "jal_mux.v"
`include "mux_control.v"

//MEM stage
`include "data_mem.v"
`include "gatelogic.v"

//MEM_WB
`include "MEM_WB_reg.v"

//WB stage
`include "mux_wb.v"



module top (
    input clk, rst
);

    //IF
    wire [31:0] pc_mux_out, PC_top, instruction_top, PC_inc_out;
    wire [31:0] if_id_PC_out, if_id_instruction_out;

    //ID
    wire [4:0] r1_top, r2_top, rd_top, id_ex_r1_out, id_ex_r2_out, id_ex_rd_out;
    wire [31:0] read_data_1_top, read_data_2_top, ImmExt_top;
    wire [6:0] opcode_top;
    wire [2:0] fun3_top;
    wire fun7_top;
    wire Branch_top, MemRead_top, MemtoReg_top, MemWrite_top, ALUSrc_top, RegWrite_top, LUI_en_top, AUIPC_en_top, JAL_en_top, JALr_en_top;
    wire [1:0] ALUOp_top;
    wire [31:0] id_ex_PC_out, id_ex_imm_out, id_ex_rs1_out, id_ex_rs2_out;
    wire Branch_out1, MemRead_out1, MemtoReg_out1, MemWrite_out1, ALUSrc_out1, RegWrite_out1, LUI_en_out1, AUIPC_en_out1, JAL_en_out1, JALr_en_out1;
    wire [1:0] ALUOp_out1;
    wire [2:0] fun3_out;
    wire fun7_out;

    //EX
    wire [4:0]ex_mem_rd_out;
    wire [3:0] control_out_top;
    wire zero_top;
    wire [31:0] ALU_result, ALU_out_top, branch_cal_adder_out_top, muxa_out_top, muxb_out_top, muxb1_out_top;
    wire [31:0]ex_mem_ALU_out_out, ex_mem_rs2_out, branch_calc_out_out;
    wire zero_out1, Branch_out2, MemRead_out2, MemtoReg_out2, MemWrite_out2, ALUSrc_out2, RegWrite_out2, LUI_en_out2, AUIPC_en_out2, JAL_en_out2, JALr_en_out2;
    wire [1:0]ALUOp_out2, forwardA, forwardB;
    
    //MEM
    wire [4:0]mem_wb_rd_out;
    wire [31:0] read_data_top;
    wire and_out_top, flush_top;
    wire [31:0] mem_wb_mem_read_data_out, mem_wb_alu_result_out;
    wire Branch_out3, MemRead_out3, MemtoReg_out3, MemWrite_out3, ALUSrc_out3, RegWrite_out3, LUI_en_out3, AUIPC_en_out3, JAL_en_out3, JALr_en_out3;
    wire [1:0] ALUOp_out3;
    wire [1:0]pc_mux_ctrl;

    //WB
    wire [31:0] muxwb_out_top;


    //-------------------IF stage-------------------//
    //Program_counter
    program_counter program_counter(
         .clk(clk), .rst(rst),
         .PC_in(pc_mux_out),
         .PC_out(PC_top)
    );

    //instruction_mem
    instruction_mem instruction_mem(
         .clk(clk), .rst(rst),
          .read_address(PC_top),
          .instruction_out(instruction_top) 
    );

    //PC_inc
    PC_inc PC_inc(
          .fromPC(PC_top),
          .toPC(PC_inc_out)
    );

    //PC_mux
    PC_mux PC_mux(
         .sel(pc_mux_ctrl),
          .A(PC_inc_out), .B(branch_calc_out_out), .C(ALU_result),
          .mux_out(pc_mux_out)
    );

    //-------------------------------------------------//

    //IF_ID_reg
    IF_ID_reg IF_ID_reg(
        .clk(clk), .rst(rst),
        .if_id_PC_in(PC_top), .if_id_instruction_in(instruction_top), .reg_flush(flush_top),
        .if_id_PC_out(if_id_PC_out), .if_id_instruction_out(if_id_instruction_out)
    );


    //------------------ID stage---------------------//
    //inst_parser
    inst_parser inst_parser(
        .instruction(if_id_instruction_out),
        .r1(r1_top), .r2(r2_top), .rd(rd_top),
        .opcode(opcode_top),
        .fun3(fun3_top),
        .fun7(fun7_top)
    );

    //reg_file
    reg_file reg_file(
        .clk(clk), .rst(rst), .reg_write(RegWrite_out3),        //using regwrite from 4th reg
        .rs1(r1_top), .rs2(r2_top), .rd(mem_wb_rd_out),
        .write_data(muxwb_out_top), 
        .read_data_1(read_data_1_top), .read_data_2(read_data_2_top)
    );

    //control_unit
    control_unit control_unit(
        .opcode(opcode_top),
        .Branch(Branch_top), .MemRead(MemRead_top), .MemtoReg(MemtoReg_top), .MemWrite(MemWrite_top), .ALUSrc(ALUSrc_top), .RegWrite(RegWrite_top), .LUI_en(LUI_en_top), .AUIPC_en(AUIPC_en_top), .JAL_en(JAL_en_top), .JALr_en(JALr_en_top),
        .ALUOp(ALUOp_top)
    );


    //imm_gen
    ImmGen ImmGen(
        .opcode(opcode_top),
        .instruction(if_id_instruction_out),
        .ImmExt(ImmExt_top)
    );


    //-------------------------------------------------//

    //ID_EX_reg
    ID_EX_reg ID_EX_reg(
        .clk(clk), .rst(rst),
          .id_ex_PC_in(if_id_PC_out), .id_ex_imm_in(ImmExt_top), .id_ex_rs1_in(read_data_1_top), .id_ex_rs2_in(read_data_2_top), .id_ex_r1_in(r1_top), .id_ex_r2_in(r2_top), .id_ex_rd_in(rd_top),
         .Branch_in1(Branch_top), .MemRead_in1(MemRead_top), .MemtoReg_in1(MemtoReg_top), .MemWrite_in1(MemWrite_top), .ALUSrc_in1(ALUSrc_top), .RegWrite_in1(RegWrite_top), .LUI_en_in1(LUI_en_top), .AUIPC_en_in1(AUIPC_en_top), .JAL_en_in1(JAL_en_top), .JALr_en_in1(JALr_en_top),
         .fun7_in(fun7_top),
        .ALUOp_in1(ALUOp_top), .fun3_in(fun3_top), .flush(flush_top),

          .id_ex_PC_out(id_ex_PC_out), .id_ex_imm_out(id_ex_imm_out), .id_ex_rs1_out(id_ex_rs1_out), .id_ex_rs2_out(id_ex_rs2_out), .id_ex_r1_out(id_ex_r1_out), .id_ex_r2_out(id_ex_r2_out), .id_ex_rd_out(id_ex_rd_out),
         .Branch_out1(Branch_out1), .MemRead_out1(MemRead_out1), .MemtoReg_out1(MemtoReg_out1), .MemWrite_out1(MemWrite_out1), .ALUSrc_out1(ALUSrc_out1), .RegWrite_out1(RegWrite_out1), .LUI_en_out1(LUI_en_out1), .AUIPC_en_out1(AUIPC_en_out1), .JAL_en_out1(JAL_en_out1), .JALr_en_out1(JALr_en_out1),
         .fun7_out(fun7_out),
         .ALUOp_out1(ALUOp_out1), .fun3_out(fun3_out)
    );


    //------------------EX stage-----------------------//
    //ALU_control
    ALU_control ALU_control(
        .ALUOp(ALUOp_out1),
        .fun7(fun7_out),
        .fun3(fun3_out),
        .control_out(control_out_top)
    );

    //ALU
    ALU ALU(
        .A(muxa_out_top), .B(muxb1_out_top),
        .control_in(control_out_top),
        .zero(zero_top),
        .ALU_out(ALU_out_top)
    );

    mux_control mux_control(
        .LUI_en(LUI_en_out1), .AUIPC_en(AUIPC_en_out1), .JAL_en(JAL_en_out1), .JALr_en(JALr_en_out1),
        .rs1(muxa_out_top), .pc(id_ex_PC_out), .imm(id_ex_imm_out) ,.mc_ALU_in(ALU_out_top),
        .ALU_result(ALU_result)
    );


    //branch_calc_adder
    branch_calc_adder branch_calc_adder(
        .a(id_ex_PC_out), .b(id_ex_imm_out),
        .c(branch_cal_adder_out_top)
    );

    //muxa
    mux_a mux_a(
        .sel(forwardA),
        .A(id_ex_rs1_out), .B(muxwb_out_top), .C(ex_mem_ALU_out_out),
        .mux_out(muxa_out_top)
    );

    //00 - rs1
    //01 - write-back
    //10 - alu-result

    //muxb
    mux_b mux_b(
        .sel(forwardB),
        .A(id_ex_rs2_out), .B(muxwb_out_top), .C(ex_mem_ALU_out_out),
        .mux_out(muxb_out_top)
    );


    //muxb1
    mux_b1 mux_b1(
        .sel(ALUSrc_out1),
        .A(muxb_out_top), .B(id_ex_imm_out),
        .mux_out(muxb1_out_top)
    );

    forwarding_unit forwarding_unit(
        .r1(id_ex_r1_out), .r2(id_ex_r2_out),
        .ex_mem_rd(ex_mem_rd_out), .mem_wb_rd(mem_wb_rd_out),
        .ex_mem_reg_write(RegWrite_out2), .mem_wb_reg_write(RegWrite_out3),

        .forwardA(forwardA), .forwardB(forwardB)
    );

    //gatelogic
    gatelogic gatelogic(
        .Branch(Branch_out1), .zero(zero_top),
        .and_out(and_out_top)
    );
    //and gate is inside the ex stage

    //-------------------------------------------------//

    //EX_MEM_reg
    EX_MEM_reg EX_MEM_reg(
        .clk(clk), .rst(rst),
            .ex_mem_ALU_out_in(ALU_result), .ex_mem_rs2_in(muxb_out_top), .ex_mem_rd_in(id_ex_rd_out), .branch_calc_out_in(branch_cal_adder_out_top),
            .zero_in1(zero_top), .Branch_in2(Branch_out1), .MemRead_in2(MemRead_out1), .MemtoReg_in2(MemtoReg_out1), .MemWrite_in2(MemWrite_out1), .ALUSrc_in2(ALUSrc_out1), .RegWrite_in2(RegWrite_out1), .LUI_en_in2(LUI_en_out1), .AUIPC_en_in2(AUIPC_en_out1), .JAL_en_in2(JAL_en_out1), .JALr_en_in2(JALr_en_out1),
            .ALUOp_in2(ALUOp_out1), 

            .ex_mem_ALU_out_out(ex_mem_ALU_out_out), .ex_mem_rs2_out(ex_mem_rs2_out), .ex_mem_rd_out(ex_mem_rd_out), .branch_calc_out_out(branch_calc_out_out),
            .zero_out1(zero_out1), .Branch_out2(Branch_out2), .MemRead_out2(MemRead_out2), .MemtoReg_out2(MemtoReg_out2), .MemWrite_out2(MemWrite_out2), .ALUSrc_out2(ALUSrc_out2), .RegWrite_out2(RegWrite_out2), .LUI_en_out2(LUI_en_out2), .AUIPC_en_out2(AUIPC_en_out2), .JAL_en_out2(JAL_en_out2), .JALr_en_out2(JALr_en_out2),
            .ALUOp_out2(ALUOp_out2) 
    );

    //-------------------MEM stage----------------------//
    //data_mem
    data_mem data_mem(
        .clk(clk), .rst(rst), .MemRead(MemRead_out2), .MemWrite(MemWrite_out2),
        .address(ex_mem_ALU_out_out),
        .write_data(ex_mem_rs2_out),
        .read_data(read_data_top)
    );



    jal_mux jal_mux(
        .JAL_en(JAL_en_out1), .JALr_en(JALr_en_out1),
        .branch(and_out_top),
        .pc_mux_ctrl(pc_mux_ctrl),
        .flush(flush_top)
    );

    //-------------------------------------------------//

    //MEM_WB_reg
    MEM_WB_reg MEM_WB_reg(
        .clk(clk), .rst(rst),
        .mem_wb_mem_read_data_in(read_data_top), .mem_wb_alu_result_in(ex_mem_ALU_out_out), .mem_wb_rd_in(ex_mem_rd_out),
        .Branch_in3(Branch_out2), .MemRead_in3(MemRead_out2), .MemtoReg_in3(MemtoReg_out2), .MemWrite_in3(MemWrite_out2), .ALUSrc_in3(ALUSrc_out2), .RegWrite_in3(RegWrite_out2), .LUI_en_in3(LUI_en_out2), .AUIPC_en_in3(AUIPC_en_out2), .JAL_en_in3(JAL_en_out2), .JALr_en_in3(JALr_en_out2),
        .ALUOp_in3(ALUOp_out2), 

        .mem_wb_mem_read_data_out(mem_wb_mem_read_data_out), .mem_wb_alu_result_out(mem_wb_alu_result_out), .mem_wb_rd_out(mem_wb_rd_out),
        .Branch_out3(Branch_out3), .MemRead_out3(MemRead_out3), .MemtoReg_out3(MemtoReg_out3), .MemWrite_out3(MemWrite_out3), .ALUSrc_out3(ALUSrc_out3), .RegWrite_out3(RegWrite_out3), .LUI_en_out3(LUI_en_out3), .AUIPC_en_out3(AUIPC_en_out3), .JAL_en_out3(JAL_en_out3), .JALr_en_out3(JALr_en_out3),
        .ALUOp_out3(ALUOp_out3)
    );


    //--------------------WB stage----------------------//
    //muxwb
    mux_wb mux_wb(
        .sel(MemtoReg_out3),
        .A(mem_wb_alu_result_out), .B(mem_wb_mem_read_data_out),
        .mux_out(muxwb_out_top)
    );

endmodule