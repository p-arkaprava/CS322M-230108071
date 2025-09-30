`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 19:41:41
// Design Name: 
// Module Name: tb_traffic_light
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


`timescale 1ns/1ps

module tb_traffic_light;

    // Signals
    reg clk, rst;
    reg tick;
    wire ns_g, ns_y, ns_r;
    wire ew_g, ew_y, ew_r;

    traffic_light dut (
        .clk(clk), .rst(rst), .tick(tick),
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

    // Clock generation: 10ns period = 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Tick generator for simulation (1-cycle pulse every 5 clk cycles)
    integer cyc;
    always @(posedge clk) begin
        if (rst) begin
            cyc  <= 0;
            tick <= 0;
        end else begin
            cyc  <= cyc + 1;
            tick <= (cyc % 5 == 0);  // pulse high for exactly 1 clk cycle
        end
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_traffic_light);

        rst = 1;
        #50;       
        rst = 0;

        // Run simulation for enough ticks (e.g. 60 ticks = >1 full cycle 5+2+5+2)
        #(2000);
        $finish;
    end

    always @(posedge clk) begin
        if (tick) begin
            $display("T=%0t | NS: G=%b Y=%b R=%b | EW: G=%b Y=%b R=%b",
                     $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
        end
    end

endmodule
