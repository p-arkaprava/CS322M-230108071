`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2025 13:03:03
// Design Name: 
// Module Name: seq_detect_mealy
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


module seq_detect_mealy(
    input din,
    input clk,
    input rst,
    output y
    );
    
    reg [1:0] pres_state,next_state;
    parameter sel_0= 0, sel_1= 1, sel_11= 2, sel_110= 3;
    
    always@(posedge clk)        
    begin
    if(rst)                    // synchronous reset
        pres_state<= sel_0;
    else
        pres_state<= next_state;  // present_state_logic
    end
    
    always@(*)                   // next_state_logic
    begin
        case(pres_state)
        sel_0: if(din)
                    next_state= sel_1;
               else
                    next_state= sel_0;
        
        sel_1: if(din)
                    next_state= sel_11;
               else
                    next_state= sel_0;
                    
       sel_11: if(din)
                    next_state= sel_11;
               else
                    next_state= sel_110;
                    
       sel_110: if(din)
                    next_state= sel_1;
               else
                    next_state= sel_0;
       
       default: next_state= sel_0; 
        
        endcase
    end
    
    assign y = (pres_state==sel_110) & din; // output_logic
endmodule
