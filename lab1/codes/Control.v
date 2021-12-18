module Control
(
    Op_i,
    NoOp_i,
    
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

// Ports
input   [6:0]       Op_i;
input               NoOp_i;

output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output              Branch_o;

`define LOAD    7'b0000011
`define STORE   7'b0100011
`define BRANCH  7'b1100011

assign ALUOp_o =    (Op_i == 7'b0010011) ? 2'b00: // I-type
                    (Op_i == 7'b0110011) ? 2'b10: // R-type
                    (Op_i == 7'b0000011) ? 2'b00: // lw
                    (Op_i == 7'b0100011) ? 2'b00: // sw
                    (Op_i == 7'b1100011) ? 2'b10: // beq
                    2'bx;
assign ALUSrc_o =   (Op_i == 7'b0010011) ? 1'b1: // I-type -> use immediate
                    (Op_i == 7'b0110011) ? 1'b0: // R-type -> use RS2
                    (Op_i == 7'b0000011) ? 1'b1: // lw     -> use immediate
                    (Op_i == 7'b0100011) ? 1'b1: // sw     -> use immediate
                    (Op_i == 7'b1100011) ? 1'b0: // beq    -> use RS2
                    1'bx;
// Except for beq and sw are true
assign RegWrite_o = NoOp_i               ? 1'b0:
                    (Op_i == 7'b0010011) ? 1'b1: // I-type
                    (Op_i == 7'b0110011) ? 1'b1: // R-type
                    (Op_i == 7'b0000011) ? 1'b1: // lw
                    (Op_i == 7'b0100011) ? 1'b0: // sw
                    (Op_i == 7'b1100011) ? 1'b0: // beq
                    1'bx;

assign MemtoReg_o = NoOp_i ? 1'b0 : Op_i == `LOAD   ? 1'b1 : 1'b0; // Only lw instruction
assign MemRead_o =  NoOp_i ? 1'b0 : Op_i == `LOAD   ? 1'b1 : 1'b0; // Only lw instruction 
assign MemWrite_o = NoOp_i ? 1'b0 : Op_i == `STORE  ? 1'b1 : 1'b0; // Only sw instruction
assign Branch_o =   NoOp_i ? 1'b0 : Op_i == `BRANCH ? 1'b1 : 1'b0; // Only beq instruction

endmodule
