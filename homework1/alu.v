module alu(input [31:0] a,
           input [31:0] b,
           input [2:0] aluControl,
           output [31:0] result
);

    wire [31:0] sum;
    wire Cout;
    wire [31:0]bInv;
    wire [31:0]yAnd;
    wire [31:0]yXor;
    wire invAluControl1;
    wire [31:0]outMux2;
    
    INV_32 INV_32_1 (b,bInv);
        mux2to1 mux2(b,bInv,aluControl[0],outMux2);
    //adder and substracter
    adder adder (a,outMux2,aluControl[0],sum,Cout);

    //and
    AND AND1(a,b,yAnd);
    
    //xor
    XOR XOR1(a,b,yXor);

    //SLT
    INV_1 INV_1_1 (aluControl[1],invAluControl1);
    wire xorResult;
    wire invxorResult;
    XOR_1_3 XOR2 (a[31],b[31],aluControl[0],xorResult);
    INV_1 INV_1_2 (xorResult,invxorResult);
    wire xorResult2;
    XOR_1 XOR3(sum[31],a[31],xorResult2);
    wire overflow;
    AND_1_3 AND2(invxorResult,xorResult2,invAluControl1,overflow);

    wire zeroextenderinput;
    XOR_1 XOR4 (overflow,sum[31],zeroextenderinput);

    wire [31:0]zeroextenderoutput;
    zero_extender ze (zeroextenderinput,zeroextenderoutput);

    mux5to1 mux5(sum,sum,yAnd,yXor,zeroextenderoutput,aluControl,result);


endmodule