from math import factorial
import subprocess
from subprocess import PIPE, STDOUT
from random import randint
from tqdm import tqdm

testing = ['addition', 'substraction', 'multiplication', 
           'division', 'remainder', 'power', 'factorial']
opr = "+-*/%^!"
for op in range(7):
    print(f"#### TESTING {testing[op].upper()} ####")
    for i in tqdm(range(10)):
        a, b, ans = randint(0, 1024), randint(1, 1024), 0
        # if i == 0:
        #     b = 0
        if op == 0:
            ans = a + b
        elif op == 1:
            ans = a - b
        elif op == 2:
            ans = a * b
        elif op == 3:
            ans = a // b
        elif op == 4:
            ans = a % b
        elif op == 5:
            ans = a ** b
            while ans >= 2147483647:
                a, b = randint(0, 1024), randint(1, 10)
                ans = a ** b
        else:
            a = randint(0, 12)
            ans = factorial(a)
            b = 0
        p = subprocess.Popen(['jupiter', 'b08902003_hw2.s'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
        out, err = p.communicate(input=f'{a}\n{op}\n{b}\n'.encode())
        p.kill()
        cal = int(str(out.decode("ASCII")).split('\n')[0])
        if cal != ans:
            if op != 6:
                print(f'{testing[op]} error: {a} {opr[op]} {b} != {cal}.')
            else:
                print(f'{testing[op]} error: {a}! != {cal}.')
            exit(-1)

print('Testing Successfully.')
