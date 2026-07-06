//`include "definitions.v"

module control_unit_tb;
    reg [3:0] opcode;
    wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt;
    wire [1:0] alu_op;
    
    control_unit uut (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .halt(halt)
    );
    
    initial begin
        $display("Testing Control Unit...");
        $display("Opcode | RW | ALUOp | AS | MR | MW | M2R | BR | J | H");
        $display("-------|-------|-------|----|----|----|----|-------|---|---");
        
        // Test ADD
        opcode = `OPCODE_ADD;
        #10;
        $display("ADD    | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test SUB
        opcode = `OPCODE_SUB;
        #10;
        $display("SUB    | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test LOAD
        opcode = `OPCODE_LOAD;
        #10;
        $display("LOAD   | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test STORE
        opcode = `OPCODE_STORE;
        #10;
        $display("STORE  | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test LOADI
        opcode = `OPCODE_LOADI;
        #10;
        $display("LOADI  | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test BEQ
        opcode = `OPCODE_BEQ;
        #10;
        $display("BEQ    | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test JUMP
        opcode = `OPCODE_JUMP;
        #10;
        $display("JUMP   | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        // Test HALT
        opcode = `OPCODE_HALT;
        #10;
        $display("HALT   | %b  |  %b   | %b  | %b  | %b  | %b  | %b | %b | %b",
                 reg_write, alu_op, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, halt);
        
        $display("\nControl Unit test complete!");
        $finish;
    end
endmodule