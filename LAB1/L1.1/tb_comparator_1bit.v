`timescale 1ns/1ps
module tb_comparator_1bit;
    reg A, B;
    wire o1, o2, o3;

    comparator_1bit uut(.A(A), .B(B), .o1(o1), .o2(o2), .o3(o3));

    initial begin
        $dumpfile("comparator_1bit.vcd");
        $dumpvars(0, tb_comparator_1bit);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end
endmodule
