module program_counter_tb;
    reg clk, rst, pc_write, pc_src;
    reg [7:0] pc_in;
    wire [7:0] pc_out;
    
    // Instantiate PC
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .pc_write(pc_write),
        .pc_in(pc_in),
        .pc_src(pc_src),
        .pc_out(pc_out)
    );
    
    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        $display("Testing Program Counter...");
        
        // Test reset
        rst = 1; pc_write = 0; pc_src = 0; pc_in = 0;
        @(posedge clk);
        #1;
        $display("After reset: PC = %d (expected 0)", pc_out);
        
        // Test increment
        rst = 0; pc_write = 1; pc_src = 0;
        repeat(5) begin
            @(posedge clk);
            #1;
            $display("After increment: PC = %d", pc_out);
        end
        
        // Test jump to address 100
        pc_in = 8'd100;
        pc_src = 1;
        @(posedge clk);
        #1;
        $display("After jump to 100: PC = %d (expected 100)", pc_out);
        
        // Continue incrementing from 100
        pc_src = 0;
        repeat(3) begin
            @(posedge clk);
            #1;
            $display("After increment: PC = %d", pc_out);
        end
        
        // Test hold (pc_write = 0)
        pc_write = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        $display("After hold (2 cycles): PC = %d (should be same)", pc_out);
        
        // Resume incrementing
        pc_write = 1;
        @(posedge clk);
        #1;
        $display("After resume: PC = %d", pc_out);
        #5;
        $display("Program Counter test complete!");
        $finish;
    end
    
endmodule