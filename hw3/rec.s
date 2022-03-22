.globl __start

.text
__start:
  addi sp, sp, -820
  mv a3, sp # seq[205]
  li a4, 0 # seq_len = 0
  jal ra, scan
  mv s11, a0 # n
  mv a2, a0
  jal ra, rec # recaman(n, seq, &seq_len)
  slli s11, s11, 2 # n << 2
  add s11, s11, a3
  lw a1, 0(s11) # seq[n]
  jal ra, print
  jal zero, exit
  
# params: n (a2), seq (a3), seq_len (a4)
# return: res (a0)
rec:
  addi sp, sp, -12
  sw ra, 0(sp)
  li s3, 0
  bne a2, s3, n_else # if(n == 0)
n_eq_zero:  
  li a0, 0 # res = 0
  jal zero, add_to_seq
n_else:
  sw a2, 4(sp)
  addi a2, a2, -1
  jal ra, rec # t = recaman(n - 1, seq, &seq_len)
  lw a2, 4(sp)
  sub s0, a0, a2 # a = t - n
  add s1, a0, a2 # b = t + n
  li s2, 1
  ble s0, s2, a_else
a_gt_zero:
  # res(a0), a (s0), b (s1), i (s2)
  li s2, 0 # i = 0
for:
  slli s3, s2, 2
  add s3, s3, a3
  lw s4, 0(s3) # seq[i]
  bne s4, s0 for_end # seq[i] == a
  mv a0, s1 # res = b
  jal zero, add_to_seq
for_end:
  addi s2, s2, 1 # i++
  blt s2, a4, for # i < *seq_len
  mv a0, s0 # res = a
  jal zero, add_to_seq
a_else:
  mv a0, s1 # res = b
add_to_seq:
  slli s0, a4, 2
  add s0, s0, a3
  sw a0, 0(s0) # seq[*seq_len] = res;
  addi a4, a4 1
  # Return
  lw ra, 0(sp)
  addi sp, sp, 12
  jalr zero, 0(ra)
  
# params: none
# return: input (a0)
scan:
  # Read value to a0
  li a0, 5
  ecall
  jalr zero, 0(ra)

# params: output (a1)
# return: none
print:
  # Print value from a1
  li a0, 1
  ecall
  jalr zero, 0(ra)

exit:
  li a0, 10
  ecall