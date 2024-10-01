//
//  kernel.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../../Sean16.h"
#include "kernel.h"
#import <Cocoa/Cocoa.h>
#import "../CursorTracker.h"

extern void *execute(void *arg);

void kernel_init(uint8_t binmap[1000][6]) {
    uint8_t kernelmap[1000][6];
    
    CursorTracker *mouse = [[CursorTracker alloc] init];
    [mouse startTracking];
    
    // periphal memory mapping
    page_t * periphals = genpage();
    *((CGPoint **)&periphals->memory[0][0]) = [mouse getCursorPosition];
    
    // fork process
    proc *kernel_task = proc_fork(kernelmap);
    proc *child_task = proc_fork(binmap);
    
    if (pthread_create(&child_task->thread, NULL, execute, (void *)child_task) != 0) {
        perror("Failed to create thread");
    }
    pthread_join(child_task->thread, NULL);

    // killing task
    proc_kill(child_task);
    proc_kill(kernel_task);
}
