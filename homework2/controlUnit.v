module controlUnit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7_5,
    input zero,
    output reg PCSrc,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg [2:0] ALUControl
);

    reg Branch;
    reg Jump;

    always @(*) begin
        case(op)
            7'b0000011: begin // lw
                RegWrite = 1;
                ImmSrc = 2'b00;
                ALUSrc = 1;
                MemWrite = 0;
                ResultSrc = 2'b01;
                Branch = 0;
                ALUOp = 2'b00;
                Jump = 0;
            end

            7'b0100011: begin // sw
                RegWrite = 0;
                ImmSrc = 2'b01;
                ALUSrc = 1;
                MemWrite = 1;
                ResultSrc = 2'b00; // farketmez
                Branch = 0;
                ALUOp = 2'b00;
                Jump = 0;
            end

            7'b0110011: begin // R-Type
                RegWrite = 1;
                ImmSrc = 2'b00; // farketmez
                ALUSrc = 0;
                MemWrite = 0;
                ResultSrc = 2'b00;
                Branch = 0;
                ALUOp = 2'b10;
                Jump = 0;
            end

            7'b1100011: begin // beq
                RegWrite = 0;
                ImmSrc = 2'b10;
                ALUSrc = 0;
                MemWrite = 0;
                ResultSrc = 2'b01; // farketmez
                Branch = 1;
                ALUOp = 2'b01;
                Jump = 0;
            end

            7'b0010011: begin // I-Type ALU
                RegWrite = 1;
                ImmSrc = 2'b00;
                ALUSrc = 1; // farketmez
                MemWrite = 0;
                ResultSrc = 2'b00;
                Branch = 0;
                ALUOp = 2'b10;
                Jump = 0;
            end

            7'b1101111: begin // jal
                RegWrite = 1;
                ImmSrc = 2'b11;
                ALUSrc = 1; // farketmez
                MemWrite = 0;
                ResultSrc = 2'b10;
                Branch = 0;
                ALUOp = 2'b00; // farketmez
                Jump = 1;
            end

            default: begin
                RegWrite = 0;
                ImmSrc = 2'b00;
                ALUSrc = 0;
                MemWrite = 0;
                ResultSrc = 2'b00;
                Branch = 0;
                ALUOp = 2'b00;
                Jump = 0;
                PCSrc = 0;
            end        
        endcase
        PCSrc = (zero & Branch) | Jump;
    end

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // lw/sw → add
            2'b01: ALUControl = 3'b001; // beq → sub
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        case ({op[5], funct7_5})
                            2'b00: ALUControl = 3'b000; // add
                            2'b01: ALUControl = 3'b000; // add
                            2'b10: ALUControl = 3'b000; // add
                            2'b11: ALUControl = 3'b001; // sub
                            default: ALUControl = 3'b000;
                        endcase
                    end
                    3'b010: ALUControl = 3'b101; // slt
                    3'b110: ALUControl = 3'b011; // or
                    3'b111: ALUControl = 3'b010; // and
                    default: ALUControl = 3'b000;
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end

endmodule
