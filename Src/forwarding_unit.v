module forwarding_unit (
    input [4:0] r1, r2,
    input [4:0] ex_mem_rd, mem_wb_rd,
    input ex_mem_reg_write, mem_wb_reg_write,

    output reg [1:0] forwardA, forwardB
);

    always @(*) begin
        // Default: no forwarding
        forwardA = 2'b00;
        forwardB = 2'b00;

        // ForwardA
        if (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == r1))
            forwardA = 2'b10;
        else if (mem_wb_reg_write && (mem_wb_rd != 0) && (mem_wb_rd == r1))
            forwardA = 2'b01;

        // ForwardB
        if (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == r2))
            forwardB = 2'b10;
        else if (mem_wb_reg_write && (mem_wb_rd != 0) && (mem_wb_rd == r2))
            forwardB = 2'b01;
    end
    
endmodule