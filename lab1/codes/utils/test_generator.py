import random

inst_list = ['and', 'sll', 'add', 'sub', 'mul', 'addi', 'srai', 'lw', 'sw', 'beq']
# inst_list = ['add']

def tohex(x):
    return f'x{x}'

def rand_operands(imm=False, branch=False):
    a = random.randint(0, 31)
    b = random.randint(0, 31) 
    if imm and not branch:
        c = random.randint(0, 63) - 32
    else:
        c = random.randint(2, 6) * 2
    return [tohex(a), tohex(b), tohex(c) if not imm else str(c)]

def rand_instuction(last_operands, last2_operands):
    inst = random.choice(inst_list)
    if inst in ['and', 'xor', 'sll', 'add', 'sub', 'mul']:
        operands = rand_operands()
    else:
        if inst in ['lw', 'sw']:
            addr = random.randint(0, 31)
            imm = random.randint(0, 6) * 4
            return f'{inst} x{addr} {imm}(x0)', [f'x{addr}', 'x0']
        if inst in ['beq']:
            operands = rand_operands(imm=True, branch=True)
            i = 0
            while operands[0] == last_operands[0] or operands[1] == last_operands[1] or operands[0] == last2_operands[0] or operands[1] == last2_operands[1]:
                i += 1
                operands = rand_operands(imm=True, branch=True)
        else:
            operands = rand_operands(imm=True) 
    return f'{inst} {" ".join(operands)}', operands

last_operands = ['', '']
last2_operands = ['', '']
for i in range(200):
    inst, operands = rand_instuction(last_operands, last2_operands)
    last2_operands = last_operands
    last_operands = operands
    print(inst)
