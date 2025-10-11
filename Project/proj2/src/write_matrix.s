.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp) 
    sw s0, 4(sp) # file name / file descriptor
    sw s1, 8(sp) # mat_pointer
    sw s2, 12(sp) # rows_num
    sw s3, 16(sp) # cols_num
    sw s4, 20(sp) # size

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # fopen
    mv a1, s0
    li a2, 1 # write
    jal fopen
    mv s0, a0 # file descriptor
    li t0, -1
    beq a0, t0, exit_open

    # write rows & cols
    addi sp, sp, -8
    sw s2, 0(sp) # sp->buffer pointer
    sw s3, 4(sp)
    mv a1, s0
    mv a2, sp
    li a3, 2 
    li a4, 4
    jal fwrite
    li a3, 2
    lw s3, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 8
    blt a0, a3, exit_write

    # write mat
    mul s4, s2, s3
    mv a1, s0
    mv a2, s1
    mv a3, s4
    li a4, 4
    jal fwrite
    mv a3, s4
    blt a0, a3, exit_write

    # close
    mv a1, s0
    jal fclose
    bne a0, zero, exit_close
    # Epilogue
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 24
    ret
exit_open:
    li a1, 93
    jal exit2
exit_write:
    li a1, 94
    jal exit2
exit_close:
    li a1, 95
    jal exit2