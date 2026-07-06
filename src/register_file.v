`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 14:46:55
// Design Name: 
// Module Name: register_file
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


module register_file(
    input clk,
    input rst,
    input write_en,
    input [1:0] read_reg1, read_reg2, write_reg,
    input [7:0] write_data,
    output [7:0] read_data1, read_data2
);

// Explicitly declare as reg array for synthesis
(* ram_style = "distributed" *) reg [7:0] registers [0:3];

// Reading (combinational)
assign read_data1 = registers[read_reg1];
assign read_data2 = registers[read_reg2];

// Writing on positive edge
always @(posedge clk) begin
    if (rst) begin
        registers[0] <= 8'd0;
        registers[1] <= 8'd0;
        registers[2] <= 8'd0;
        registers[3] <= 8'd0;
    end
    else if (write_en) begin
        registers[write_reg] <= write_data;
    end
end

endmodule