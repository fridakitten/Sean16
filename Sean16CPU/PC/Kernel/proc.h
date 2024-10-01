//
//  proc.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#ifndef proc_h
#define proc_h

#include "../../Sean16.h"
#include "../ram.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct {
    uint8_t pid;            // process identifier
    uint8_t state;          // 0 = not running / 1 = running / 2 = paused / 3 = killed
    pthread_t thread;       // processes thread;
    page_t *page;           // page for binary
    page_t *var;            // page for variables
    page_t *peri;           // peripherals mapping
} proc;

proc* proc_fork(uint8_t binmap[1000][6]);
void proc_kill(proc *process);

#endif /* proc_h */
