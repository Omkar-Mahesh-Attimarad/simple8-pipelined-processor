`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:33:59
// Design Name: 
// Module Name: if_id_register
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


module if_id_register(
    input clk,
    input rst,
    input stall,           // Hold current values
    input flush,           // Clear to NOP
    // Inputs from IF stage
    input [15:0] instruction_in,
    input [7:0] pc_in,
    // Outputs to ID stage
    output reg [15:0] instruction_out,
    output reg [7:0] pc_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        instruction_out <= 16'h0000;
        pc_out <= 8'h00;
    end
    else if (flush) begin
        instruction_out <= 16'h0000;  // NOP
        pc_out <= 8'h00;
    end
    else if (!stall) begin
        instruction_out <= instruction_in;
        pc_out <= pc_in;
    end
    // If stall=1, keep old values
end

endmodule
