

module simple8_cpu_tb;
    reg clk, rst;
    wire halt_signal;
    wire [7:0] pc_output;
    wire [7:0] alu_result_output;
    
    // Instantiate CPU
    simple8_cpu cpu (
        .clk(clk),
        .rst(rst),
        .halt_signal(halt_signal),
        .pc_output(pc_output),
        .alu_result_output(alu_result_output)
    );
    
    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        $display("========================================");
        $display("Starting Simple-8 Processor Test");
        $display("========================================");
        
        // Reset
        rst = 1;
        #10;
        rst = 0;
        
        // Monitor execution
        $display("\nTime | PC | Instruction | ALU Result");
        $display("-----|-------|-------------|------------");
        $display("%0t | %3d   |    %b    | %3d", 
                     $time, pc_output, cpu.instruction, alu_result_output);
        // Run until halt or timeout
        repeat(20) begin  // Just 20 cycles to see the loop
    @(posedge clk);
    #1;
    
    $display("========== Cycle at PC=%d ==========", cpu.pc_out);
    $display("Instruction: %b", cpu.instruction);
    $display("Opcode: %b (%d)", cpu.opcode, cpu.opcode);
    
    // Decoded fields
    $display("Decoded: rd=%d, rs=%d, rt=%d", cpu.rd, cpu.rs, cpu.rt);
    $display("Immediate: %d, branch_addr: %d, jump_addr: %d", 
             cpu.immediate, cpu.branch_address, cpu.jump_address);
    
    // Register values
    $display("Registers: R0=%d, R1=%d, R2=%d, R3=%d",
             cpu.regfile.registers[0],
             cpu.regfile.registers[1],
             cpu.regfile.registers[2],
             cpu.regfile.registers[3]);
    
    // ALU
    $display("ALU: a=%d, b=%d, op=%b, result=%d, zero=%b",
             cpu.read_data1, cpu.alu_input_b, cpu.alu_op, 
             cpu.alu_result, cpu.zero);
    
    // Control signals
    $display("Control: reg_write=%b, alu_src=%b, branch=%b, jump=%b",
             cpu.reg_write, cpu.alu_src, cpu.branch, cpu.jump);
    
    // PC control
    $display("PC Control: branch_taken=%b, pc_src=%b, pc_in=%d, pc_write=%b",
             cpu.branch_taken, cpu.pc_src, cpu.pc_in, cpu.pc_write);
    
    $display("Next PC will be: %d", cpu.pc_src ? cpu.pc_in : (cpu.pc_out + 1));
    $display("");
    
    if (halt_signal) begin
        $display("HALTED!");
        $finish;
    end
end

$display("ERROR: Did not halt after 20 cycles");
$finish;
    end
endmodule