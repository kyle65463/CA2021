.globl __start

.rodata
    division_by_zero: .string "division by zero"
    remainder_by_zero: .string "remainder by zero"

.data
  jump_table: .word addition, minus, multiply, divide, modular, power, factorial

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
    # Calculate and output
    mv s3, s0
    jal x1, calculate
    jal zero, output

# operation = op = s1
calculate:
  # Locate memory
  addi sp, sp, -4
  sw x1, 0(sp)
  # Check 0 <= op < 7 
  blt s1, zero, exit
  slti x5, s1, 7
  beq x5, zero, exit
  # Get function address
  la x28, jump_table
  slli x5, s1, 2
  add x6, x5, x28
  lw x7, 0(x6)
  # Get calculated result
  jalr x1, 0(x7)
  # Return
  lw x1, 0(sp)
  addi sp, sp, 4
  jalr zero, 0(x1)

# operands: s0, s2
addition:
  add s3, s0, s2
  jalr zero, 0(x1)

minus: 
  sub s3, s0, s2
  jalr zero, 0(x1)

multiply: 
  mul s3, s0, s2
  jalr zero, 0(x1)

divide: 
  beq s2, zero, division_by_zero_except
  div s3, s0, s2
  jalr zero, 0(x1)

modular:
  beq s2, zero, division_by_zero_except
  div s3, s0, s2
  mul s3, s2, s3
  sub s3, s0, s3
  jalr zero, 0(x1) 

# s2 = n
power:
  # n == 0
  beq s2, zero, power_zero
  # n == 1
  li x5, 1
  beq s2, x5, power_one
  # n > 1
  addi sp, sp, -4
  sw x1, 0(sp)
  mul s3, s0, s3
  li x5, 1
  sub s2, s2, x5
  jal x1, power
  lw x1, 0(sp)
  addi sp, sp, 4
  jalr zero, 0(x1)
power_one:
  # return s3
  jalr zero, 0(x1)
power_zero:
  # return 1
  li s3, 1
  jalr zero, 0(x1)

# s2 = n
factorial:
  # n == 0 (initial case, set s2 = s0 - 1)
  beq s2, zero, factorial_zero
  # n == 1
  li x5, 1 
  beq s2, x5, factorial_one
  # n > 1
  addi sp, sp, -4
  sw x1, 0(sp)
  mul s3, s3, s2
  li x5, 1 
  sub s2, s2, x5
  jal x1, factorial
  lw x1, 0(sp)
  addi sp, sp, 4
  jalr zero, 0(x1)
factorial_one:
  # return s3
  jalr zero, 0(x1)
factorial_zero:
  # initial case
  mv s2, s0
  li x5, 1 
  sub s2, s2, x5
  ble s2, zero, factorial_base
  addi sp, sp, -4
  sw x1, 0(sp)
  jal x1, factorial
  lw x1, 0(sp)
  addi sp, sp, 4
  jalr zero, 0(x1)
factorial_base:
  li s3, 1
  jalr zero, 0(x1)

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit

remainder_by_zero_except:
    li a0, 4
    la a1, remainder_by_zero
    ecall
    jal zero, exit
