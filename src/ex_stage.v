`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:36:26
// Design Name: 
// Module Name: ex_stage
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


module ex_stage(
    input [7:0] read_data1,
    input [7:0] read_data2,
    input [7:0] immediate,
    input [1:0] alu_op,
    input alu_src,
    input branch,
    input [7:0] pc_in,
    input [7:0] branch_target_in,
    
    // Forwarding inputs
    input [1:0] forward_a,           // Forwarding control for input A
    input [1:0] forward_b,           // Forwarding control for input B
    input [7:0] mem_forward_data,    // Data from MEM stage
    input [7:0] wb_forward_data,     // Data from WB stage
    
    // Outputs
    output [7:0] alu_result,
    output zero,
    output branch_taken,
    output [7:0] forwarded_read_data2  // NEW: For STORE instructions
);

// Forwarding MUX for input A (rs)
wire [7:0] alu_input_a;
assign alu_input_a = (forward_a == 2'b10) ? mem_forward_data :  // Forward from MEM
                     (forward_a == 2'b01) ? wb_forward_data :   // Forward from WB
                     read_data1;                                 // No forwarding

// Forwarding MUX for input B (rt) - before immediate mux
wire [7:0] alu_input_b_pre_mux;
assign alu_input_b_pre_mux = (forward_b == 2'b10) ? mem_forward_data :  // Forward from MEM
                             (forward_b == 2'b01) ? wb_forward_data :   // Forward from WB
                             read_data2;                                 // No forwarding

// NEW: Export the forwarded value for STORE instructions
assign forwarded_read_data2 = alu_input_b_pre_mux;

// ALU input B mux (immediate vs register)
wire [7:0] alu_input_b;
assign alu_input_b = alu_src ? immediate : alu_input_b_pre_mux;

// ALU
alu alu_unit (
    .a(alu_input_a),
    .b(alu_input_b),
    .op(alu_op),
    .res(alu_result),
    .zero(zero)
);

// Branch decision
assign branch_taken = branch & zero;

endmodule