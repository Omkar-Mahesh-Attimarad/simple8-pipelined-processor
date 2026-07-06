`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 14:12:22
// Design Name: 
// Module Name: alu
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


module alu(
    input [7:0] a,b,
    input [1:0] op,
    output reg [7:0] res,
    output zero
    );
    
    always @(*) 
    begin
        case(op)
            2'b00: res = a + b;
            2'b01: res = a - b;
            2'b10: res = a & b;
            2'b11: res = a | b;
            default: res = 8'b0;
        endcase
    end
    assign zero = (res == 8'b0);
    
endmodule
