.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
	addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp) # filename / file description
    sw s1, 8(sp) # rows_pointer
    sw s2, 12(sp) # cols_pointer
    sw s3, 16(sp) # rows
    sw s4, 20(sp) # cols
    sw s5, 24(sp) # mat_pointer
    sw s6, 28(sp) # mat_size

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen
    mv a1, s0
    li a2, 0 # read
    jal fopen
    li t0, -1
    beq a0, t0, exit_open

    # read rows
    mv s0, a0 # file descriptor
    mv a1, s0
    mv a2, s1
    li a3, 4
    jal fread
    li a3, 4
    bne a0, a3, exit_read

    #read cols
    mv a1, s0
    mv a2, s2
    li a3, 4
    jal fread
    li a3, 4
    bne a0, a3, exit_read
    
    #malloc
    lw s3, 0(s1)
    lw s4, 0(s2)
    mul s6, s3, s4 # rows * cols
    slli s6, s6, 2 # bytes of size
    mv a0, s6
    jal malloc
    beq a0, zero, exit_malloc
    mv s5, a0 # mat_pointer

    #read mat
    mv a1, s0
    mv a2, s5
    mv a3, s6
    jal fread
    mv a3, s6
    bne a0, a3, exit_read
    
    #close the file 
    mv a1, s0
    jal fclose
    bne a0, zero, exit_close
    mv a0, s5 # return mat_pointer
    # Epilogue
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32
    ret

exit_open:
    li a1, 90
    jal exit2
exit_read:
    li a1, 91
    jal exit2
exit_malloc:
    li a1, 88
    jal exit2
exit_close:
    li a1, 92
    jal exit2