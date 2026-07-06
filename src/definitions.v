`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2025 16:20:28
// Design Name: 
// Module Name: definitions
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


// ============================================
// Simple-8 Processor Instruction Set
// ============================================

// Opcodes (4 bits)
`define OPCODE_ADD    4'b0000
`define OPCODE_SUB    4'b0001
`define OPCODE_AND    4'b0010
`define OPCODE_OR     4'b0011
`define OPCODE_LOAD   4'b0100
`define OPCODE_STORE  4'b0101
`define OPCODE_LOADI  4'b0110
`define OPCODE_BEQ    4'b0111
`define OPCODE_JUMP   4'b1000
`define OPCODE_HALT   4'b1111

// ALU Operations
`define ALU_ADD  2'b00
`define ALU_SUB  2'b01
`define ALU_AND  2'b10
`define ALU_OR   2'b11

// Register addresses (for readability)
`define R0  2'b00
`define R1  2'b01
`define R2  2'b10
`define R3  2'b11
