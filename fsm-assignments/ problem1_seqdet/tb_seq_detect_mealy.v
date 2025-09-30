`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2025 13:18:18
// Design Name: 
// Module Name: tb_seq_detect_mealy
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




module tb_seq_detect_mealy;

    reg clk;
    reg rst;
    reg din;
    wire y;

    // Instantiate DUT
    seq_detect_mealy dut (
        .din(din),
        .clk(clk),
        .rst(rst),
        .y(y)
    );

    // Clock generator: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Waveform dump (Vivado saves automatically, but for VCD use $dumpfile if supported)
        $dumpfile("seq_detect_mealy.vcd");
        $dumpvars(0, tb_seq_detect_mealy);

        // Reset
        rst = 1;
        din = 0;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // --- Test stream 1: 1101 ---
        din=1; @(posedge clk);
        din=1; @(posedge clk);
        din=0; @(posedge clk);
        din=1; @(posedge clk); // expect pulse here

        // small gap
        din=0; @(posedge clk);

        // --- Test stream 2: 1101101 (overlap, expect pulses at last bits 3 and 6) ---
        din=1; @(posedge clk);
        din=1; @(posedge clk);
        din=0; @(posedge clk);
        din=1; @(posedge clk); // expect pulse
        din=1; @(posedge clk);
        din=0; @(posedge clk);
        din=1; @(posedge clk); // expect pulse

        // small gap
        din=0; @(posedge clk);

        // --- Test stream 3: 01101101 (expect pulses at indices 4 and 7) ---
        din=0; @(posedge clk);
        din=1; @(posedge clk);
        din=1; @(posedge clk);
        din=0; @(posedge clk);
        din=1; @(posedge clk); // expect pulse
        din=1; @(posedge clk);
        din=0; @(posedge clk);
        din=1; @(posedge clk); // expect pulse

        // --- Test stream 4: 111101 (expect pulse at index 5) ---
        din=1; @(posedge clk);
        din=1; @(posedge clk);
        din=1; @(posedge clk);
        din=1; @(posedge clk);
        din=0; @(posedge clk);
        din=1; @(posedge clk); // expect pulse

        // Finish
        #20;
        $display("\\n[TB] Simulation finished.");
        $finish;
    end

endmodule

