.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    li t0, 1
    blt a1, t0, handle_exception # if a1 < t0 then handle_exception
    li t1, 0
    mv s0, a0
    li a0, 0
    lw s1, 0(s0)
loop_start:
    beq t1, a1, loop_end
    slli t2, t1, 2
    add t2, s0, t2
    lw t3, 0(t2) # t3 = now,s1 = max
    bge s1, t3, loop_continue
    mv s1, t3
    mv a0, t1
loop_continue:
    addi t1, t1, 1
    j loop_start
loop_end:
    # Epilogue
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    ret
handle_exception:
    li a0, 17
    li a1, 77
    ecall