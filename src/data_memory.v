`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2025 16:31:55
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input clk,                  // Clock for synchronous writes
    input mem_read,             // Read enable
    input mem_write,            // Write enable
    input [7:0] address,        // Memory address (0-255)
    input [7:0] write_data,     // Data to write
    output [7:0] read_data      // Data read from memory
    );
    reg [7:0] location [0:255];
    initial begin
        location[0] = 8'd0;
        location[1] = 8'd1;
        location[2] = 8'd2;
        location[3] = 8'd3;
        location[4] = 8'd4;
        location[5] = 8'd5;
        location[6] = 8'd6;
        location[7] = 8'd7;
    end    
    always@(posedge clk) begin
        if(mem_write) begin
            location[address] <= write_data;
        end       
    end  
    assign read_data = mem_read ? location[address] : 8'b0;  
    endmodule
