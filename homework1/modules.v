module AND(
    input [31:0] a,
    input [31:0] b,
    output [31:0] y
);
    assign y = a&b;
endmodule;

module AND_1(
    input a,
    input b,
    output y
);
    assign y = a&b;
endmodule;

module AND_1_3(
    input a,
    input b,
    input c,
    output y
);
    assign y = a&b&c;
endmodule;


module OR(
    input [31:0] a,
    input [31:0] b,
    output [31:0] y
);
    assign y = a|b;
endmodule


module XOR(
    input [31:0] a,
    input [31:0] b,
    output [31:0] y
);    
    assign y = a^b;
endmodule

module XOR_1(
    input a,
    input  b,
    output y
);    
    assign y = a^b;
endmodule

module XOR_1_3(
    input a,
    input b,
    input c,
    output y
);    
    assign y = a^b^c;
endmodule

module INV_32(
    input [31:0] a,
    output[31:0] y
);
    assign y = ~a;
endmodule

module INV_1(
    input  a,
    output y
);
    assign y = ~a;
endmodule

module adder (
    input  [31:0] a,
    input  [31:0] b,
    input         Cin,      
    output [31:0] sum,
    output        Cout
);
    wire [31:0] carry;

    assign{Cout,sum} = a + b + Cin;

endmodule

module mux2to1 (
    input  [31:0] in0,
    input  [31:0] in1,
    input         sel,
    output [31:0] out
);

    assign out = sel ? in1 : in0;

endmodule

module mux5to1 (
    input  [31:0] in0,
    input  [31:0] in1,
    input  [31:0] in2,
    input  [31:0] in3,
    input  [31:0] in4,
    input  [2:0]  sel,
    output reg [31:0] out
);
    
    always @(*) begin
        case (sel)
            3'b000: out = in0;
            3'b001: out = in1;
            3'b010: out = in2;
            3'b011: out = in3;
            3'b101: out = in4;
            default: out = 32'b0;
        endcase
    end

endmodule

module zero_extender (
    input  wire a,
    output wire [31:0] y
);
    assign y = {31'b0, a};
endmodule





