//
//  kickstart.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "Sean16.h"

extern void kernel_init(uint8_t binmap[1000][6]);

void kickstart(void) {
    uint8_t binmap[1000][6] = {
        {0x01, 0x00, 64 + 30, 0x00, 0x00, 0x00}, // 0
        {0x06, 0x00, 0x00   , 0x00, 0x00, 0x00}, // 1
        {0x09, 0x00, 0x01   , 0x00, 0x00, 0x00}, // 3
        {0xA0, 0x00, 0x01   , 64 + 7, 0x00, 0x00}, // 3
        {0x07, 64 + 1, 0x00, 0x00, 0x00, 0x00},
        
        {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, // 4
    };
    
    kernel_init(binmap);
}
