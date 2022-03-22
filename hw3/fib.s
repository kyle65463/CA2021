.globl __start

.text
__start:
  jal ra, scan
  mv a2, a0
  jal ra, fib
  mv a1, a0
  jal ra, print
  jal zero, exit

# params: n (a2)
# return: val (a0)
fib:
  li s3, 0
  beq a2, s3, n_eq_zero # n == 0
  li s3, 1
  beq a2, s3, n_eq_one # n == 1
  
  # Allocate stack
  addi sp, sp, -12
  sw ra, 0(sp)
  sw a2, 4(sp)
  
  # Fib n-1
  addi a2, a2, -1
  jal ra, fib
  mv s0, a0
  sw s0, 8(sp)
  
  # Fib n-2
  lw a2, 4(sp)
  addi a2, a2, -2 
  jal ra, fib
  mv s1, a0
  
  # Combine result
  lw s0, 8(sp)
  add a0, s0, s1
  
  # Return
  lw ra, 0(sp)
  addi sp, sp, 12
  jalr zero, 0(ra)
n_eq_zero:  
  li a0, 0
  jalr zero, 0(ra)
n_eq_one:
  li a0, 1
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