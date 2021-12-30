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
wire     [31:0]     adder_pc_o;
wire     [31:0]     instr_o;

wire     [31:0]     p0_pc_o;
wire     [31:0]     p0_instr_o;

// Control
wire     [1:0]      ALUOp_o;
wire                ALUSrc_o;
wire                RegWrite_o;
wire     [6:0]      Op_i;
wire                MemtoReg_o;
wire                MemRead_o;
wire                MemWrite_o;
wire                Branch_o;

wire     [1:0]      p1_ALUOp_o;
wire                p1_ALUSrc_o;
wire                p1_RegWrite_o;
wire                p1_MemtoReg_o;
wire                p1_MemRead_o;
wire                p1_MemWrite_o;

wire                p2_RegWrite_o;
wire                p2_MemtoReg_o;
wire                p2_MemRead_o;
wire                p2_MemWrite_o;

wire                p3_RegWrite_o;
wire                p3_MemtoReg_o;
wire                p3_MemRead_o;
wire                p3_MemWrite_o;


// Registers
wire     [4:0]      RS1addr_i;
wire     [4:0]      RS2addr_i;
wire     [4:0]      RDaddr_i;
wire     [31:0]     RS1data_o;
wire     [31:0]     RS2data_o;
wire     [31:0]     RDdata_i;

wire     [4:0]      p1_RDaddr_o;
wire     [31:0]     p1_RS1data_o;
wire     [31:0]     p1_RS2data_o;

wire     [4:0]      p2_RDaddr_o;
wire     [31:0]     p2_RS2data_o;

wire     [4:0]      p3_RDaddr_o;

// ALU Control & Sign extend
wire     [2:0]      funct3_i;
wire     [6:0]      funct7_i;
wire     [9:0]      funct_i;
wire     [11:0]     imm12_i;
wire     [31:0]     imm32_o;
wire     [2:0]      ALUCtrl_o;

wire     [31:0]     p1_imm32_o;

// ALU
wire     [31:0]     ALUdata_i;
wire     [31:0]     ALUdata_o;
wire                Zero_o;

wire     [31:0]     p2_ALUres_o;

wire     [31:0]     p3_ALUres_o;

// Data Memory
wire     [31:0]     Memdata_o;

wire     [31:0]     p3_Memdata_o;

