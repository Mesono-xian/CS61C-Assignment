#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"
#define reg(x) get_bit(*reg,x)
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    return (x >> n) & 1;
}

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    int next = ((reg(0) ^ reg(2)) ^ reg(3)) ^ reg(5);
    *reg = *reg >> 1;
    *reg |= (next << 15);
}

