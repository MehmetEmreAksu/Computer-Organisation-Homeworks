
`timescale 1ns/1ps

module tb;

    reg[31:0] a;
    reg[31:0] b;
    reg Cin;
    wire[31:0]Sum;
    wire Cout;

    alu uut(
        a,b,
    );

    initial begin
    $dumpfile("adder32.vcd");     
    $dumpvars(0, tb);     
    end

    initial begin
        a = 32'b11;
        b = 32'b1;
        Cin = 0;
        #10;
        $display("%b %b %b %b",a,b,Sum,Cout);
    end


endmodule



