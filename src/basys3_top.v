`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2025 10:10:40
// Design Name: 
// Module Name: basys3_top
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


module basys3_top(
    input clk,              // 100 MHz clock from Basys 3
    input btnC,             // Center button = reset
    input btnU,             // Up button = manual clock step
    input [15:0] sw,        // 16 switches
    output [15:0] led,      // 16 LEDs
    output [6:0] seg,       // 7-segment display segments
    output [3:0] an         // 7-segment display anodes
);
    
    // ============================================
    // DIAGNOSTIC: Heartbeat LED (Always works)
    // ============================================
    reg [27:0] heartbeat_counter = 0;
    reg heartbeat = 0;
    
    always @(posedge clk) begin
        heartbeat_counter <= heartbeat_counter + 1;
        if (heartbeat_counter == 28'd50_000_000) begin
            heartbeat <= ~heartbeat;
            heartbeat_counter <= 0;
        end
    end
    
    // ============================================
    // Clock Divider - Adjustable speed
    // ============================================
    reg [29:0] clk_counter = 0;
    reg slow_clk = 0;
    
    // Speed controlled by switches [14:12]
    wire [2:0] speed_select = sw[14:12];
    reg [29:0] clk_divider;
    
    always @(*) begin
        case (speed_select)
            3'b000: clk_divider = 30'd100_000_000;  // 1 Hz (very slow)
            3'b001: clk_divider = 30'd50_000_000;   // 2 Hz
            3'b010: clk_divider = 30'd25_000_000;   // 4 Hz
            3'b011: clk_divider = 30'd10_000_000;   // 10 Hz
            3'b100: clk_divider = 30'd5_000_000;    // 20 Hz
            3'b101: clk_divider = 30'd1_000_000;    // 100 Hz
            3'b110: clk_divider = 30'd100_000;      // 1 KHz
            3'b111: clk_divider = 30'd10_000;       // 10 KHz
        endcase
    end
    
    always @(posedge clk) begin
        clk_counter <= clk_counter + 1;
        if (clk_counter >= clk_divider) begin
            slow_clk <= ~slow_clk;
            clk_counter <= 0;
        end
    end
    
    // ============================================
    // Button Debouncing for Manual Clock
    // ============================================
    reg btn_sync1 = 0, btn_sync2 = 0, btn_sync3 = 0;
    wire btn_edge;
    
    always @(posedge clk) begin
        btn_sync1 <= btnU;
        btn_sync2 <= btn_sync1;
        btn_sync3 <= btn_sync2;
    end
    
    assign btn_edge = btn_sync2 & ~btn_sync3;
    
    reg manual_clk = 0;
    always @(posedge clk) begin
        if (btn_edge) begin
            manual_clk <= ~manual_clk;
        end
    end
    
    // Select clock: manual or auto (sw[15])
    wire cpu_clk;
    assign cpu_clk = sw[15] ? manual_clk : slow_clk;
    
    // ============================================
    // Reset - Synchronous
    // ============================================
    reg rst_sync1 = 0, rst_sync2 = 0;
    wire rst;
    
    always @(posedge clk) begin
        rst_sync1 <= btnC;
        rst_sync2 <= rst_sync1;
    end
    
    assign rst = rst_sync2;
    
    // ============================================
    // Pipeline CPU Instantiation
    // ============================================
    wire halt_signal;
    
    pipeline_cpu cpu (
        .clk(cpu_clk),
        .rst(rst),
        .halt_signal(halt_signal)
    );
    
    // ============================================
    // LED Display - Pipeline Status
    // ============================================
// LED Display - Pipeline Status
    assign led[15] = heartbeat;              // Heartbeat
    assign led[14] = cpu.wb_reg_write;       // WB write enable (should pulse!)
    assign led[13] = rst;                    // Reset indicator
    assign led[12] = halt_signal;            // Halt indicator
    assign led[11] = cpu.stall;              // Stall indicator
    assign led[10:8] = cpu.wb_rd;            // Which register being written
    assign led[7:6] = cpu.forward_a;         // Forward A control
    assign led[5:4] = cpu.forward_b;         // Forward B control
    assign led[3:0] = cpu.id_instruction[15:12];  // Current opcode
    
    // ============================================
    // 7-Segment Display - Register Values
    // ============================================
    reg [19:0] refresh_counter = 0;
    reg [1:0] digit_select = 0;
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 0) begin
            digit_select <= digit_select + 1;
        end
    end
    
    // Get register values
    wire [7:0] r0_val = cpu.id_stage_inst.regfile.registers[0];
    wire [7:0] r1_val = cpu.id_stage_inst.regfile.registers[1];
    wire [7:0] r2_val = cpu.id_stage_inst.regfile.registers[2];
    wire [7:0] r3_val = cpu.id_stage_inst.regfile.registers[3];
    
    // Display mode: show lower nibble (4 bits) of each register
    reg [3:0] current_digit;
    always @(*) begin
        case (digit_select)
            2'b00: current_digit = r0_val[3:0];
            2'b01: current_digit = r1_val[3:0];
            2'b10: current_digit = r2_val[3:0];
            2'b11: current_digit = r3_val[3:0];
        endcase
    end
    
    // Anode control (which digit is active)
    reg [3:0] an_reg;
    always @(*) begin
        case (digit_select)
            2'b00: an_reg = 4'b1110;  // Rightmost (R0)
            2'b01: an_reg = 4'b1101;  // R1
            2'b10: an_reg = 4'b1011;  // R2
            2'b11: an_reg = 4'b0111;  // Leftmost (R3)
        endcase
    end
    
    assign an = an_reg;
    
    // 7-segment decoder (common anode)
    reg [6:0] seg_reg;
    always @(*) begin
        case (current_digit)
            4'h0: seg_reg = 7'b1000000;  // 0
            4'h1: seg_reg = 7'b1111001;  // 1
            4'h2: seg_reg = 7'b0100100;  // 2
            4'h3: seg_reg = 7'b0110000;  // 3
            4'h4: seg_reg = 7'b0011001;  // 4
            4'h5: seg_reg = 7'b0010010;  // 5
            4'h6: seg_reg = 7'b0000010;  // 6
            4'h7: seg_reg = 7'b1111000;  // 7
            4'h8: seg_reg = 7'b0000000;  // 8
            4'h9: seg_reg = 7'b0010000;  // 9
            4'hA: seg_reg = 7'b0001000;  // A
            4'hB: seg_reg = 7'b0000011;  // b
            4'hC: seg_reg = 7'b1000110;  // C
            4'hD: seg_reg = 7'b0100001;  // d
            4'hE: seg_reg = 7'b0000110;  // E
            4'hF: seg_reg = 7'b0001110;  // F
            default: seg_reg = 7'b1111111;  // blank
        endcase
    end
    
    assign seg = seg_reg;
    
endmodule