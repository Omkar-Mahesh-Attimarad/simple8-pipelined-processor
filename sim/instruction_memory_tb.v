module instruction_memory_tb;
    reg [7:0] address;
    wire [15:0] instruction;
    
    // Instantiate instruction memory
    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );
    
    initial begin
        $display("Testing Instruction Memory...");
        
        // Read from address 0
        address = 8'd0;
        #10;
        $display("Address %d: Instruction = %b", address, instruction);
        
        // Read from address 1
        address = 8'd1;
        #10;
        $display("Address %d: Instruction = %b", address, instruction);
        
        // Read from address 2
        address = 8'd2;
        #10;
        $display("Address %d: Instruction = %b", address, instruction);
        
        // Read from address 3
        address = 8'd3;
        #10;
        $display("Address %d: Instruction = %b", address, instruction);
        
        // Try reading from an uninitialized location
        address = 8'd100;
        #10;
        $display("Address %d: Instruction = %b (uninitialized)", address, instruction);
        
        $display("Instruction Memory test complete!");
        $finish;
    end
endmodule
