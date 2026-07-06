`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 11:25:59
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    // From ID stage (instruction being decoded)
    input [1:0] id_rs,           // Source register 1
    input [1:0] id_rt,           // Source register 2
    
    // From EX stage (instruction currently executing)
    input [1:0] ex_rd,           // Destination register
    input ex_reg_write,          // Will this instruction write a register?
    input ex_mem_read,           // Is this a LOAD instruction?
    
    // From MEM stage (not needed with forwarding, but kept for compatibility)
    input [1:0] mem_rd,
    input mem_reg_write,
    
    // Outputs
    output reg stall,            // Should we stall the pipeline?
    output reg flush_id_ex       // Should we flush ID/EX register (insert bubble)?
);

always @(*) begin
    // Default: no stall
    stall = 1'b0;
    flush_id_ex = 1'b0;
    
    // ========================================
    // LOAD-USE Hazard Detection
    // ========================================
    // Only stall if:
    // 1. EX stage has a LOAD instruction (ex_mem_read = 1)
    // 2. The LOAD's destination matches ID's source registers
    // 3. The destination is not R0
    
    if (ex_mem_read && ex_reg_write && (ex_rd != 2'b00)) begin
        if ((ex_rd == id_rs) || (ex_rd == id_rt)) begin
            // LOAD-USE HAZARD DETECTED!
            // We must stall because data won't be ready in time
            stall = 1'b1;           // Stall IF and ID stages
            flush_id_ex = 1'b1;     // Insert bubble (NOP) into EX stage
        end
    end
    
    // ========================================
    // Note: All other hazards are handled by forwarding!
    // ========================================
    // We DON'T stall for:
    // - Regular ALU instructions (ADD, SUB, etc.) → Forwarding handles it
    // - Instructions in MEM/WB stages → Forwarding handles it
    // 
    // We ONLY stall for LOAD-USE because the data isn't ready yet
end

endmodule
