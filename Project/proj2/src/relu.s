.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    li t0, 1
    blt a1, t0, handle_exception # if a1 < t0 then exit
    li t1, 0
loop_start:
    beq t1, a1, loop_end  # if t1 == a1 then loop_end
    slli t2, t1, 2
    add t2, a0, t2
    lw t3, 0(t2) # the number in a[i]
    bge t3, zero, loop_continue # if t3 >= zero then loop_start
    sw zero, 0(t2)
loop_continue:
    addi t1, t1, 1
    j loop_start
loop_end:
	ret
handle_exception:
    li a0, 17
    li a1, 78
    ecall
