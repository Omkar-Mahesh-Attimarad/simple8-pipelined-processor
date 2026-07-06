`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2025 10:53:31
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input [3:0] opcode,         // 4-bit opcode from instruction
    
    // Register file controls
    output reg reg_write,       // 1 = write to register file
    
    // ALU controls
    output reg [1:0] alu_op,    // ALU operation select
    output reg alu_src,         // 0 = use register, 1 = use immediate
    
    // Memory controls
    output reg mem_read,        // 1 = read from data memory
    output reg mem_write,       // 1 = write to data memory
    output reg mem_to_reg,      // 0 = ALU result to reg, 1 = memory to reg
    
    // PC controls
    output reg branch,          // 1 = this is a branch instruction
    output reg jump,            // 1 = this is a jump instruction
    output reg halt             // 1 = halt execution
    );
    always @(*) begin
        // Default values (for safety)
        reg_write = 0;
        alu_op = 2'b00;
        alu_src = 0;
        mem_read = 0;
        mem_write = 0;
        mem_to_reg = 0;
        branch = 0;
        jump = 0;
        halt = 0;
        
        case(opcode)
            `OPCODE_ADD: begin
                // Set control signals for ADD
                // Hint: Check the truth table above
                reg_write = 1;
                alu_op = 2'b00;
                alu_src = 0;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_SUB: begin
                // Set control signals for SUB
                reg_write = 1;
                alu_op = 2'b01;
                alu_src = 0;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_AND: begin
                // Set control signals for AND
                reg_write = 1;
                alu_op = 2'b10;
                alu_src = 0;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_OR: begin
                // Set control signals for OR
                reg_write = 1;
                alu_op = 2'b11;
                alu_src = 0;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_LOAD: begin
                // Set control signals for LOAD
                reg_write = 1;
                //alu_op = 2'bxx;
                alu_src = 1;
                mem_read = 1;
                mem_write = 0;
                mem_to_reg = 1;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_STORE: begin
                // Set control signals for STORE
                reg_write = 0;
                //alu_op = 2'bxx;
                alu_src = 1;
                mem_read = 0;
                mem_write = 1;
                //mem_to_reg = x;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_LOADI: begin
                // Set control signals for LOADI
                reg_write = 1;
                //alu_op = 2'bxx;
                alu_src = 1;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch = 0;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_BEQ: begin
                // Set control signals for BEQ
                reg_write = 0;
                alu_op = 2'b01;
                alu_src = 0;
                mem_read = 0;
                mem_write = 0;
                //mem_to_reg = x;
                branch = 1;
                jump = 0;
                halt = 0;
            end
            
            `OPCODE_JUMP: begin
                // Set control signals for JUMP
                reg_write = 0;
                //alu_op = 2'bxx;
                //alu_src = x;
                mem_read = 0;
                mem_write = 0;
                //mem_to_reg = x;
                branch = 0;
                jump = 1;
                halt = 0;
            end
            
            `OPCODE_HALT: begin
                // Set control signals for HALT
                reg_write = 0;
                //alu_op = 2'bxx;
                //alu_src = x;
                mem_read = 0;
                mem_write = 0;
                //mem_to_reg = x;
                branch = 0;
                jump = 0;
                halt = 1;
            end
            
            default: begin
                // Keep default values (all zeros)
                reg_write = 0;
                alu_op = 2'b00;
                alu_src = 0;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch = 0;
                jump = 0;
                halt = 0;
            end
        endcase
    end
    
endmodule
