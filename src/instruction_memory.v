`timescale 1ns / 1ps

module instruction_memory(
    input [7:0] address,
    output reg [15:0] instruction
);
    
    // Combinational logic - always synthesizes correctly
    always @(*) begin
        case (address)
            8'd0:    instruction = 16'b0110_0100_0001_0100;  // LOADI R1, #5
            8'd1:    instruction = 16'b0000_1001_0100_0000;  // ADD R2, R1, R1
            8'd2:    instruction = 16'b0000_1110_0100_0000;  // ADD R3, R2, R1
            default: instruction = 16'hF000;                 // HALT
        endcase
    end
    
endmodule