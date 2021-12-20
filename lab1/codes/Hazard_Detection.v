module Hazard_Detection
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
    NoOp_o =    1'b0;
    Stall_o =   1'b0;
    PCWrite_o = 1'b1;
    if (EX_MemRead_i && ((EX_RDaddr_i == RS1addr_i) || (EX_RDaddr_i == RS2addr_i))) begin
        // Stall the pipeline
        NoOp_o =    1'b1;
        Stall_o =   1'b1;
        PCWrite_o = 1'b0;
    end
end

endmodule
