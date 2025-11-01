`timescale 1ns / 1ps

module datapath2_tb4;

    // Girişler
    reg [1:0] addr1, addr2, addr3;
    reg clk, wr, rst;
    reg [2:0] aluControl;

    // Çıkış
    wire [31:0] data1,data2,result;

    // ALU instance
    datapath uut (
        addr1,addr2,addr3,clk,wr,rst,aluControl,data1,data2,result
    );

    initial clk = 0;
    always #5 clk = ~clk;

initial begin
    
    $dumpfile("datapath2_tb4.vcd");
    $dumpvars(0, datapath2_tb4);

    //r0 - R2 YAPARSAM OLUR R2 = -1
    rst = 0;
    wr = 0;
    addr1 = 2'b00;  // R0
    addr2 = 2'b10;  // R2
    addr3 = 2'b10;  // R2
    aluControl = 3'b001; // SUBSTRACT

    #10;

    wr = 1;

    #20;
    wr = 0;

    #20;
    $finish;

end


endmodule
