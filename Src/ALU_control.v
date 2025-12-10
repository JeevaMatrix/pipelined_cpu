//takes the control unit output ALUOp and instruction func7 and func3
//to generate the function opcode for ALU
//we only use 30th bit in func7 as other wont change in ISA spec

// module ALU_control (
//     input [1:0]ALUOp,
//     input fun7,
//     input [2:0]fun3,
//     output reg[3:0]control_out
// );

//     always @(*) begin
//         case({ALUOp, fun7, fun3})
//             6'b00_0_000: control_out <= 4'b0010;    //LOAD or STORE
//             6'b01_0_000: control_out <= 4'b0110;    //BEQ - (Subtract)branch if equal
//             6'b10_0_000: control_out <= 4'b0010;    //ADD
//             6'b10_1_000: control_out <= 4'b0110;    //SUB
//             6'b10_0_111: control_out <= 4'b0000;    //AND
//             6'b10_0_110: control_out <= 4'b0001;    //OR
//         endcase
//     end
    
// endmodule

module ALU_control (
    input [1:0] ALUOp,
    input fun7,
    input [2:0] fun3,
    output reg [3:0] control_out
);

always @(*) begin
    case (ALUOp)

        2'b00:  control_out = 4'b0010;  // LOAD/STORE = ADD

        2'b01:  control_out = 4'b0110;  // BRANCH = SUB

        2'b10: begin                   // R-type
            case ({fun7, fun3})
                4'b0_000: control_out = 4'b0010; // ADD
                4'b1_000: control_out = 4'b0110; // SUB
                4'b0_111: control_out = 4'b0000; // AND
                4'b0_110: control_out = 4'b0001; // OR
                default:  control_out = 4'b0010;
            endcase
        end

        2'b11: begin                   // I-type ALU
            case (fun3)
                3'b000: control_out = 4'b0010; // ADDI → ADD
                3'b111: control_out = 4'b0000; // ANDI
                3'b110: control_out = 4'b0001; // ORI
                // add more if you support SLTI, XORI, etc.
                default: control_out = 4'b0010;
            endcase
        end

    endcase
end

endmodule
