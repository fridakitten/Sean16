//
//  kernel.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../../Sean16.h"
#include "bootloader.h"
#import <Cocoa/Cocoa.h>
#import <Peripherals/Mouse/Mouse.h>
#import <GPU/gpu.h>

extern void *execute(void *arg);

void bootloader(uint8_t binmap[1000][6]) {
    printf("[soc-bootloader] clearing screen\n");
    clearScreen();
    
    // INIT
    printf("[soc-bootloader] initialising mouse\n");
    CursorTracker *mouse = getTracker(NULL);
    [mouse startTracking];
    
    // fork process
    printf("[soc-bootloader] forking kernel process\n");
    proc *child_task = proc_fork(binmap);
    child_task->peri = genpage();
    
    // peripherials mapping
    printf("[soc-bootloader] mapping peripherals\n");
    *((CGPoint **)&child_task->peri->memory[0][0]) = [mouse getCursorPosition];
    *((NSInteger **)&child_task->peri->memory[0][1]) = [mouse getLastMouseButtonState];
    
    // executing process
    printf("[soc-bootloader] executing kernel process\n");
    execute((void*)child_task);

    // DEINIT
    printf("[soc-bootloader] process has finished execution\n");
    printf("[soc-bootloader] deinitialising mouse\n");
    [mouse stopTracking];
    
    // killing task
    printf("[soc-bootloader] freeing process\n");
    proc_kill(child_task);
    
    printf("[soc-bootloader] clearing screen\n");
    clearScreen();
}
