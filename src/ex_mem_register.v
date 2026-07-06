`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:33:59
// Design Name: 
// Module Name: ex_mem_register
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


module ex_mem_register(
    input clk,
    input rst,
    // Control signals
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    // Data
    input [7:0] alu_result_in,
    input zero_in,
    input [7:0] write_data_in,  // For store
    input [1:0] rd_in,
    input [7:0] branch_target_in,
    input branch_in,
    input jump_in,
    // Outputs
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg [7:0] alu_result_out,
    output reg zero_out,
    output reg [7:0] write_data_out,
    output reg [1:0] rd_out,
    output reg [7:0] branch_target_out,
    output reg branch_out,
    output reg jump_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        alu_result_out <= 8'b0;
        zero_out <= 1'b0;
        write_data_out <= 8'b0;
        rd_out <= 2'b0;
        branch_target_out <= 8'b0;
        branch_out <= 1'b0;
        jump_out <= 1'b0;
    end
    else begin
        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        alu_result_out <= alu_result_in;
        zero_out <= zero_in;
        write_data_out <= write_data_in;
        rd_out <= rd_in;
        branch_target_out <= branch_target_in;
        branch_out <= branch_in;
        jump_out <= jump_in;
    end
end

endmodule
