module datapath(
        input [1:0] addr1, addr2, addr3,
        input clk, wr, rst,
        input [2:0] aluControl,
        output [31:0] data1,data2,result
        
);

wire [31:0] data1, data2, aluoutput;

alu alu(data1,data2,aluControl,aluoutput);
regfile register(addr1, addr2, addr3, data1,data2,aluoutput,clk,wr,rst);
assign result = aluoutput;

endmodule
