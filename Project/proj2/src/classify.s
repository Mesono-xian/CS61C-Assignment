.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>






	# =====================================
    # LOAD MATRICES
    # =====================================
    li t0, 5
    bne a0, t0, exit_args

    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Load pretrained m0 -> argv[1]
    lw a0, 4(s1) # m0 filename
    addi sp, sp, -8
    mv a1, sp # rows_pointer
    addi a2, a1, 4 # cols_pointer
    jal read_matrix
    mv s3, a0 # m0_pointer

    # Load pretrained m1
    lw a0, 8(s1) # m0 filename
    addi sp, sp, -8
    mv a1, sp # rows_pointer
    addi a2, a1, 4 # cols_pointer
    jal read_matrix
    mv s4, a0 # m1_pointer

    # Load input matrix
    lw a0, 12(s1) # m0 filename
    addi sp, sp, -8
    mv a1, sp # rows_pointer
    addi a2, a1, 4 # cols_pointer
    jal read_matrix
    mv s5, a0 # mat_input_pointer


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    d = m0 * input
    ## malloc for d
    lw a0, 16(sp)
    lw t0, 4(sp)
    mul a0, a0, t0
    slli a0, a0, 2
    jal malloc
    beq a0, zero, exit_malloc
    mv s6, a0

    ## load args
    mv a0, s3 # m0_pointer
    lw a1, 16(sp) # m0_rows
    lw a2, 20(sp) # m0_cols
    mv a3, s5 # input_pointer
    lw a4, 0(sp) # input_rows
    lw a5, 4(sp) # input_cols
    mv a6, s6
    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s6
    lw a1, 16(sp)
    lw t0, 4(sp)
    mul a1, a1, t0
    jal relu

    # 3. LINEAR LAYER:   m = m1 * ReLU(m0 * input)
    ## malloc for m
    lw a0, 8(sp)
    lw t0, 4(sp)
    mul a0, a0, t0
    slli a0, a0, 2
    jal malloc
    beq a0, zero, exit_malloc
    mv s7, a0

    ## load args
    mv a0, s4 # m1_pointer
    lw a1, 8(sp) # m0_rows
    lw a2, 12(sp) # m0_cols
    mv a3, s6 # d_pointer
    lw a4, 16(sp) # d_rows
    lw a5, 4(sp) # d_cols
    mv a6, s7
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s7
    lw a2, 8(sp)
    lw a3, 4(sp)
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s7
    lw a1, 8(sp)
    lw t0, 4(sp)
    mul a1, a1, t0
    jal argmax
    mv t1, a0

    # Print classification
    bne s2, zero, else
    mv a1, t1
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

else:
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    addi sp, sp, 24
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp) 
    addi sp, sp, 36
    ret
exit_args:
    li a1, 89
    jal exit2
exit_malloc:
    li a1, 88
    jal exit2