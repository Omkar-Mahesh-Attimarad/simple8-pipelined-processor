module data_memory_tb;
    reg clk, mem_read, mem_write;
    reg [7:0] address, write_data;
    wire [7:0] read_data;
    
    // Instantiate data memory
    data_memory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );
    
    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        $display("Testing Data Memory...");
        mem_read = 0;
        mem_write = 0;
        
        // Test 1: Write to address 1
        @(posedge clk);
        address = 8'd1;
        write_data = 8'd42;
        mem_write = 1;
        mem_read = 0;
        $display("Writing 42 to address 1...");
        
        @(posedge clk);
        mem_write = 0;
        
        // Test 2: Read from address 1
        @(posedge clk);
        address = 8'd1;
        mem_read = 1;
        #1;
        $display("Read from address 1: %d (expected 42)", read_data);
        
        // Test 3: Write to address 2
        @(posedge clk);
        address = 8'd2;
        write_data = 8'd100;
        mem_write = 1;
        mem_read = 0;
        $display("Writing 100 to address 2...");
        
        @(posedge clk);
        mem_write = 0;
        
        // Test 4: Read from address 2
        @(posedge clk);
        address = 8'd2;
        mem_read = 1;
        #1;
        $display("Read from address 2: %d (expected 100)", read_data);
        
        // Test 5: Read from address 1 again (should still be 42)
        @(posedge clk);
        address = 8'd1;
        #1;
        $display("Read from address 1 again: %d (expected 42)", read_data);
        
        // Test 6: Write and read same address in sequence
        @(posedge clk);
        address = 8'd5;
        write_data = 8'd255;
        mem_write = 1;
        
        @(posedge clk);
        mem_write = 0;
        mem_read = 1;
        #1;
        $display("Read from address 5: %d (expected 255)", read_data);
        
        // Test 7: Overwrite existing data
        @(posedge clk);
        address = 8'd1;
        write_data = 8'd99;
        mem_write = 1;
        mem_read = 0;
        $display("Overwriting address 1 with 99...");
        
        @(posedge clk);
        mem_write = 0;
        mem_read = 1;
        address = 8'd1;
        #1;
        $display("Read from address 1: %d (expected 99)", read_data);
        
        $display("Data Memory test complete!");
        $finish;
    end
endmodule
