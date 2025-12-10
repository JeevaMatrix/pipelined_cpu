module IF_ID_reg (
    input clk, rst,
    input [31:0] if_id_PC_in, if_id_instruction_in,
    input reg_flush,
    output reg [31:0] if_id_PC_out, if_id_instruction_out
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            if_id_PC_out <= 32'b00;
            if_id_instruction_out <= 32'b00;
        end else if(reg_flush)begin
            if_id_PC_out <= 32'b00;
            if_id_instruction_out <= 32'b00;
        end else begin
            if_id_PC_out <= if_id_PC_in;
            if_id_instruction_out <= if_id_instruction_in;
        end  
    end    
endmodule