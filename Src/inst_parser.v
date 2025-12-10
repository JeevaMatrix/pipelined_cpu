module inst_parser (
    input [31:0] instruction,
    output [4:0] r1, r2, rd,
    output [6:0] opcode,
    output [2:0] fun3,
    output fun7
);

    assign r1 = instruction[19:15];
    assign r2 = instruction[24:20];
    assign rd = instruction[11:7];
    assign opcode = instruction[6:0];

    assign fun3 = instruction[14:12];
    assign fun7 = instruction[30];
endmodule

//        .rs1(instruction_top[19:15]), .rs2(instruction_top[24:20]), .rd(instruction_top[11:7]),
//        .fun7(instruction_top[30]),
//        .fun3(instruction_top[14:12]),