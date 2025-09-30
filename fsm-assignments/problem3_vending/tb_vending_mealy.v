`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2025 16:11:47
// Design Name: 
// Module Name: tb_vending_mealy
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


module tb_vending_mealy(

    );

  reg clk;
  reg reset;
  reg [1:0] coin;     // 00=idle, 01=5, 10=10, 11=ignore
  wire dispense;
  wire chg5;

  // Instantiate DUT
  vending_mealy dut (
    .clk(clk),
    .rst(reset),
    .coin(coin),
    .dispense(dispense),
    .chg5(chg5)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;  // 100 MHz → 10ns period

  // Stimulus
  initial begin
    // init
    reset = 1; coin = 2'b00;
    #20; 
    reset = 0;

    // Case 1: Insert 5, 5, 10 → vend at 20
    @(posedge clk); coin = 2'b01;  // 5
    @(posedge clk); coin = 2'b01;  // 10 total
    @(posedge clk); coin = 2'b10;  // 20 → vend
    @(posedge clk); coin = 2'b00;  

    // Case 2: Insert 10, 10, 5 → total=25 → vend + chg5
    repeat(2) @(posedge clk); coin = 2'b10; // 10
    @(posedge clk); coin = 2'b10;           // 20
    @(posedge clk); coin = 2'b01;           // 25 → vend+chg5
    @(posedge clk); coin = 2'b00;

    // Case 3: Insert idle (00) in between valid coins
    repeat(2) @(posedge clk); coin = 2'b01; // 5
    @(posedge clk); coin = 2'b00;           // idle, ignored
    @(posedge clk); coin = 2'b10;           // total=15
    @(posedge clk); coin = 2'b01; 
    @(posedge clk); coin = 2'b10;          // 25 → vend+chg5

    // End simulation
    #50;
    $stop;
  end

endmodule

