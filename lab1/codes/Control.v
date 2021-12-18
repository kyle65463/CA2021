module Control
(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

// Ports
input   [6:0]       Op_i;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;

assign ALUOp_o =    (Op_i == 7'b0010011) ? 2'b00: // I-type
                    (Op_i == 7'b0110011) ? 2'b10: // R-type
                    2'bx;
assign ALUSrc_o =   (Op_i == 7'b0010011) ? 1'b1: // I-type -> use immediate
                    (Op_i == 7'b0110011) ? 1'b0: // R-type -> use RS2
                    1'bx;
assign RegWrite_o = (Op_i == 7'b0010011) ? 1'b1: // I-type
                    (Op_i == 7'b0110011) ? 1'b1: // R-type
                    1'bx;

endmodule
