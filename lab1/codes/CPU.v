module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// PC & Instruction memory
wire     [31:0]     pc_i;
wire     [31:0]     pc_o;
wire     [31:0]     instr_o;

// Control
wire     [1:0]      ALUOp_o;
wire                ALUSrc_o;
wire                RegWrite_o;
wire     [6:0]      Op_i;
wire                MemtoReg_o;
wire                MemRead_o;
wire                MemWrite_o;

// Registers
wire     [4:0]      RS1addr_i;
wire     [4:0]      RS2addr_i;
wire     [4:0]      RDaddr_i;
wire     [31:0]     RS1data_o;
wire     [31:0]     RS2data_o;
wire     [31:0]     RDdata_i;

// ALU Control & Sign extend
wire     [2:0]      funct3_i;
wire     [6:0]      funct7_i;
wire     [9:0]      funct_i;
wire     [11:0]     imm12_i;
wire     [31:0]     imm32_o;
wire     [2:0]      ALUCtrl_o;

// ALU
wire     [31:0]     ALUdata_i;
wire     [31:0]     ALUdata_o;
wire                Zero_o;

// Data Memory
wire     [31:0]     data_o;

assign {RS1addr_i, funct3_i, RDaddr_i, Op_i} = instr_o[19:0];
assign {funct7_i, RS2addr_i}                 = instr_o[31:20];
assign imm12_i =    (Op_i == 7'b0100011) ? {instr_o[31:25], instr_o[11:7]}: // sw
                    (Op_i == 7'b1100011) ? {instr_o[31], instr_o[7], instr_o[30:20], instr_o[11:8], 1'b0}: // beq
                    instr_o[31:20];
assign funct_i = {funct7_i, funct3_i};

Control Control(
    .Op_i       (Op_i),
    .ALUOp_o    (ALUOp_o),
    .ALUSrc_o   (ALUSrc_o),
    .RegWrite_o (RegWrite_o),
    .MemtoReg_o (MemtoReg_o),
    .MemRead_o  (MemRead_o),
    .MemWrite_o (MemWrite_o)
);

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (32'd4),
    .data_o     (pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (1'b1),
    .pc_i       (pc_i),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instr_o)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (RS1addr_i),
    .RS2addr_i   (RS2addr_i),
    .RDaddr_i    (RDaddr_i), 
    .RDdata_i    (RDdata_i),
    .RegWrite_i  (RegWrite_o), 
    .RS1data_o   (RS1data_o), 
    .RS2data_o   (RS2data_o)
);

MUX32 MUX_ALUSrc(
    .data1_i    (RS2data_o),
    .data2_i    (imm32_o),
    .select_i   (ALUSrc_o),
    .data_o     (ALUdata_i)
);

Sign_Extend Sign_Extend(
    .data_i     (imm12_i),
    .data_o     (imm32_o)
);
  
ALU ALU(
    .data1_i    (RS1data_o),
    .data2_i    (ALUdata_i),
    .ALUCtrl_i  (ALUCtrl_o),
    .data_o     (ALUdata_o),
    .Zero_o     (Zero_o)
);

ALU_Control ALU_Control(
    .funct_i    (funct_i),
    .ALUOp_i    (ALUOp_o),
    .ALUCtrl_o  (ALUCtrl_o)
);

Data_Memory Data_Memory(
    .clk_i       (clk_i), 
    .addr_i      (ALUdata_o), 
    .MemRead_i   (MemRead_o),
    .MemWrite_i  (MemWrite_o),
    .data_i      (RS2data_o),
    .data_o      (data_o)
);

MUX32 MUX_WriteSrc(
    .data1_i    (ALUdata_o),
    .data2_i    (data_o),
    .select_i   (MemtoReg_o),
    .data_o     (RDdata_i)
);

endmodule

