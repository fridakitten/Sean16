//
//  Sean16.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../Sean16.h"
#include "Kernel/proc.h"
#include "gpu.h"

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


static uint16_t reg[S_CPU_REGISTER_MAX];

void evaluate(int *i, int mode, int reg1, int reg2, int jmpaddr) {
    if(mode == 0) { // EQUALS
        if(reg1 == reg2) {
            *i = jmpaddr;
        }
    } else if(mode == 1) {
        if(reg1 > reg2) { // GREATER
            *i = jmpaddr;
        }
    } else if(mode == 2) {
        if(reg1 < reg2) { // LESS
            *i = jmpaddr;
        }
    }
}

void *execute(/*proc *proccess*/void *arg) {
    proc *proccess = (proc *)arg;
    
    for(int i = 0; i < S_CPU_REGISTER_MAX; i++) {
        reg[i] = 0;
    }
    
    uint16_t *ptr1 = malloc(sizeof(uint16_t));
    uint16_t *ptr2 = malloc(sizeof(uint16_t));
    uint16_t *ptr3 = malloc(sizeof(uint16_t));
    uint16_t *ptr4 = malloc(sizeof(uint16_t));
    uint16_t *ptr5 = malloc(sizeof(uint16_t));
    
    printf("[cpu] initialised\n");
    printf("[cpu] executing\n");
    
    for(int i = 0; i < 1000; i++) {
        uint8_t instruction = *(proccess->page->memory[i][0]);
        
        if (*(proccess->page->memory[i][1]) < 65) {
            ptr1 = &reg[*(proccess->page->memory[i][1])];
        } else {
            *ptr1 = *(proccess->page->memory[i][1]) - 64;
            //printf("[cpu] is val\n");
        }
        if (*(proccess->page->memory[i][2]) < 65) {
            ptr2 = &reg[*(proccess->page->memory[i][2])];
        } else {
            *ptr2 = *(proccess->page->memory[i][2]) - 64;
            //printf("[cpu] is val\n");
        }
        if (*(proccess->page->memory[i][3]) < 65) {
            ptr3 = &reg[*(proccess->page->memory[i][3])];
        } else {
            *ptr3 = *(proccess->page->memory[i][3]) - 64;
            //printf("[cpu] is val\n");
        }
        if (*(proccess->page->memory[i][4]) < 65) {
            ptr4 = &reg[*(proccess->page->memory[i][4])];
        } else {
            *ptr4 = *(proccess->page->memory[i][4]) - 64;
            //printf("[cpu] is val\n");
        }
        if (*(proccess->page->memory[i][5]) < 65) {
            ptr5 = &reg[*(proccess->page->memory[i][5])];
        } else {
            *ptr5 = *(proccess->page->memory[i][5]) - 64;
            //printf("[cpu] is val\n");
        }
        
        switch(instruction) {
            case 0x00:
                printf("[cpu] exited on line %d\n", i);
                return NULL;
            case 0x01:
                reg[*ptr1] = *ptr2;
                break;
            case 0x02:
                reg[*ptr1] += reg[*ptr2];
                break;
            case 0x03:
                reg[*ptr1] -= reg[*ptr2];
                break;
            case 0x04:
                reg[*ptr1] *= reg[*ptr2];
                break;
            case 0x05:
                reg[*ptr1] /= reg[*ptr2];
                break;
            case 0x06:
                printf("[cpu] %d\n", *ptr1);
                break;
            case 0x07:
                i = reg[*ptr1];
                break;
            case 0x08:
                evaluate(&i, *ptr1, reg[*ptr2], reg[*ptr3], reg[*ptr4]);
                break;
            case 0xA0:
                setpixel(reg[*ptr1], reg[*ptr2], *ptr3);
                break;
            case 0xA1:
                drawLine(reg[*ptr1], reg[*ptr2], reg[*ptr3], reg[*ptr4], *ptr5);
                break;
            case 0xA2:
                drawCharacter(reg[*ptr1], reg[*ptr2], reg[*ptr3], *ptr4);
                break;
            case 0xA3:
                clearScreen();
                break;
            case 0xB0:
                usleep(*ptr1 * *ptr2);
                break;
            default:
                printf("[cpu] 0x%02x is illegal\n", i);
                return NULL;
        }
        
    }
    
    return NULL;
}
