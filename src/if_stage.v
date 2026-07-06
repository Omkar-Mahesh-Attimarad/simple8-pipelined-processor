`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:36:26
// Design Name: 
// Module Name: if_stage
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


`include "definitions.v"

module if_stage(
    input clk,
    input rst,
    input stall,              // NEW: Stall signal
    input branch_taken,
    input jump_taken,
    input [7:0] branch_target,
    output [15:0] instruction,
    output [7:0] pc_out
);

reg [7:0] pc;

// PC update logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 8'b0;
    end
    else if (!stall) begin       // Only update if NOT stalled
        if (branch_taken || jump_taken) begin
            pc <= branch_target;
        end
        else begin
            pc <= pc + 1;
        end
    end
    // If stall=1, PC holds its value (doesn't increment)
end

assign pc_out = pc;

// Instruction memory
instruction_memory imem (
    .address(pc),
    .instruction(instruction)
);

endmodule
