//
//  kernel.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../../Sean16.h"
#include "kernel.h"
#import <Cocoa/Cocoa.h>
#import <Peripherals/Mouse.h>

extern void *execute(void *arg);

void kernel_init(uint8_t binmap[1000][6]) {
    // INIT
    CursorTracker *mouse = [[CursorTracker alloc] init];
    [mouse startTracking];
    
    // fork process
    proc *child_task = proc_fork(binmap);
    child_task->peri = genpage();
    
    // peripherials mapping
    *((CGPoint **)&child_task->peri->memory[0][0]) = [mouse getCursorPosition];
    *((NSInteger **)&child_task->peri->memory[0][1]) = [mouse getLastMouseButtonState];
    
    // executing process
    execute((void*)child_task);

    // DEINIT
    [mouse stopTracking];
    
    // killing task
    proc_kill(child_task);
}
