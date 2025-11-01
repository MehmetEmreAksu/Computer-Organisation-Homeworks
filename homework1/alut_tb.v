`timescale 1ns / 1ps

module alu_tb;

    // Girişler
    reg [31:0] a, b;
    reg [2:0] aluControl;

    // Çıkış
    wire [31:0] result;

    // ALU instance
    alu uut (
        .a(a),
        .b(b),
        .aluControl(aluControl),
        .result(result)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Test 1: ADD (000)
        a = 32'd10;
        b = 32'd5;
        aluControl = 3'b000;
        #10;
        $display("ADD: %d + %d = %d", a, b, result);

        // Test 2: SUB (001)
        a = 32'd20;
        b = 32'd7;
        aluControl = 3'b001;
        #10;
        $display("SUB: %d - %d = %d", a, b, result);

        // Test 3: AND (010)
        a = 32'b001001;
        b = 32'b001010;
        aluControl = 3'b010;
        #10;
        $display("AND: %h & %h = %h", a, b, result);

        // Test 4: XOR (011)
        a = 32'b00001;
        b = 32'h00011;
        aluControl = 3'b011;
        #10;
        $display("XOR: %h ^ %h = %h", a, b, result);

        // Test 5: SLT (100)
        a = 32'd5;
        b = 32'd10;
        aluControl = 3'b101;
        #10;
        $display("SLT: (%d < %d) = %h", a, b, result);

        $finish;
    end

endmodule
