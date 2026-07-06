`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:36:26
// Design Name: 
// Module Name: id_stage
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

module id_stage(
    input clk,
    input rst,
    input [15:0] instruction,
    input [7:0] pc_in,
    // From WB stage (for register writes)
    input wb_reg_write,
    input [1:0] wb_rd,
    input [7:0] wb_data,
    // Outputs - Decoded instruction fields
    output [3:0] opcode,
    output [1:0] rs, rt, rd,
    output [7:0] read_data1, read_data2,
    output [7:0] immediate,
    output [7:0] branch_target,
    // Control signals
    output reg_write,
    output mem_read,
    output mem_write,
    output mem_to_reg,
    output [1:0] alu_op,
    output alu_src,
    output branch,
    output jump
);

// Decode instruction fields
assign opcode = instruction[15:12];
assign rd = instruction[11:10];
assign rs = instruction[9:8];
assign rt = instruction[7:6];
assign immediate = instruction[9:2];
assign branch_target = instruction[9:2];


wire [1:0] reg_read2_select;
assign reg_read2_select = (opcode == `OPCODE_STORE) ? rd : rt;
// Register file
register_file regfile (
    .clk(clk),
    .rst(rst),
    .read_reg1(rs),
    .read_reg2(reg_read2_select),
    .write_reg(wb_rd),
    .write_data(wb_data),
    .write_en(wb_reg_write),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Control unit
control_unit ctrl (
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .branch(branch),
    .jump(jump),
    .halt()  // Not used in pipelined version yet
);

endmodule
