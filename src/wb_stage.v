`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:37:00
// Design Name: 
// Module Name: wb_stage
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


module wb_stage(
    input mem_to_reg,
    input [7:0] alu_result,
    input [7:0] mem_data,
    output [7:0] write_data
);

// Writeback mux
assign write_data = mem_to_reg ? mem_data : alu_result;

endmodule
