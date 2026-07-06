module alu_tb;
    reg [7:0] a, b;
    reg [1:0] op;
    wire [7:0] res;
    wire zero;
    
    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .op(op),
        .res(res),
        .zero(zero)
    );
    
    initial begin
        $display("Testing ALU...");
        
        // Test ADD
        a = 8'd5; b = 8'd3; op = 2'b00;
        #10;
        $display("ADD: %d + %d = %d (expected 8)", a, b, res);
        
        // Test SUB
        a = 8'd10; b = 8'd4; op = 2'b01;
        #10;
        $display("SUB: %d - %d = %d (expected 6)", a, b, res);
        
        // Test AND
        a = 8'b11110000; b = 8'b10101010; op = 2'b10;
        #10;
        $display("AND: %b & %b = %b", a, b, res);
        
        // Test OR
        a = 8'b11110000; b = 8'b00001111; op = 2'b11;
        #10;
        $display("OR: %b | %b = %b", a, b, res);
        
        // Test zero flag
        a = 8'd5; b = 8'd5; op = 2'b01;  // 5-5=0
        #10;
        $display("Zero flag test: %d - %d = %d, zero=%b", a, b, res, zero);
        
        $display("ALU test complete!");
        $finish;
    end
endmodule