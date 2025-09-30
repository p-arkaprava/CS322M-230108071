`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 19:52:48
// Design Name: 
// Module Name: master_fsm
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


module master_fsm(
    input wire clk,
    input wire rst,
    input wire ack,
    output reg req,
    output reg [7:0] data,
    output reg done
);
    localparam IDLE = 3'b000, DRIVE_DATA = 3'b001, WAIT_ACK = 3'b010,
               WAIT_ACK_LOW = 3'b011, DONE = 3'b100;

    reg [2:0] state_reg, state_next;
    reg [1:0] byte_count_reg, byte_count_next;

    always @(posedge clk) begin
        if (rst) begin
            state_reg <= IDLE;
            byte_count_reg <= 2'b00;
        end else begin
            state_reg <= state_next;
            byte_count_reg <= byte_count_next;
        end
    end

    always @(*) begin
        state_next = state_reg;
        byte_count_next = byte_count_reg;
        req = 1'b0;
        data = 8'hZZ;
        done = 1'b0;

        case (state_reg)
            IDLE: state_next = DRIVE_DATA;
            DRIVE_DATA: begin
                req = 1'b1;
                data = 8'hA0 + byte_count_reg; // Example data A0, A1, A2, A3
                state_next = WAIT_ACK;
            end
            WAIT_ACK: begin
                //req = 1'b1;
                data = 8'hA0 + byte_count_reg;
                if (ack) begin
                 state_next = WAIT_ACK_LOW;
                 req = 1'b0;
                 end
            end
            WAIT_ACK_LOW: begin
                if (!ack) begin
                    if (byte_count_reg == 2'd3) state_next = DONE;
                    else begin
                        state_next = DRIVE_DATA;
                        byte_count_next = byte_count_reg + 1;
                    end
                end
            end
            DONE: begin
                done = 1'b1;
                state_next = IDLE;
            end
        endcase
    end
endmodule
