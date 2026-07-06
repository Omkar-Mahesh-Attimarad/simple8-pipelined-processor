module register_file_tb;
    reg clk, write_en;
    reg [1:0] read_reg1, read_reg2, write_reg;
    reg [7:0] write_data;
    wire [7:0] read_data1, read_data2;
    
    // Instantiate register file
    register_file uut (
        .clk(clk),
        .write_en(write_en),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end
    
    // Test sequence
    initial begin
        $display("Testing Register File...");
        write_en = 0;
        
        // Write to R1
        @(posedge clk);
        write_reg = 2'd1;
        write_data = 8'd42;
        write_en = 1;
        @(posedge clk);
        write_en = 0;
        
        // Write to R2
        @(posedge clk);
        write_reg = 2'd2;
        write_data = 8'd100;
        write_en = 1;
        @(posedge clk);
        write_en = 0;
        
        // Read R1 and R2
        @(posedge clk);
        read_reg1 = 2'd1;
        read_reg2 = 2'd2;
        #1;  // Small delay for combinational logic
        $display("R1 = %d (expected 42)", read_data1);
        $display("R2 = %d (expected 100)", read_data2);
        
        // Test simultaneous read of same register
        read_reg1 = 2'd1;
        read_reg2 = 2'd1;
        #1;
        $display("Reading R1 twice: %d and %d", read_data1, read_data2);
        
        $display("Register File test complete!");
        $finish;
    end
    
endmodule