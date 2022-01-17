module Branch_Unit
(
    RS1data_i,
    RS2data_i,
    Branch_i,
    ID_pc_i,
    imm32_i,
    
    Flush_o,
    jump_addr_o,
);

// Ports
input   [31:0]      RS1data_i;
input   [31:0]      RS2data_i;
input               Branch_i;
input   [31:0]      ID_pc_i;
input   [31:0]      imm32_i;

output              Flush_o;
output  [31:0]      jump_addr_o;

reg                 Flush_o;

assign jump_addr_o = ID_pc_i + (imm32_i << 1); 

always@(RS1data_i or RS2data_i or Branch_i or ID_pc_i or imm32_i) begin
    Flush_o = 0;
    if(RS1data_i == RS2data_i && Branch_i) begin
        Flush_o = 1;
    end
end

endmodule
