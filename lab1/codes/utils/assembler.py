import sys

def tobin(x, n=5): 
    return ''.join(reversed( [str((x >> i) & 1) for i in range(n)] ) )

table = {
    'and': {
        'opcode': '0110011',
        'funct3': '111',
        'funct7': '0000000',
    },
    'xor': {
        'opcode': '0110011',
        'funct3': '100',
        'funct7': '0000000',
    },
    'sll': {
        'opcode': '0110011',
        'funct3': '001',
        'funct7': '0000000',
    },
    'add': {
        'opcode': '0110011',
        'funct3': '000',
        'funct7': '0000000',
    },
    'sub': {
        'opcode': '0110011',
        'funct3': '000',
        'funct7': '0100000',
    },
    'mul': {
        'opcode': '0110011',
        'funct3': '000',
        'funct7': '0000001',
    },
    'addi': {
        'opcode': '0010011',
        'funct3': '000',
    },
    'srai': {
        'opcode': '0010011',
        'funct3': '101',
        'funct7': '0100000',
    },
    'lw': {
        'opcode': '0000011',
        'funct3': '010',
    },
    'sw': {
        'opcode': '0100011',
        'funct3': '010',
    },
    'beq': {
        'opcode': '1100011',
        'funct3': '000',
    },
}

def parse(operator, operands):
    opcode = table[operator]['opcode']
    if operator in ['and', 'xor', 'sll', 'add', 'sub', 'mul']:
        rd = tobin(int(operands[0]))
        rs1 = tobin(int(operands[1]))
        rs2 = tobin(int(operands[2]))
        funct3 = table[operator]['funct3']
        funct7 = table[operator]['funct7']
        return f'{funct7}_{rs2}_{rs1}_{funct3}_{rd}_{opcode}'
    if operator == 'addi':
        rd = tobin(int(operands[0]))
        rs1 = tobin(int(operands[1]))
        imm = tobin(int(operands[2]), 12)
        funct3 = table[operator]['funct3']
        return f'{imm}_{rs1}_{funct3}_{rd}_{opcode}'
    if operator == 'srai':
        rd = tobin(int(operands[0]))
        rs1 = tobin(int(operands[1]))
        imm = tobin(int(operands[2]), 5)
        funct3 = table[operator]['funct3']
        funct7 = table[operator]['funct7']
        return f'{funct7}_{imm}_{rs1}_{funct3}_{rd}_{opcode}'
    if operator == 'lw':
        rd = tobin(int(operands[0]))
        imm = tobin(int(operands[1]), 12)
        rs1 = tobin(int(operands[2]))
        funct3 = table[operator]['funct3']
        return f'{imm}_{rs1}_{funct3}_{rd}_{opcode}'
    if operator == 'sw':
        rs2 = tobin(int(operands[0]))
        imm = tobin(int(operands[1]), 12)
        rs1 = tobin(int(operands[2]))
        funct3 = table[operator]['funct3']
        return f'{imm[:7]}_{rs2}_{rs1}_{funct3}_{imm[7:12]}_{opcode}'
    if operator == 'beq':
        rs1 = tobin(int(operands[0]))
        rs2 = tobin(int(operands[1]))
        imm = tobin(int(operands[2]), 12)
        funct3 = table[operator]['funct3']
        return f'{imm[0]}_{imm[1:7]}_{rs2}_{rs1}_{funct3}_{imm[7:11]}_{imm[1]}_{opcode}'
    return ''
        
with open(sys.argv[1], 'r') as f:
    lines = f.readlines()

for line in lines:
    line = line.strip().replace(',', ' ').replace('x', '').replace('(', ' ').replace(')', ' ').split()
    operator = line[0]
    operands = line[1:]
    res = parse(operator, operands)
    if res:
        print(res)
