module IFID
(
    clk_i,
    pc_i,
    instr_i,

    pc_o,
    instr_o
);

// Ports
input               clk_i;
input   [31:0]      pc_i;
input   [31:0]      instr_i;

output  [31:0]      pc_o;
output  [31:0]      instr_o;

reg     [31:0]      pc_o;
reg     [31:0]      instr_o;

always@(posedge clk_i) begin
    pc_o <= pc_i;
    instr_o <= instr_i;
end

endmodule
