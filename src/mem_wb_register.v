`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 10:33:59
// Design Name: 
// Module Name: mem_wb_register
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


module mem_wb_register(
    input clk,
    input rst,
    // Control signals
    input reg_write_in,
    input mem_to_reg_in,
    // Data
    input [7:0] mem_data_in,
    input [7:0] alu_result_in,
    input [1:0] rd_in,
    // Outputs
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg [7:0] mem_data_out,
    output reg [7:0] alu_result_out,
    output reg [1:0] rd_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        mem_data_out <= 8'b0;
        alu_result_out <= 8'b0;
        rd_out <= 2'b0;
    end
    else begin
        reg_write_out <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        mem_data_out <= mem_data_in;
        alu_result_out <= alu_result_in;
        rd_out <= rd_in;
    end
end

endmodule
