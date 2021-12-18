module IDEX
(
    clk_i,
    ALUOp_i,
    ALUSrc_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    RS1data_i, 
    RS2data_i,
    funct_i,
    imm32_i,
    RDaddr_i,

    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    RS1data_o, 
    RS2data_o,
    funct_o,
    imm32_o,
    RDaddr_o
);

// Ports
input               clk_i;
input   [1:0]       ALUOp_i;
input               ALUSrc_i;
input               RegWrite_i;
input               MemtoReg_i;
input               MemRead_i;
input               MemWrite_i;
input   [31:0]      RS1data_i; 
input   [31:0]      RS2data_i;
input   [9:0]       funct_i;
input   [31:0]      imm32_i;
input   [4:0]       RDaddr_i;

output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output  [31:0]      RS1data_o; 
output  [31:0]      RS2data_o;
output  [9:0]       funct_o;
output  [31:0]      imm32_o;
output  [4:0]       RDaddr_o;

reg     [1:0]       ALUOp_o;
reg                 ALUSrc_o;
reg                 RegWrite_o;
reg                 MemtoReg_o;
reg                 MemRead_o;
reg                 MemWrite_o;
reg     [31:0]      RS1data_o; 
reg     [31:0]      RS2data_o;
reg     [9:0]       funct_o;
reg     [31:0]      imm32_o;
reg     [4:0]       RDaddr_o;

always@(posedge clk_i) begin
    ALUOp_o <= ALUOp_i;
    ALUSrc_o <= ALUSrc_i;
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    RS1data_o <= RS1data_i;
    RS2data_o <= RS2data_i;
    funct_o <= funct_i;
    imm32_o <= imm32_i;
    RDaddr_o <= RDaddr_i;
end

endmodule
