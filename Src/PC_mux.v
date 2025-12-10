module PC_mux (
    input [1:0]sel,
    input [31:0] A, B, C,
    output [31:0] mux_out
);

    assign mux_out = (sel==2'b00) ? A: (sel==2'b01)? B: C;
    
endmodule