`define WORD_SIZE 32

//  Register File
module regfile(
        addr1, addr2, addr3, data1, data2, data3, clk, wr, rst
    );
    
    // Declare Input Variables
    input clk, wr, rst;
    input [4:0] addr1, addr2, addr3;
    input [`WORD_SIZE-1:0] data3;
    
    // Declare Output Variables
    output [`WORD_SIZE-1:0] data1, data2;
    
    // Reigsters
    reg [`WORD_SIZE-1:0] register[31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            register[i] = 32'h00000004;
        end
    end
    
    assign data1 = register[addr1];
    assign data2 = register[addr2];
   
    always @(posedge clk) begin
        if(rst) begin
            register[0] <= 0;
            register[1] <= 0;
            register[2] <= 0;
            register[3] <= 0;
        end
        if(wr) begin
            register[addr3] <= data3;
        end
    end
endmodule


module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0] ALUControl, // 000: ADD, 001: SUB, 010: AND, 011: OR, 101: SLT
    output reg [31:0] Result,
    output Zero
);

    always @(*) begin
        case (ALUControl)
            3'b000: Result = A + B;                      // ADD
            3'b001: Result = A - B;                      // SUB
            3'b010: Result = A & B;                      // AND
            3'b011: Result = A | B;                      // OR
            3'b101: Result = (A < B) ? 32'b1 : 32'b0;    // SLT (signed)
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule


module data_memory (
    input              clk,
    input              rst,
    input              memWrite,               // 1: yaz
    input      [31:0]  addr,                   // adres (byte adresi)
    input      [31:0]  writeData,              // yazılacak veri (sw)
    output     [31:0]  readData                // okunan veri (lw)
);

    // 1024 kelimelik bellek (4KB)
    reg [31:0] memory [0:1023];
    reg [31:0] read_data_reg;
    assign readData = read_data_reg;

    integer i;
    // Belleği başlatma
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = i; // isteğe bağlı başlangıç
        end
    end

    // Okuma (kombinasyonel)
    always @(*) begin
        read_data_reg = memory[addr[11:2]];
    end

    // Yazma (senkron)
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 1024; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end
        else if (memWrite) begin
            memory[addr[11:2]] <= writeData;
        end
    end

endmodule




module mux1 (
    input  [`WORD_SIZE-1:0] in0,   // 0 seçilince gelen
    input  [`WORD_SIZE-1:0] in1,   // 1 seçilince gelen
    input                   ALUSrc,   // seçim sinyali (0 veya 1)
    output [`WORD_SIZE-1:0] SrcB    // seçilen çıkış
);

    assign SrcB = (ALUSrc == 1'b0) ? in0 : in1;

endmodule

module mux3 (
    input  [31:0] ALUResult,       // ALU'nun çıktısı
    input  [31:0] MemoryReadData,  // Bellekten okunan veri
    input  [31:0] PCPlus4,         // PC + 4
    input  [1:0]  ResultSrc,       // Seçim için kontrol sinyali
    output reg [31:0] wd3          // Seçilen veri, register'a yazılacak
);

    always @(*) begin
        case (ResultSrc)
            2'b00: wd3 = ALUResult;        // ALU sonucu
            2'b01: wd3 = MemoryReadData;   // Bellekten okunan veri
            2'b10: wd3 = PCPlus4;          // PC + 4 (jal)
            default: wd3 = 32'b0;          // Geçersiz durumda 0
        endcase
    end

endmodule


module extender(
    input [1:0] immSrc,           // immSrc: 2-bitlik seçim sinyali
    input [31:0] instr,           // instr: 32-bitlik talimat
    output reg [31:0] immExit     // immExit: 32-bitlik genişletilmiş sabit
);

    always @(*) begin
        case (immSrc)
            2'b00: immExit = { {20{instr[31]}}, instr[31:20] };                                   // I-type
            2'b01: immExit = { {20{instr[31]}}, instr[31:25], instr[11:7] };                      // S-type
            2'b10: immExit = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 }; // B-type
            2'b11: immExit = { {11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0 }; // J-type
            default: immExit = 32'b0; // Default: 0
        endcase
    end

endmodule



module pc_system (
    input clk,                             // Saat sinyali
    input rst,                             // Reset sinyali
    input pc_src,                          // PC seçim sinyali (0: PC+4, 1: branch_addr)
    input [31:0] immExit,              // Branch adresi
    output reg [31:0] pc_out               // Program counter çıktısı
);

    reg [31:0] pc_in;                     // Program counter girişi

    // PC + 4 hesapla
    wire [31:0] pc_plus4, branch_addr;
    assign pc_plus4 = pc_out + 4;
    assign branch_addr = pc_out + immExit;

    // MUX: next PC seçimi
    always @(*) begin
        if (pc_src == 1'b0)
            pc_in = pc_plus4;            // PC + 4 seç
        else
            pc_in = branch_addr;         // Branch adresini seç
    end

    // PC register'ını her pozitif kenarda güncelle
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 32'b0;             // Reset durumunda PC'yi sıfırla
        else
            pc_out <= pc_in;             // pc_in'i PC'ye aktar
    end

endmodule


module instruction_memory (
    input [31:0] address,   // Program Counter'dan gelen adres
    output reg [31:0] data_out // Bellekten okunan komut
);

    // Bellek boyutu, 256 adet 32-bit komut olsun
    reg [31:0] memory [0:255];

    // Belleği başlatmak için bir blok
    initial begin
        $readmemh("riscvtest.txt", RAM);
    end

    // Adrese göre komut okuma işlemi
    always @(*) begin
        // Bellekten veriyi okuma
        data_out = memory[address >> 2]; // Adresin 2'ye bölünüp index olarak kullanılmasını sağla (32-bitlik adres için)
    end
endmodule

