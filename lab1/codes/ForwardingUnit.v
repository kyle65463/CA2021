module ForwadingUnit
(
    EX_RS1addr_i,
    EX_RS2addr_i,
    MEM_RegWrite_i,
    MEM_RDaddr_i,
    WB_RegWrite_i,
    WB_RDaddr_i,
    
    ForwardA_o,
    ForwardB_o
);

// Ports
input   [4:0]       EX_RS1addr_i;
input   [4:0]       EX_RS2addr_i;
input               MEM_RegWrite_i;
input   [4:0]       MEM_RDaddr_i;
input               WB_RegWrite_i;
input   [4:0]       WB_RDaddr_i;

output  [1:0]       ForwardA_o;
output  [1:0]       ForwardB_o;

reg     [1:0]       ForwardA_o;
reg     [1:0]       ForwardB_o;

always@(EX_RS1addr_i or EX_RS2addr_i or MEM_RegWrite_i or MEM_RDaddr_i or WB_RegWrite_i or WB_RDaddr_i) begin
    ForwardA_o = 2'b0;
    ForwardB_o = 2'b0;

    // EX Hazard
    if(MEM_RDaddr_i && MEM_RegWrite_i) begin
        if(MEM_RDaddr_i == EX_RS1addr_i)
            ForwardA_o = 2'b10;
        else if(MEM_RDaddr_i == EX_RS2addr_i)
            ForwardB_o = 2'b10;
    end
    else begin
        // MEM Hazard
        if(WB_RDaddr_i && WB_RegWrite_i) begin
            if(MEM_RDaddr_i == EX_RS1addr_i && WB_RDaddr_i == EX_RS1addr_i)
                ForwardA_o = 2'b01;
            else if(MEM_RDaddr_i == EX_RS2addr_i && WB_RDaddr_i == EX_RS2addr_i)
                ForwardB_o = 2'b01;
        end
    end
end

endmodule
