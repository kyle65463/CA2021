module EXMEM
(
    clk_i,
    start_i,
    
    ALUres_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    RS2data_i,
    RDaddr_i,
    
    ALUres_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    RS2data_o,
    RDaddr_o
);

// Ports
input               clk_i;
input               start_i;
input   [31:0]      ALUres_i;
input               RegWrite_i;
input               MemtoReg_i;
input               MemRead_i;
input               MemWrite_i;
input   [31:0]      RS2data_i;
input   [4:0]       RDaddr_i;

output  [31:0]      ALUres_o;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output  [31:0]      RS2data_o;
output  [4:0]       RDaddr_o;

reg     [31:0]       ALUres_o;
reg                 RegWrite_o;
reg                 MemtoReg_o;
reg                 MemRead_o;
reg                 MemWrite_o;
reg     [31:0]      RS2data_o;
reg     [4:0]       RDaddr_o;

always@(posedge clk_i) begin
    if(start_i) begin
        ALUres_o <= ALUres_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        RS2data_o <= RS2data_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule
