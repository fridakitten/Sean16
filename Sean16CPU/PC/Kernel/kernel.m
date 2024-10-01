//
//  kernel.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../../Sean16.h"
#include "kernel.h"
#import <Cocoa/Cocoa.h>

extern void *execute(void *arg);

void kernel_init(uint8_t binmap[1000][6]) {
    uint8_t kernelmap[1000][6];
    
    
    //NSApplication *app = [NSApplication sharedApplication];
    //[app run];
    
    // periphal memory mapping
    page_t * periphals = genpage();
    //periphals->memory[0][0] = [tracker getptr];
    
    // fork process
    proc *kernel_task = proc_fork(kernelmap);
    proc *child_task = proc_fork(binmap);
    
    if (pthread_create(&kernel_task->thread, NULL, execute, (void *)child_task) != 0) {
        perror("Failed to create thread");
    }

    // Wait for the thread to finish
    pthread_join(kernel_task->thread, NULL);

    // killing task
    proc_kill(child_task);
    proc_kill(kernel_task);
}
