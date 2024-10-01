//
//  kickstart.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

// CPU INSTRUCTIONS
// EXIT  - 0x00
// STORE - 0x01 <REGISTER> <VALUE>
// ADD   - 0x02 <REGISTER> <REGISTER>
// SUB   - 0x03 <REGISTER> <REGISTER>
// MUL   - 0x04 <REGISTER> <REGISTER>
// DIV   - 0x05 <REGISTER> <REGISTER>
// DSP   - 0x06 <REGISTER>
// JMP   - 0x07 <REGISTER>
// IF    - 0x08 <MODE>     <REGISTER> <REGISTER> <REGISTER>

// GPU INSTRUCTIONS
// GPX   - 0xA0 <REGISTER> <REGISTER> <REGISTER> <VALUE>
// GLI   - 0xA1 <REGISTER> <REGISTER> <REGISTER> <REGISTER>
// GDC   - 0xA2 <REGISTER> <REGISTER> <REGISTER> <VALUE>
// GCS   - 0xA3

#include "Sean16.h"

extern void kernel_init(uint8_t binmap[1000][6]);

void kickstart(void) {
    uint8_t binmap[1000][6] = {
        // MAIN <0x41>
        {0xB1, 0x00, 0x00, 0x00, 0x00, 0x00}, //41 SLEEP
        {0x09, 0x05, 0x06, 0x02, 0x00, 0x00}, //42 MOUSE
        {0x08, 0x41, 0x02, 0x43, 0x45, 0x00}, //43 IF
        {0x07, 0x41, 0x00, 0x00, 0x00, 0x00}, //44 JMP 0
        
        // PIXEL LABEL <0x45>
        {0xA0, 0x05, 0x06, 0x48, 0x00, 0x00}, //45 GPU PX
        {0x07, 0x41, 0x00, 0x00, 0x00, 0x00}, //46 JMP 0
        
        {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, //47
    };
    
    kernel_init(binmap);
}

/*
{0x06, 0x00, 0x00   , 0x00, 0x00, 0x00},     // DSP
{0x09, 0x00, 0x01   , 0x02, 0x00, 0x00},     // MOUSE
{0xA0, 0x00, 0x01   , 64 + 7, 0x00, 0x00},   // GPU PX
{0x08, 0x00, 0x02, 64 + 1, 64 + 1, 0x00},    // IF
{0x07, 64 + 4, 0x00, 0x00, 0x00, 0x00},      // JMP
 */
