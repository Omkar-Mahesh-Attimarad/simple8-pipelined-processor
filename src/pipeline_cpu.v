`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:38:43
// Design Name: 
// Module Name: pipeline_cpu
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


module pipeline_cpu(
    input clk,
    input rst,
    output halt_signal
);

// ==========================================
// Wires between stages and pipeline registers
// ==========================================

// IF stage outputs
wire [15:0] if_instruction;
wire [7:0] if_pc;

// IF/ID pipeline register outputs
wire [15:0] id_instruction;
wire [7:0] id_pc;

// ID stage outputs
wire [3:0] id_opcode;
wire [1:0] id_rs, id_rt, id_rd;
wire [7:0] id_read_data1, id_read_data2;
wire [7:0] id_immediate, id_branch_target;
wire id_reg_write, id_mem_read, id_mem_write, id_mem_to_reg;
wire [1:0] id_alu_op;
wire id_alu_src, id_branch, id_jump;

// ID/EX pipeline register outputs
wire ex_reg_write, ex_mem_read, ex_mem_write, ex_mem_to_reg;
wire [1:0] ex_alu_op;
wire ex_alu_src, ex_branch, ex_jump;
wire [7:0] ex_read_data1, ex_read_data2, ex_immediate;
wire [1:0] ex_rs, ex_rt, ex_rd;
wire [7:0] ex_pc;

// EX stage outputs
wire [7:0] ex_alu_result;
wire ex_zero;
wire ex_branch_taken;

// EX/MEM pipeline register outputs
wire mem_reg_write, mem_mem_read, mem_mem_write, mem_mem_to_reg;
wire [7:0] mem_alu_result;
wire mem_zero;
wire [7:0] mem_write_data;
wire [1:0] mem_rd;
wire [7:0] mem_branch_target;
wire mem_branch, mem_jump;

// MEM stage outputs
wire [7:0] mem_read_data;

// MEM/WB pipeline register outputs
wire wb_reg_write, wb_mem_to_reg;
wire [7:0] wb_mem_data, wb_alu_result;
wire [1:0] wb_rd;

// WB stage outputs
wire [7:0] wb_write_data;

// Control signals
wire stall;
wire if_id_flush, id_ex_flush;

// NEW: Forwarding signals
wire [1:0] forward_a, forward_b;

// ==========================================
// Forwarding Unit (NEW!)
// ==========================================
forwarding_unit fwd_unit (
    .ex_rs(ex_rs),
    .ex_rt(ex_rt),
    .ex_rd(ex_rd),           // NEW: Add this connection
    .mem_rd(mem_rd),
    .mem_reg_write(mem_reg_write),
    .wb_rd(wb_rd),
    .wb_reg_write(wb_reg_write),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

// ==========================================
// Hazard Detection Unit
// ==========================================
hazard_detection_unit hazard_unit (
    .id_rs(id_rs),
    .id_rt(id_rt),
    .ex_rd(ex_rd),
    .ex_reg_write(ex_reg_write),
    .ex_mem_read(ex_mem_read),
    .mem_rd(mem_rd),
    .mem_reg_write(mem_reg_write),
    .stall(stall),
    .flush_id_ex(id_ex_flush)
);

// ==========================================
// IF Stage
// ==========================================
if_stage if_stage_inst (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .branch_taken(ex_branch_taken),
    .jump_taken(ex_jump),
    .branch_target(id_branch_target),
    .instruction(if_instruction),
    .pc_out(if_pc)
);

// ==========================================
// IF/ID Pipeline Register
// ==========================================
if_id_register if_id_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .flush(if_id_flush),
    .instruction_in(if_instruction),
    .pc_in(if_pc),
    .instruction_out(id_instruction),
    .pc_out(id_pc)
);

// ==========================================
// ID Stage
// ==========================================
id_stage id_stage_inst (
    .clk(clk),
    .rst(rst),
    .instruction(id_instruction),
    .pc_in(id_pc),
    .wb_reg_write(wb_reg_write),
    .wb_rd(wb_rd),
    .wb_data(wb_write_data),
    .opcode(id_opcode),
    .rs(id_rs),
    .rt(id_rt),
    .rd(id_rd),
    .read_data1(id_read_data1),
    .read_data2(id_read_data2),
    .immediate(id_immediate),
    .branch_target(id_branch_target),
    .reg_write(id_reg_write),
    .mem_read(id_mem_read),
    .mem_write(id_mem_write),
    .mem_to_reg(id_mem_to_reg),
    .alu_op(id_alu_op),
    .alu_src(id_alu_src),
    .branch(id_branch),
    .jump(id_jump)
);

// ==========================================
// ID/EX Pipeline Register
// ==========================================
id_ex_register id_ex_reg (
    .clk(clk),
    .rst(rst),
    .flush(id_ex_flush),
    .reg_write_in(id_reg_write),
    .mem_read_in(id_mem_read),
    .mem_write_in(id_mem_write),
    .mem_to_reg_in(id_mem_to_reg),
    .alu_op_in(id_alu_op),
    .alu_src_in(id_alu_src),
    .branch_in(id_branch),
    .jump_in(id_jump),
    .read_data1_in(id_read_data1),
    .read_data2_in(id_read_data2),
    .immediate_in(id_immediate),
    .rs_in(id_rs),
    .rt_in(id_rt),
    .rd_in(id_rd),
    .pc_in(id_pc),
    .reg_write_out(ex_reg_write),
    .mem_read_out(ex_mem_read),
    .mem_write_out(ex_mem_write),
    .mem_to_reg_out(ex_mem_to_reg),
    .alu_op_out(ex_alu_op),
    .alu_src_out(ex_alu_src),
    .branch_out(ex_branch),
    .jump_out(ex_jump),
    .read_data1_out(ex_read_data1),
    .read_data2_out(ex_read_data2),
    .immediate_out(ex_immediate),
    .rs_out(ex_rs),
    .rt_out(ex_rt),
    .rd_out(ex_rd),
    .pc_out(ex_pc)
);

// Add new wire for forwarded data
wire [7:0] ex_forwarded_read_data2;

// Update ex_stage instantiation
ex_stage ex_stage_inst (
    .read_data1(ex_read_data1),
    .read_data2(ex_read_data2),
    .immediate(ex_immediate),
    .alu_op(ex_alu_op),
    .alu_src(ex_alu_src),
    .branch(ex_branch),
    .pc_in(ex_pc),
    .branch_target_in(ex_immediate),
    .forward_a(forward_a),
    .forward_b(forward_b),
    .mem_forward_data(mem_alu_result),
    .wb_forward_data(wb_write_data),
    .alu_result(ex_alu_result),
    .zero(ex_zero),
    .branch_taken(ex_branch_taken),
    .forwarded_read_data2(ex_forwarded_read_data2)  // NEW
);

// Remove the store_data wire and just use ex_forwarded_read_data2
ex_mem_register ex_mem_reg (
    .clk(clk),
    .rst(rst),
    .reg_write_in(ex_reg_write),
    .mem_read_in(ex_mem_read),
    .mem_write_in(ex_mem_write),
    .mem_to_reg_in(ex_mem_to_reg),
    .alu_result_in(ex_alu_result),
    .zero_in(ex_zero),
    .write_data_in(ex_forwarded_read_data2),  // Use forwarded data from EX stage
    .rd_in(ex_rd),
    .branch_target_in(ex_immediate),
    .branch_in(ex_branch),
    .jump_in(ex_jump),
    .reg_write_out(mem_reg_write),
    .mem_read_out(mem_mem_read),
    .mem_write_out(mem_mem_write),
    .mem_to_reg_out(mem_mem_to_reg),
    .alu_result_out(mem_alu_result),
    .zero_out(mem_zero),
    .write_data_out(mem_write_data),
    .rd_out(mem_rd),
    .branch_target_out(mem_branch_target),
    .branch_out(mem_branch),
    .jump_out(mem_jump)
);
// ==========================================
// MEM Stage
// ==========================================
mem_stage mem_stage_inst (
    .clk(clk),
    .mem_read(mem_mem_read),
    .mem_write(mem_mem_write),
    .address(mem_alu_result),
    .write_data(mem_write_data),
    .read_data(mem_read_data)
);

// ==========================================
// MEM/WB Pipeline Register
// ==========================================
mem_wb_register mem_wb_reg (
    .clk(clk),
    .rst(rst),
    .reg_write_in(mem_reg_write),
    .mem_to_reg_in(mem_mem_to_reg),
    .mem_data_in(mem_read_data),
    .alu_result_in(mem_alu_result),
    .rd_in(mem_rd),
    .reg_write_out(wb_reg_write),
    .mem_to_reg_out(wb_mem_to_reg),
    .mem_data_out(wb_mem_data),
    .alu_result_out(wb_alu_result),
    .rd_out(wb_rd)
);

// ==========================================
// WB Stage
// ==========================================
wb_stage wb_stage_inst (
    .mem_to_reg(wb_mem_to_reg),
    .alu_result(wb_alu_result),
    .mem_data(wb_mem_data),
    .write_data(wb_write_data)
);

// Branch/Jump flush logic
assign if_id_flush = ex_branch_taken || ex_jump;

// Halt signal
assign halt_signal = 1'b0;

endmodule