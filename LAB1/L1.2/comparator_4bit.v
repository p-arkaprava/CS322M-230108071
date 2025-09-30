module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output equal
);
    assign equal = (A == B);
endmodule
