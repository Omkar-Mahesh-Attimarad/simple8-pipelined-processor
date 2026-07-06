`timescale 1ns / 1ps

module forwarding_unit(
    // From ID/EX register (instruction in EX stage)
    input [1:0] ex_rs,           // Source register 1 in EX
    input [1:0] ex_rt,           // Source register 2 in EX
    input [1:0] ex_rd,           // NEW: Destination (used as source for STORE)
    
    // From EX/MEM register (instruction in MEM stage)
    input [1:0] mem_rd,          // Destination register in MEM
    input mem_reg_write,         // Will MEM stage write a register?
    
    // From MEM/WB register (instruction in WB stage)
    input [1:0] wb_rd,           // Destination register in WB
    input wb_reg_write,          // Will WB stage write a register?
    
    // Forwarding control outputs
    output reg [1:0] forward_a,  // Controls mux for ALU input A
    output reg [1:0] forward_b   // Controls mux for ALU input B
);

// Forward A (for ALU input A / rs)
always @(*) begin
    forward_a = 2'b00;  // Default: no forwarding
    
    // EX hazard (forward from MEM stage)
    if (mem_reg_write && (mem_rd != 2'b00) && (mem_rd == ex_rs)) begin
        forward_a = 2'b10;  // Forward from MEM stage
    end
    // MEM hazard (forward from WB stage)
    else if (wb_reg_write && (wb_rd != 2'b00) && (wb_rd == ex_rs)) begin
        forward_a = 2'b01;  // Forward from WB stage
    end
end

// Forward B (for ALU input B / rt OR rd for STORE)
always @(*) begin
    forward_b = 2'b00;  // Default: no forwarding
    
    // Check BOTH rt and rd (STORE uses rd as source)
    // EX hazard (forward from MEM stage)
    if (mem_reg_write && (mem_rd != 2'b00) && 
        ((mem_rd == ex_rt) || (mem_rd == ex_rd))) begin
        forward_b = 2'b10;  // Forward from MEM stage
    end
    // MEM hazard (forward from WB stage)
    else if (wb_reg_write && (wb_rd != 2'b00) && 
             ((wb_rd == ex_rt) || (wb_rd == ex_rd))) begin
        forward_b = 2'b01;  // Forward from WB stage
    end
end

endmodule