module Control
(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o
);

// Ports
input   [6:0]       Op_i;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;

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
assign RegWrite_o = (Op_i == 7'b0010011) ? 1'b1: // I-type
                    (Op_i == 7'b0110011) ? 1'b1: // R-type
                    (Op_i == 7'b0000011) ? 1'b1: // lw
                    (Op_i == 7'b0100011) ? 1'b0: // sw
                    (Op_i == 7'b1100011) ? 1'b0: // beq
                    1'bx;
// Only lw instruction is true
assign MemtoReg_o = (Op_i == 7'b0010011) ? 2'b0: // I-type
                    (Op_i == 7'b0110011) ? 2'b0: // R-type
                    (Op_i == 7'b0000011) ? 1'b1: // lw
                    (Op_i == 7'b0100011) ? 1'b0: // sw
                    (Op_i == 7'b1100011) ? 1'b0: // beq
                    2'bx;
// Only lw instruction is true
assign MemRead_o =  (Op_i == 7'b0010011) ? 1'b0: // I-type
                    (Op_i == 7'b0110011) ? 1'b0: // R-type
                    (Op_i == 7'b0000011) ? 1'b1: // lw
                    (Op_i == 7'b0100011) ? 1'b0: // sw
                    (Op_i == 7'b1100011) ? 1'b0: // beq
                    1'bx;
// Only sw instruction is true
assign MemWrite_o = (Op_i == 7'b0010011) ? 1'b0: // I-type
                    (Op_i == 7'b0110011) ? 1'b0: // R-type
                    (Op_i == 7'b0000011) ? 1'b0: // lw
                    (Op_i == 7'b0100011) ? 1'b1: // sw
                    (Op_i == 7'b1100011) ? 1'b0: // beq
                    1'bx;

endmodule