assign {RS1addr_i, funct3_i, RDaddr_i, Op_i} = p0_instr_o[19:0];
assign {funct7_i, RS2addr_i}                 = p0_instr_o[31:20];
assign imm12_i =    (Op_i == 7'b0100011) ? {p0_instr_o[31:25], p0_instr_o[11:7]}: // sw
                    (Op_i == 7'b1100011) ? {p0_instr_o[31], p0_instr_o[7], p0_instr_o[30:25], p0_instr_o[11:8]}: // beq
                    p0_instr_o[31:20];
assign funct_i = {funct7_i, funct3_i};

wire     [9:0]      p1_funct_o;
wire     [4:0]      p1_RS1addr_o;
wire     [4:0]      p1_RS2addr_o;

// Forwarding Unit
wire     [1:0]      ForwardA_o;
wire     [1:0]      ForwardB_o;
wire     [31:0]     ForwardAdata_o;
wire     [31:0]     ForwardBdata_o;

// Hazard Detection Unit
wire                NoOp_o;
wire                Stall_o;
wire                PCWrite_o;

// Branch Unit
wire                Flush;
wire     [31:0]     jump_addr_o;

Control Control(
    .Op_i       (Op_i),
    .NoOp_i     (NoOp_o),
    .ALUOp_o    (ALUOp_o),
    .ALUSrc_o   (ALUSrc_o),
    .RegWrite_o (RegWrite_o),
    .MemtoReg_o (MemtoReg_o),
    .MemRead_o  (MemRead_o),
    .MemWrite_o (MemWrite_o),
    .Branch_o (Branch_o)
);

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (32'd4),
    .data_o     (adder_pc_o)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite_o),
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
    .RDaddr_i    (p3_RDaddr_o), 
    .RDdata_i    (RDdata_i),
    .RegWrite_i  (p3_RegWrite_o), 
    .RS1data_o   (RS1data_o), 
    .RS2data_o   (RS2data_o)
);

MUX32 MUX_ALUSrc(
    .data1_i    (ForwardBdata_o),
    .data2_i    (p1_imm32_o),
    .select_i   (p1_ALUSrc_o),
    .data_o     (ALUdata_i)
);

Sign_Extend Sign_Extend(
    .data_i     (imm12_i),
    .data_o     (imm32_o)
);
  
ALU ALU(
    .data1_i    (ForwardAdata_o),
    .data2_i    (ALUdata_i),
    .ALUCtrl_i  (ALUCtrl_o),
    .data_o     (ALUdata_o),
    .Zero_o     (Zero_o)
);

ALU_Control ALU_Control(
    .funct_i    (p1_funct_o),
    .ALUOp_i    (p1_ALUOp_o),
    .ALUCtrl_o  (ALUCtrl_o)
);

Data_Memory Data_Memory(
    .clk_i       (clk_i), 
    .addr_i      (p2_ALUres_o), 
    .MemRead_i   (p2_MemRead_o),
    .MemWrite_i  (p2_MemWrite_o),
    .data_i      (p2_RS2data_o),
    .data_o      (Memdata_o)
);

MUX32 MUX_WriteSrc(
    .data1_i    (p3_ALUres_o),
    .data2_i    (p3_Memdata_o),
    .select_i   (p3_MemtoReg_o),
    .data_o     (RDdata_i)
);

IFID IFID(
    .clk_i      (clk_i),
    .start_i    (start_i),
    
    .Stall_i    (Stall_o),
    .Flush_i    (Flush),
    .pc_i       (pc_o),
    .instr_i    (instr_o),

    .pc_o       (p0_pc_o),
    .instr_o    (p0_instr_o)
);

IDEX IDEX(
    .clk_i      (clk_i),
    .start_i    (start_i),

    .ALUOp_i    (ALUOp_o),
    .ALUSrc_i   (ALUSrc_o),
    .RegWrite_i (RegWrite_o),
    .MemtoReg_i (MemtoReg_o),
    .MemRead_i  (MemRead_o),
    .MemWrite_i (MemWrite_o),
    .RS1addr_i  (RS1addr_i), 
    .RS2addr_i  (RS2addr_i),
    .RS1data_i  (RS1data_o), 
    .RS2data_i  (RS2data_o),
    .funct_i    (funct_i),
    .imm32_i    (imm32_o),
    .RDaddr_i   (RDaddr_i),

    .ALUOp_o    (p1_ALUOp_o),
    .ALUSrc_o   (p1_ALUSrc_o),
    .RegWrite_o (p1_RegWrite_o),
    .MemtoReg_o (p1_MemtoReg_o),
    .MemRead_o  (p1_MemRead_o),
    .MemWrite_o (p1_MemWrite_o),
    .RS1addr_o  (p1_RS1addr_o), 
    .RS2addr_o  (p1_RS2addr_o),
    .RS1data_o  (p1_RS1data_o), 
    .RS2data_o  (p1_RS2data_o),
    .funct_o    (p1_funct_o),
    .imm32_o    (p1_imm32_o),
    .RDaddr_o   (p1_RDaddr_o)
);

EXMEM EXMEM(
    .clk_i      (clk_i),
    .start_i    (start_i),

    .ALUres_i   (ALUdata_o),
    .RegWrite_i (p1_RegWrite_o),
    .MemtoReg_i (p1_MemtoReg_o),
    .MemRead_i  (p1_MemRead_o),
    .MemWrite_i (p1_MemWrite_o),
    .RS2data_i  (ForwardBdata_o),
    .RDaddr_i   (p1_RDaddr_o),

    .ALUres_o   (p2_ALUres_o),
    .RegWrite_o (p2_RegWrite_o),
    .MemtoReg_o (p2_MemtoReg_o),
    .MemRead_o  (p2_MemRead_o),
    .MemWrite_o (p2_MemWrite_o),
    .RS2data_o  (p2_RS2data_o),
    .RDaddr_o   (p2_RDaddr_o)
);

MEMWB MEMWB(
    .clk_i      (clk_i),
    .start_i    (start_i),

    .ALUres_i   (p2_ALUres_o),
    .RegWrite_i (p2_RegWrite_o),
    .MemtoReg_i (p2_MemtoReg_o),
    .Memdata_i  (Memdata_o),
    .RDaddr_i   (p2_RDaddr_o),

    .ALUres_o   (p3_ALUres_o),
    .RegWrite_o (p3_RegWrite_o),
    .MemtoReg_o (p3_MemtoReg_o),
    .Memdata_o  (p3_Memdata_o),
    .RDaddr_o   (p3_RDaddr_o)
);

ForwadingUnit ForwadingUnit(
    .EX_RS1addr_i   (p1_RS1addr_o),
    .EX_RS2addr_i   (p1_RS2addr_o),
    .MEM_RegWrite_i (p2_RegWrite_o),
    .MEM_RDaddr_i   (p2_RDaddr_o),
    .WB_RegWrite_i  (p3_RegWrite_o),
    .WB_RDaddr_i    (p3_RDaddr_o),
    
    .ForwardA_o     (ForwardA_o),
    .ForwardB_o     (ForwardB_o)
);

MUX32W MUX_ForwardA(
    .data1_i    (p1_RS1data_o),
    .data2_i    (RDdata_i),
    .data3_i    (p2_ALUres_o),
    .select_i   (ForwardA_o),
    .data_o     (ForwardAdata_o)
);

MUX32W MUX_ForwardB(
    .data1_i    (p1_RS2data_o),
    .data2_i    (RDdata_i),
    .data3_i    (p2_ALUres_o),
    .select_i   (ForwardB_o),
    .data_o     (ForwardBdata_o)
);

Hazard_Detection Hazard_Detection(
    .RS1addr_i      (RS1addr_i),
    .RS2addr_i      (RS2addr_i),
    .EX_MemRead_i   (p1_MemRead_o),
    .EX_RDaddr_i    (p1_RDaddr_o),
    
    .NoOp_o         (NoOp_o),
    .Stall_o        (Stall_o),
    .PCWrite_o      (PCWrite_o)
);

Branch_Unit Branch_Unit(
    .RS1data_i      (RS1data_o),
    .RS2data_i      (RS2data_o),
    .Branch_i       (Branch_o),
    .ID_pc_i        (p0_pc_o),
    .imm32_i        (imm32_o),
    
    .Flush_o        (Flush),
    .jump_addr_o    (jump_addr_o)
);

MUX32 MUX_PC(
    .data1_i    (adder_pc_o),
    .data2_i    (jump_addr_o),
    .select_i   (Flush),
    .data_o     (pc_i)
);

endmodule

