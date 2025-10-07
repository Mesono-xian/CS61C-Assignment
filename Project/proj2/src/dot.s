.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)

    li t0, 1
    blt a2, t0, exce1
    blt a3, t0, exce2
    blt a4, t0, exce2
    slli a3, a3, 2
    slli a4, a4, 2
    li t1, 0
    mv s0, a0
    mv s1, a1
    li a0, 0
loop_start:
    beq t1, a2, loop_end
    lw s2, 0(s0)
    lw s3, 0(s1)
    mul t2, s2, s3
    add a0, a0, t2
    addi t1, t1, 1
    add s0, s0, a3
    add s1, s1, a4
    j loop_start
loop_end:
    # Epilogue
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 16
    ret
exce1:
    li a0, 17
    li a1, 75
    ecall
exce2:
    li a0, 17
    li a1, 76
    ecall