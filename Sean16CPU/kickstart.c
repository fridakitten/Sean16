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
        // INIT <0x41>
        {0x07, 0x49, 0x00, 0x00, 0x00, 0x00}, //41 JMP 0                       // IMPORTANT POINT TO => BTN LABEL

        // MAIN <0x42>
        {0x09, 0x05, 0x06, 0x02, 0x00, 0x00}, //42 MOUSE
        {0x08, 0x41, 0x02, 0x43, 0x45, 0x00}, //43 IF                          // IMPORTANT POINT TO => PIXEL LABEL
        {0x07, 0x42, 0x00, 0x00, 0x00, 0x00}, //44 JMP 0                       // IMPORTANT POINT TO => MAIN
        
        // PIXEL LABEL <0x45>
        {0xA0, 0x05, 0x06, 0x48, 0x00, 0x00}, //45 GPU PX
        {0x07, 0x42, 0x00, 0x00, 0x00, 0x00}, //46 JMP 0                       // IMPORTANT POINT TO => MAIN
        
        // SWITCH LABEL <0x47>
        {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, //47
        {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, //48
        
        // BTN LABEL <0x49>
        {0x01, 0x00, 0x47, 0x00, 0x00, 0x00}, //49 STORE R0 7
        {0x01, 0x02, 0x51, 0x00, 0x00, 0x00}, //4A STORE R2 10
        {0x01, 0x03, 0x60, 0x00, 0x00, 0x00}, //4B STORE R3 AA
        {0xA1, 0x00, 0x00, 0x00, 0x02, 0x46}, //4C GPU LINE R0 R1 => R0 R2
        {0xA1, 0x00, 0x02, 0x03, 0x02, 0x46}, //4D GPU LINE R0 R2 => R3 R2
        {0xA1, 0x03, 0x02, 0x03, 0x00, 0x46}, //4E GPU LINE R3 R2 => R3 R1
        {0xA1, 0x03, 0x00, 0x00, 0x00, 0x46}, //4F GPU LINE R3 R1 => R0 R1
        {0x01, 0x00, 0x47, 0x00, 0x00, 0x00}, //50 STORE R0 7
        {0x01, 0x05, 0x4A, 0x00, 0x00, 0x00}, //51 STORE R0 7
        {0x01, 0x06, 0x49, 0x00, 0x00, 0x00}, //52 STORE R1 7
        {0xA2, 0x05, 0x06, 0x86, 0x48, 0x00}, //53
        {0x01, 0x05, 0x50, 0x00, 0x00, 0x00}, //54 STORE R0 7
        {0x01, 0x06, 0x49, 0x00, 0x00, 0x00}, //55 STORE R1 7
        {0xA2, 0x05, 0x06, 0x99, 0x48, 0x00}, //56
        {0x01, 0x05, 0x56, 0x00, 0x00, 0x00}, //57 STORE R0 7
        {0x01, 0x06, 0x49, 0x00, 0x00, 0x00}, //58 STORE R1 7
        {0xA2, 0x05, 0x06, 0x8A, 0x48, 0x00}, //59
        {0x01, 0x05, 0x5B, 0x00, 0x00, 0x00}, //5A STORE R0 7
        {0x01, 0x06, 0x49, 0x00, 0x00, 0x00}, //5B STORE R1 7
        {0xA2, 0x05, 0x06, 0x95, 0x48, 0x00}, //5C
        {0x07, 0x5E, 0x00, 0x00, 0x00, 0x00}, //5D JMP 0                        // IMPORTANT POINT TO => MAIN
        
        // CURSOR LABEL <0x5E>
        {0x09, 0x10, 0x11, 0x12, 0x00, 0x00}, //5E
        
        {0x08, 0x44, 0x12, 0x43, 0x63, 0x00}, //5F
        {0xA0, 0x10, 0x11, 0x42, 0x00, 0x00}, //60
        {0xB1, 0x75, 0x75, 0x75, 0x00, 0x00}, //61
        {0x07, 0x72, 0x00, 0x00, 0x00, 0x00}, //62
        {0xA0, 0x10, 0x11, 0x48, 0x00, 0x00}, //63
        
        {0x01, 0x22, 0x41, 0x00, 0x00, 0x00}, //64
        
        {0x08, 0x41, 0x10, 0x20, 0x67, 0x00}, //65
        {0x02, 0x22, 0x42, 0x00, 0x00, 0x00}, //66
        {0x08, 0x44, 0x22, 0x42, 0x6B, 0x00}, //67
        {0xA0, 0x20, 0x21, 0x41, 0x00, 0x00}, //68
        {0x01, 0x20, 0x10, 0x00, 0x00, 0x00}, //69
        {0x01, 0x21, 0x11, 0x00, 0x00, 0x00}, //6A
        {0x08, 0x41, 0x11, 0x21, 0x6D, 0x00}, //6B
        
        {0x02, 0x22, 0x42, 0x00, 0x00, 0x00}, //6C
        
        {0x08, 0x44, 0x22, 0x42, 0x71, 0x00}, //6D
        {0xA0, 0x20, 0x21, 0x41, 0x00, 0x00}, //6E
        {0x01, 0x20, 0x10, 0x00, 0x00, 0x00}, //6F
        {0x01, 0x21, 0x11, 0x00, 0x00, 0x00}, //70
        {0x07, 0x49, 0x00, 0x00, 0x00, 0x00}, //71
        
        // CURSOR LEFT CLICK <0x72>
        {0x08, 0x42, 0x10, 0x60, 0x77, 0x00}, //72 B S
        {0x08, 0x42, 0x11, 0x51, 0x77, 0x00}, //73 B S
        {0x08, 0x43, 0x10, 0x47, 0x77, 0x00}, //74 B S
        {0x08, 0x43, 0x11, 0x47, 0x77, 0x00}, //75 B S
        {0x07, 0x78, 0x00, 0x00, 0x00, 0x00}, //76
        {0x07, 0x64, 0x00, 0x00, 0x00, 0x00}, //77
        
        // EXIT <0x78>
        {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, //78
    };
    
    kernel_init(binmap);
}
