//
//  rdrand.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 03.10.24.
//

#include "rdrand.h"

void rdrand(uint16_t *ptr, uint16_t min, uint16_t max) {
    // Ensure that min is less than or equal to max
    if (min > max) {
        uint16_t temp = min;
        min = max;
        max = temp;
    }

    // Generate a random value in the range [min, max]
    uint16_t rand_val = (rand() % (max - min + 1)) + min;
    *ptr = rand_val;
}
