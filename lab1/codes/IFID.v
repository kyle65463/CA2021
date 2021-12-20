module IFID
(
    clk_i,
    start_i,

    Stall_i,
    Flush_i,
    pc_i,
    instr_i,

    pc_o,
    instr_o
);

// Ports
input               clk_i;
input               start_i;

input               Stall_i;
input               Flush_i;
input   [31:0]      pc_i;
input   [31:0]      instr_i;

output  [31:0]      pc_o;
output  [31:0]      instr_o;

reg     [31:0]      pc_o;
reg     [31:0]      instr_o;

always@(posedge clk_i or Flush_i) begin
    if(!Stall_i && start_i && !Flush_i) begin
        pc_o <= pc_i;
        instr_o <= instr_i;
    end
end

endmodule
