from math import factorial
import subprocess
from subprocess import PIPE, STDOUT
import os
from random import randint
from tqdm import tqdm
import datetime
a = datetime.datetime.now()

# put your file name here
hw3 = ['b089020_hw3_fibonacci.s', 'b089020_hw3_recaman.s']
testing = ['fibonacci', 'recaman']
f_arr = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144,  233, 377, 610]
r_arr = [0, 1, 3, 6, 2, 7, 13, 20, 12, 21, 11, 22, 10, 23, 9, 24, 8, 25, 43, 62, 42, 63, 41, 18, 42, 17, 43, 16, 44, 15, 45, 14, 46, 79, 113, 78, 114, 77, 39, 78, 38, 79, 37, 80, 36, 81, 35, 82, 34, 83, 33, 84, 32, 85, 31, 86, 30, 87, 29, 88, 28, 89, 27, 90, 26, 91, 157, 224, 156, 225, 155, 226, 154, 227, 153, 228, 152, 75, 153, 74, 154, 73, 155, 72, 156, 71, 157, 70, 158, 69, 159, 68, 160, 67, 161, 66, 162, 65, 163, 64, 164, 265, 367, 264, 368, 263, 369, 262, 370, 261, 151, 40, 152, 265, 379, 494, 378, 495, 377, 258, 138, 259, 137, 260, 136, 261, 135, 262, 134, 5, 135, 4, 136, 269, 403, 268, 132, 269, 131, 270, 130, 271, 129, 272, 128, 273, 127, 274, 126, 275, 125, 276, 124, 277, 123, 278, 122, 279, 121, 280, 120, 281, 119, 282, 118, 283, 117, 284, 116, 285, 115, 286, 458, 631, 457, 632, 456, 633, 455, 634, 454, 635, 453, 636, 452, 267, 453, 266, 454, 643, 833, 642, 450, 257, 451, 256, 60, 257, 59, 258]
two_arr = [f_arr, r_arr]

for op in range(2):
    print(f"#### TESTING {testing[op]} ####")
    for i in tqdm(range(0, len(two_arr[op]))):
        ans = two_arr[op][i]
        p = subprocess.Popen(['jupiter', hw3[op]], stdin=PIPE, stdout=PIPE, stderr=PIPE)
        out, err = p.communicate(input=f'{i}\n\n'.encode())
        p.kill()
        cal = int(str(out.decode("ASCII")).split('\n')[0])
        if cal != ans:
             print(f'error: {testing[op]}[{i}] == {ans} != {cal}.')
             exit(-1)
    print(f"testing {testing[op]} successfully ")
