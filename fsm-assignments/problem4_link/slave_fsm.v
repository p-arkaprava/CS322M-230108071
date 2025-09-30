`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 19:53:30
// Design Name: 
// Module Name: slave_fsm
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


module slave_fsm(
    input wire clk,
    input wire rst,
    input wire req,
    input wire [7:0] data_in,
    output reg ack,
    output reg [7:0] last_byte 
);
    localparam IDLE = 2'b00, ACK_1 = 2'b01, ACK_2 = 2'b10, WAIT_REQ_LOW = 2'b11;

    reg [1:0] state_reg, state_next;

    always @(posedge clk) begin
        if (rst) begin
            state_reg <= IDLE;
            last_byte <= 8'b0;
        end else begin
            state_reg <= state_next;
            if (state_reg == IDLE && req) begin
                last_byte <= data_in; // Latch data
            end
        end
    end

    always @(*) begin
        state_next = state_reg;
        ack = 1'b0;
        case (state_reg)
            IDLE: if (req) state_next = ACK_1;
            ACK_1: begin
                ack = 1'b1;
                state_next = ACK_2;
            end
            ACK_2: begin
                ack = 1'b1;
                state_next = WAIT_REQ_LOW;
            end
            WAIT_REQ_LOW: begin
                if (!req) state_next = IDLE;
            end
        endcase
    end
endmodule
