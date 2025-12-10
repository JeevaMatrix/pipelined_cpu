`timescale 1ns/1ns
`include "top.v"

module top_tb ();
    
    reg clk, rst;
    integer i;


    top DUT(.clk(clk), .rst(rst));
    
        // initialize memory from hex file at simulation start
    initial begin
        $monitor("pc=%d, x1=%d, x2=%0d, x3=%d, x4=%d, x5=%d, Dmem[0]=%d, x10=%d, x12=%d", 
        DUT.program_counter.PC_out,
        DUT.reg_file.registers[1],
        DUT.reg_file.registers[2],
        DUT.reg_file.registers[3],
        DUT.reg_file.registers[4],
        DUT.reg_file.registers[5],
        DUT.data_mem.D_mem[0],
        DUT.reg_file.registers[10],
        DUT.reg_file.registers[12]
        );

        // clear memory just in case
        for (i = 0; i < 64; i = i + 1)
            DUT.instruction_mem.mem[i] = 32'b0;

        // load your program hex
        $readmemh("../hex/test_file.hex", DUT.instruction_mem.mem);
    end

    initial begin
        clk = 0;
        rst = 1;
        #5
        rst = 0;
    end

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        #1000
        $finish;
    end

    // always @(posedge clk) begin
    //     $display("x10 (a0) = %d", DUT.regFile.registers[10]);
    // end

endmodule