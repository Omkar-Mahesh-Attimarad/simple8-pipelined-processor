`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2026 15:55:21
// Design Name: 
// Module Name: instruction_memory_sim
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


module instruction_memory(
    input [7:0] address,
    output [15:0] instruction
);
    reg [15:0] memory [0:255];
    
    integer i;
    parameter TEST_SELECT = 3;  // Change this to run different tests
    
    initial begin
        // Initialize all to HALT first
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 16'hF000;
        end
        
        case (TEST_SELECT)
            // ==========================================
            // TEST 1: Basic ALU Operations
            // ==========================================
            1: begin
                memory[0] = 16'h6414;  // LOADI R1, #5
                memory[1] = 16'h6824;  // LOADI R2, #9
                memory[2] = 16'h0C50;  // ADD R3, R1, R2
                memory[3] = 16'hF000;  // HALT
                $display("=== TEST 1: Basic ALU ===");
                $display("Expected: R1=5, R2=9, R3=14");
            end
            
            // ==========================================
            // TEST 2: LOAD/STORE with Forwarding
            // ==========================================
            2: begin
                memory[0] = 16'b0110_0100_0001_0100;  // LOADI R1, #5
                memory[1] = 16'b0101_0100_0010_1000;  // STORE R1, [10]
                memory[2] = 16'b0100_1000_0010_1000;  // LOAD R2, [10]
                memory[3] = 16'b0000_1110_0000_0000;  // ADD R3, R2, R0
                memory[4] = 16'hF000;                 // HALT
                $display("=== TEST 2: LOAD/STORE ===");
                $display("Expected: R1=5, R2=5, R3=5");
            end
            
            // ==========================================
            // TEST 3: Multiple Dependencies
            // ==========================================
            3: begin
                memory[0] = 16'b0110_0100_0001_0100;  // LOADI R1, #5
                memory[1] = 16'b0000_1001_0100_0000;  // ADD R2, R1, R1
                memory[2] = 16'b0000_1110_0100_0000;  // ADD R3, R2, R1
                memory[3] = 16'hF000;                 // HALT
                $display("=== TEST 3: Forwarding Test ===");
                $display("Expected: R1=5, R2=10, R3=15");
                $display("Expected stalls: 0");
            end
            
            // ==========================================
            // TEST 4: LOAD-USE Hazard
            // ==========================================
            4: begin
                memory[0] = 16'h6428;  // LOADI R1, #10
                memory[1] = 16'h5428;  // STORE R1, [10]
                memory[2] = 16'h4828;  // LOAD R2, [10]
                memory[3] = 16'h0C50;  // ADD R3, R1, R2
                memory[4] = 16'hF000;  // HALT
                $display("=== TEST 4: LOAD-USE Hazard ===");
                $display("Expected: R1=10, R2=10, R3=20");
                $display("Expected stalls: 1");
            end
            
            default: begin
                $display("ERROR: Invalid TEST_SELECT!");
                $finish;
            end
        endcase
    end
    
    assign instruction = memory[address];
    
endmodule
