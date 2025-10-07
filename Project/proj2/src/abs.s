.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue
    # ABS  
    bge a0, zero, finish # if a0 >= zero then finish
    sub a0, zero, a0 # a0 = zero - a0
    # Epilogue
finish:
    ret
