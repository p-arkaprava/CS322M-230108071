`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 20:48:28
// Design Name: 
// Module Name: link_top
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



module link_top(
    input wire clk,
    input wire rst,
    output wire done
);
    wire req, ack;
    wire [7:0] data;

    master_fsm u_master (
        .clk(clk), .rst(rst), .ack(ack),
        .req(req), .data(data), .done(done)
    );

    slave_fsm u_slave (
        .clk(clk), .rst(rst), .req(req),
        .data_in(data), .ack(ack), .last_byte() 
    );
endmodule
