`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 20:49:05
// Design Name: 
// Module Name: tb_link_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_link_top;
    parameter CLK_PERIOD = 10;
    reg clk, rst;
    wire done;

    link_top dut (.clk(clk), .rst(rst), .done(done));

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("link.vcd");
        $dumpvars(0, tb_link_top);

        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;

        // Wait for the 'done' signal to go high
        wait (done);

        @(posedge clk);
        $display("SUCCESS: 4-byte transfer complete at time %0t ns.", $time);
        $finish;
    end
endmodule
