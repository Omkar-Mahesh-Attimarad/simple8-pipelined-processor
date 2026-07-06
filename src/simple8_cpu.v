`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2025 11:27:04
// Design Name: 
// Module Name: simple8_cpu
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


module simple8_cpu(
    input clk, rst,
    output halt_signal
    );
    wire [7:0]alu_input_b, alu_result;
    wire zero;
    
    wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt;
    wire [1:0]alu_op;
    
    wire [7:0]mem_read_data;
    
    wire [7:0] pc_out;
    wire [7:0] pc_in;
    wire pc_write;
    wire pc_src;
    
    wire [7:0] read_data1, read_data2;
    wire [7:0] write_data;
    
    wire branch_taken;
    wire [7:0] pc_plus_1;
    
    wire [3:0] opcode;
    wire [15:0]instruction;
    wire [1:0]rd, rs, rt;
    wire [7:0]immediate,jump_address,branch_address;
    assign opcode = instruction[15:12];
    assign rd = instruction[11:10];
    assign rs = instruction[9:8];
    assign rt = instruction[7:6];
    assign immediate = instruction[9:2];
    assign branch_address = instruction[5:0];   // 6-bit for BEQ
    assign jump_address = instruction[11:4];
    
    alu alu_unit(read_data1, alu_input_b, alu_op, alu_result, zero);
    control_unit ctrl(opcode, reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
    data_memory dmem(clk, mem_read, mem_write, alu_result, read_data2, mem_read_data);
    instruction_memory imem(pc_out, instruction);
    program_counter pc(clk, rst, pc_write, pc_in, pc_src, pc_out);
    register_file regfile(clk, rst, reg_write, rs, rt, rd, write_data, read_data1, read_data2);
    
    assign alu_input_b = alu_src ? immediate : read_data2;
    assign write_data = mem_to_reg ? mem_read_data : alu_result;
    assign pc_plus_1 = pc_out + 8'd1;
    assign branch_taken = branch & zero;
    assign pc_src = branch_taken | jump;
    assign pc_in = jump ? jump_address : {2'b00, branch_address};
    assign pc_write = ~halt;
    assign halt_signal = halt;
endmodule
