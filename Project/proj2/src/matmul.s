.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    li t0, 1
    blt a1, t0, exce1 # if a1 < t0 then exce1
    blt a2, t0, exce1 # if a2 < t0 then exce1
    blt a4, t0, exce2 # if a4 < t0 then exce2
    blt a5, t0, exce2 # if a5 < t0 then exce2
    bne a2, a4, exce3 # if a2 != a4 then exce3
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    li t1, 0 # outer_counter -> a1 
    li t2, 0 # inner_counter -> a5

outer_loop_start:
    beq t1, s1, outer_loop_end
inner_loop_start:
    beq t2, s5, inner_loop_end
    # call dot
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s5

    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    jal dot  # jump to dot and save position to ra
    
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 12

    sw a0, 0(s6)
    addi t2, t2, 1
    addi s3, s3, 4
    addi s6, s6, 4
    j inner_loop_start
inner_loop_end:
    li t3, 4
    mul t3, t3, t2
    sub s3, s3, t3
    li t2, 0
    li t3, 4
    mul t3, t3, s2
    add s0, s0, t3
    addi t1, t1, 1
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw ra, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 32
    ret
exce1:
    li a0, 17
    li a1, 72
    ecall
exce2:
    li a0, 17
    li a1, 73
    ecall
exce3:
    li a0, 17
    li a1, 74
    ecall