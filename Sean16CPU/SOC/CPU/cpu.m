//
//  Sean16.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../Sean16.h"
#include "peripheral.h"
#include "rdrand.h"
#include <Bootloader/bootloader.h>
#include <GPU/gpu.h>
#import <CoreGraphics/CoreGraphics.h>

static uint16_t reg[S_CPU_REGISTER_MAX];

void evaluate(int *i, int mode, int reg1, int reg2, int jmpaddr) {
    //printf("%d => %d %d => %d\n", mode, reg1, reg2, jmpaddr);
    if(mode == 0) { // EQUALS
        if(reg1 == reg2) {
            *i = jmpaddr - 1;
            //printf("jmp to: %d\n", jmpaddr - 1);
        }
    } else if(mode == 1) {
        if(reg1 > reg2) { // GREATER
            *i = jmpaddr - 1;
            //printf("jmp to: %d\n", jmpaddr - 1);
        }
    } else if(mode == 2) {
        if(reg1 < reg2) { // LESS
            *i = jmpaddr - 1;
            //printf("jmp to: %d\n", jmpaddr - 1);
        }
    } else if(mode == 3) { // EQUALS
        if(reg1 != reg2) {
            *i = jmpaddr - 1;
        }
    }
}

void *execute(void *arg) {
    proc *proccess = (proc *)arg;
    
    for(int i = 0; i < S_CPU_REGISTER_MAX; i++) {
        reg[i] = 0;
    }
    
    uint16_t *ptr1;
    uint16_t *ptr2;
    uint16_t *ptr3;
    uint16_t *ptr4;
    uint16_t *ptr5;
    uint16_t dummyreg[5];
    uint8_t instruction;
    
    printf("[cpu] initialised\n");
    printf("[cpu] executing\n");
    
    for(int i = 0; i < 1000; i++) {
        instruction = *(proccess->page[0]->memory[i][0]);
        
        if (*(proccess->page[0]->memory[i][1]) < 65) {
            ptr1 = &reg[*(proccess->page[0]->memory[i][1])];
        } else {
            dummyreg[0] = *(proccess->page[0]->memory[i][1]) - 65;
            ptr1 = &dummyreg[0];
        }
        if (*(proccess->page[0]->memory[i][2]) < 65) {
            ptr2 = &reg[*(proccess->page[0]->memory[i][2])];
        } else {
            dummyreg[1] = *(proccess->page[0]->memory[i][2]) - 65;
            ptr2 = &dummyreg[1];
        }
        if (*(proccess->page[0]->memory[i][3]) < 65) {
            ptr3 = &reg[*(proccess->page[0]->memory[i][3])];
        } else {
            dummyreg[2] = *(proccess->page[0]->memory[i][3]) - 65;
            ptr3 = &dummyreg[2];
        }
        if (*(proccess->page[0]->memory[i][4]) < 65) {
            ptr4 = &reg[*(proccess->page[0]->memory[i][4])];
        } else {
            dummyreg[3] = *(proccess->page[0]->memory[i][4]) - 65;
            ptr4 = &dummyreg[3];
        }
        if (*(proccess->page[0]->memory[i][5]) < 65) {
            ptr5 = &reg[*(proccess->page[0]->memory[i][5])];
        } else {
            dummyreg[4] = *(proccess->page[0]->memory[i][5]) - 65;
            ptr5 = &dummyreg[4];
        }
        
        switch(instruction) {
            case 0x00:
                printf("[cpu] exited on line %d\n", i);
                return 0;
            case 0x01:
                *ptr1 = *ptr2;
                break;
            case 0x02:
                *ptr1 += *ptr2;
                break;
            case 0x03:
                *ptr1 -= *ptr2;
                break;
            case 0x04:
                *ptr1 *= *ptr2;
                break;
            case 0x05:
                *ptr1 /= *ptr2;
                break;
            case 0x06:
                printf("[cpu] %d\n", *ptr1);
                break;
            case 0x07:
                i = *ptr1 -1;
                break;
            case 0x08:
                evaluate(&i, *ptr1, *ptr2, *ptr3, *ptr4);
                break;
            case 0x09:
                periphalMUS(proccess->page[2], ptr1, ptr2, ptr3);
                break;
            case 0x0A:
                rdrand(ptr1, *ptr2, *ptr3);
                break;
            case 0xA0:
                usleep(50);
                setpixel(*ptr1, *ptr2, *ptr3);
                break;
            case 0xA1:
                usleep(50);
                drawLine(*ptr1, *ptr2, *ptr3, *ptr4, *ptr5);
                break;
            case 0xA2:
                usleep(50);
                drawCharacter(*ptr1, *ptr2, *ptr3, *ptr4);
                break;
            case 0xA3:
                usleep(50);
                clearScreen();
                break;
            case 0xA4:
                usleep(50);
                *ptr1 = getColorOfPixel(*ptr2, *ptr3);
                break;
            case 0xB0:
                sleep(*ptr1);
                break;
            case 0xB1:
                usleep(*ptr1 * *ptr2 * *ptr3);
                break;
            default:
                printf("[cpu] 0x%02x is illegal\n", i);
                return NULL;
        }
    }
    
    return NULL;
}
