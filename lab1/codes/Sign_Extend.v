module Sign_Extend
(
    data_i,
    data_o
);

// Ports
input   [11:0]       data_i;
output  [31:0]       data_o;

assign data_o = {{20{data_i[11]}}, data_i[11:0]};

endmodule
