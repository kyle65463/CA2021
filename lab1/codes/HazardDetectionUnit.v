module HazardDetectionUnit
(
    RS1addr_i,
    RS2addr_i,
    EX_MemRead_i,
    EX_RDaddr_i,
    
    NoOp_o,
    Stall_o,
    PCWrite_o
);

// Ports
input   [4:0]       RS1addr_i;
input   [4:0]       RS2addr_i;
input               EX_MemRead_i;
input   [4:0]       EX_RDaddr_i;

output              NoOp_o;
output              Stall_o;
output              PCWrite_o;

reg                 NoOp_o;
reg                 Stall_o;
reg                 PCWrite_o;

always@(RS1addr_i or RS2addr_i or EX_MemRead_i or EX_RDaddr_i) begin
    // NoOp_o = 2'b0;
    // Stall_o = 2'b0;

    // // EX Hazard
    // if(EX_RDaddr_i && EX_MemRead_i) begin
    //     if(EX_RDaddr_i == RS1addr_i)
    //         NoOp_o = 2'b10;
    //     else if(EX_RDaddr_i == RS1addr_i)
    //         Stall_o = 2'b10;
    // end
    // else begin
    //     // MEM Hazard
    //     if(WB_RDaddr_i && WB_RegWrite_i) begin
    //         if(EX_RDaddr_i == RS1addr_i && WB_RDaddr_i == RS1addr_i)
    //             NoOp_o = 2'b01;
    //         else if(EX_RDaddr_i == RS1addr_i && WB_RDaddr_i == RS1addr_i)
    //             Stall_o = 2'b01;
    //     end
    // end
end

endmodule
