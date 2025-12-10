module jal_mux (
    input JAL_en, JALr_en,
    input branch,
    output reg [1:0] pc_mux_ctrl,
    output reg flush
);

    always @(*) begin
        if (branch) begin
            pc_mux_ctrl = 2'b01;
            flush = 1'b1;
        end 
        else if (JAL_en | JALr_en) begin
            pc_mux_ctrl = 2'b10;
            flush = 1'b1;
        end 
        else begin
            pc_mux_ctrl = 2'b00;
            flush = 1'b0;
        end
    end

endmodule
