module MEMWB
(
    clk_i,
    ALUres_i,
    RegWrite_i,
    MemtoReg_i,
    Memdata_i,
    RDaddr_i,
    
    ALUres_o,
    RegWrite_o,
    MemtoReg_o,
    Memdata_o,
    RDaddr_o
);

// Ports
input               clk_i;
input   [31:0]       ALUres_i;
input               RegWrite_i;
input               MemtoReg_i;
input   [31:0]      Memdata_i;
input   [4:0]       RDaddr_i;

output  [31:0]       ALUres_o;
output              RegWrite_o;
output              MemtoReg_o;
output  [31:0]      Memdata_o;
output  [4:0]       RDaddr_o;

reg     [31:0]       ALUres_o;
reg                 RegWrite_o;
reg                 MemtoReg_o;
reg     [31:0]      Memdata_o;
reg     [4:0]       RDaddr_o;

always@(posedge clk_i) begin
    ALUres_o <= ALUres_i;
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    Memdata_o <= Memdata_i;
    RDaddr_o <= RDaddr_i;
end

endmodule
