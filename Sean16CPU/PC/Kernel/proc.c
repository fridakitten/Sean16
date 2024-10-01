//
//  proc.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "proc.h"

static proc *processes[UINT16_MAX];

static uint16_t pidn = 0;

proc* proc_fork(uint8_t binmap[1000][6]) {
    proc *pid = malloc(sizeof(proc));

    pid->pid = pidn;
    pid->state = 1;
    pid->page = genpage();
    pid->var = genpage();
    for(int i = 0; 6 > i; i++) {
        for(int j = 0; 1024 > j; j++) {
            *pid->page->memory[i][j] = binmap[i][j];
        }
    }
    
    processes[pidn] = pid;
    pidn++;
    
    return pid;
}

void proc_kill(proc *process) {
    uint16_t pidt = process->pid;
    
    processes[pidt]->state = 3;
}
