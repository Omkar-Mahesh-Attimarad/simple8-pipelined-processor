`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:33:59
// Design Name: 
// Module Name: id_ex_register
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


module id_ex_register(
    input clk,
    input rst,
    input flush,
    // Control signals
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    input [1:0] alu_op_in,
    input alu_src_in,
    input branch_in,
    input jump_in,
    // Data
    input [7:0] read_data1_in,
    input [7:0] read_data2_in,
    input [7:0] immediate_in,
    input [1:0] rs_in, rt_in, rd_in,
    input [7:0] pc_in,
    // Outputs
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg [1:0] alu_op_out,
    output reg alu_src_out,
    output reg branch_out,
    output reg jump_out,
    output reg [7:0] read_data1_out,
    output reg [7:0] read_data2_out,
    output reg [7:0] immediate_out,
    output reg [1:0] rs_out, rt_out, rd_out,
    output reg [7:0] pc_out
);

always @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        // Clear all control signals (insert NOP)
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        alu_op_out <= 2'b0;
        alu_src_out <= 1'b0;
        branch_out <= 1'b0;
        jump_out <= 1'b0;
        read_data1_out <= 8'b0;
        read_data2_out <= 8'b0;
        immediate_out <= 8'b0;
        rs_out <= 2'b0;
        rt_out <= 2'b0;
        rd_out <= 2'b0;
        pc_out <= 8'b0;
    end
    else begin
        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        alu_op_out <= alu_op_in;
        alu_src_out <= alu_src_in;
        branch_out <= branch_in;
        jump_out <= jump_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out <= immediate_in;
        rs_out <= rs_in;
        rt_out <= rt_in;
        rd_out <= rd_in;
        pc_out <= pc_in;
    end
end

endmodule