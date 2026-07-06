`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2025 15:48:45
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input clk,
    input rst,
    input pc_write,
    input [7:0] pc_in,
    input pc_src,
    output reg [7:0] pc_out
    );
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            pc_out <= 8'b0;
        end else if(pc_write)
        begin
            if(pc_src)
            begin
                pc_out <= pc_in;
            end else 
            begin
                pc_out <= pc_out + 1;
            end
        end        
    end    
endmodule
