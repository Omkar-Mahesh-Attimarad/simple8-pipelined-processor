module pipeline_cpu_tb;

// ← ADD THIS LINE at the top
parameter TEST_NUM = 3;  // Change to 1, 2, 3, or 4

reg clk, rst;
wire halt_signal;
reg [79:0] instr_name;

pipeline_cpu cpu (
    .clk(clk),
    .rst(rst),
    .halt_signal(halt_signal)
);

// Clock generator
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    forever begin
        @(posedge clk);
        #1;  // Wait a bit after clock edge
        if (cpu.ex_mem_write) begin  // When STORE is in EX
            $display(">>> STORE in EX: rd=%d, forward_b=%b, ex_read_data2=%d, ex_forwarded_read_data2=%d, mem_alu_result=%d, wb_write_data=%d",
                     cpu.ex_rd, cpu.forward_b, cpu.ex_read_data2, cpu.ex_forwarded_read_data2, cpu.mem_alu_result, cpu.wb_write_data);
        end
    end
end

// Instruction memory dump - SEPARATE initial block
initial begin
    $display("\n==== INSTRUCTION MEMORY DUMP ====");
    $display("Addr | Hex    | Binary           | Decoded");
    $display("-----|--------|------------------|------------------");
    #1; // Wait for memory to initialize
    for (integer i = 0; i < 5; i = i + 1) begin
        $display("%0d    | 0x%h | %b | %s",
                 i,
                 cpu.if_stage_inst.imem.memory[i],
                 cpu.if_stage_inst.imem.memory[i],
                 (cpu.if_stage_inst.imem.memory[i][15:12] == 4'b0110) ? "LOADI" :
                 (cpu.if_stage_inst.imem.memory[i][15:12] == 4'b0000) ? "ADD" :
                 (cpu.if_stage_inst.imem.memory[i][15:12] == 4'b0001) ? "SUB" :
                 (cpu.if_stage_inst.imem.memory[i][15:12] == 4'b0100) ? "LOAD" :
                 (cpu.if_stage_inst.imem.memory[i][15:12] == 4'b0101) ? "STORE" :
                 (cpu.if_stage_inst.imem.memory[i][15:12] == 4'b1111) ? "HALT" : "???"
        );
    end
    $display("=================================\n");
end

// Continuous monitoring - SEPARATE initial block
initial begin
    // Wait a bit for initialization
    #1;
    
    // Monitor key signals throughout simulation
    $monitor("Time=%0t | PC=%d | Instr=%h | mem_alu_result=%d | mem_write=%b | mem_write_data=%d | R1=%d | R2=%d | R3=%d", 
             $time, 
             cpu.if_pc,
             cpu.id_instruction,
             cpu.mem_alu_result,
             cpu.mem_mem_write,
             cpu.mem_write_data,
             cpu.id_stage_inst.regfile.registers[1],
             cpu.id_stage_inst.regfile.registers[2],
             cpu.id_stage_inst.regfile.registers[3]
    );
end

// Main test sequence - SEPARATE initial block
initial begin
    $display("\n==================================================");
    $display("    Pipelined Processor with Hazard Detection");
    $display("==================================================\n");
    
    rst = 1;
    #20;
    rst = 0;
    $display("Reset complete. Starting execution...\n");
    
    $display("Cyc | PC | Instr  | Stall | R0 | R1 | R2 | R3 | Notes");
    $display("----|----|--------|-------|----|----|----|----|------------------");
    
    repeat(30) begin
        @(posedge clk);
        #1;
        
        // Debug output
        $display("DEBUG: if_instr=%b, id_instr=%b, if_pc=%d",
                 cpu.if_instruction,
                 cpu.id_instruction,
                 cpu.if_pc);
        
        // Decode instruction for display
        case (cpu.id_instruction[15:12])
            4'b0000: instr_name = "ADD  ";
            4'b0001: instr_name = "SUB  ";
            4'b0110: instr_name = "LOADI";
            4'b0111: instr_name = "BEQ  ";
            4'b1111: instr_name = "HALT ";
            4'b0100: instr_name = "LOAD ";
            4'b0101: instr_name = "STORE";
            default: instr_name = "NOP  ";
        endcase
        
        $display("%0d   | %0d  | %s | %0b     | %0d  | %0d  | %0d  | %0d  | %s",
                 $time/10,
                 cpu.if_pc,
                 instr_name,
                 cpu.stall,
                 cpu.id_stage_inst.regfile.registers[0],
                 cpu.id_stage_inst.regfile.registers[1],
                 cpu.id_stage_inst.regfile.registers[2],
                 cpu.id_stage_inst.regfile.registers[3],
                 cpu.stall ? "*** STALLED ***" : ""
        );
    end
    
    $display("\n==================================================");
    $display("Final Register Values:");
    $display("  R0 = %0d", cpu.id_stage_inst.regfile.registers[0]);
    $display("  R1 = %0d", cpu.id_stage_inst.regfile.registers[1]);
    $display("  R2 = %0d", cpu.id_stage_inst.regfile.registers[2]);
    $display("  R3 = %0d", cpu.id_stage_inst.regfile.registers[3]);

// Check based on TEST_SELECT
    case (cpu.if_stage_inst.imem.TEST_SELECT)
        1: begin
            $display("\nExpected: R1=5, R2=9, R3=14");
            if (cpu.id_stage_inst.regfile.registers[1] == 5 &&
                cpu.id_stage_inst.regfile.registers[2] == 9 &&
                cpu.id_stage_inst.regfile.registers[3] == 14) begin
                $display("*** TEST 1 PASSED! ***");
            end else begin
                $display("*** TEST 1 FAILED! ***");
            end
        end
    
        2: begin
            $display("\nExpected: R1=5, R2=5, R3=5");
            if (cpu.id_stage_inst.regfile.registers[1] == 5 &&
                cpu.id_stage_inst.regfile.registers[2] == 5 &&
                cpu.id_stage_inst.regfile.registers[3] == 5) begin
                $display("*** TEST 2 PASSED! ***");
            end else begin
                $display("*** TEST 2 FAILED! ***");
            end
        end
    
        3: begin
            $display("\nExpected: R1=5, R2=10, R3=15");
            if (cpu.id_stage_inst.regfile.registers[1] == 5 &&
                cpu.id_stage_inst.regfile.registers[2] == 10 &&
                cpu.id_stage_inst.regfile.registers[3] == 15) begin
                $display("*** TEST 3 PASSED! ***");
            end else begin
                $display("*** TEST 3 FAILED! ***");
                end
            end
    
        4: begin
           $display("\nExpected: R1=10, R2=10, R3=20");
           if (cpu.id_stage_inst.regfile.registers[1] == 10 &&
                cpu.id_stage_inst.regfile.registers[2] == 10 &&
                cpu.id_stage_inst.regfile.registers[3] == 20) begin
                $display("*** TEST 4 PASSED! ***");
           end else begin
                $display("*** TEST 4 FAILED! ***");
            end
        end
    endcase

    $display("==================================================\n");
    $finish;
end

endmodule