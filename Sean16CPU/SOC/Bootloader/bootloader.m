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
#import <FileSystem/fs.h>

extern void *execute(void *arg);

void bootloader(uint8_t binmap[1000][6]) {
    printf("[soc-bootloader-chip] initialising block device\n");
    fs_init();
    
    // Clear Screen
    printf("[soc-bootloader-chip] clearing screen\n");
    clearScreen();
    
    // INIT
    printf("[soc-bootloader-chip] initialising mouse\n");
    CursorTracker *mouse = getTracker(NULL);
    [mouse setInit:YES];
    [mouse stopTracking];
    [mouse startTracking];
    
    // fork process
    printf("[soc-bootloader-chip] forking kernel process\n");
    proc *child_task = proc_fork(binmap);
    child_task->page[2] = genpage();
    
    // peripherials mapping
    printf("[soc-bootloader-chip] mapping peripherals\n");
    *((CGPoint **)&child_task->page[2]->memory[0][0]) = [mouse getCursorPosition];
    *((NSInteger **)&child_task->page[2]->memory[0][1]) = [mouse getLastMouseButtonState];
    
    // executing process
    printf("[soc-bootloader-chip] executing kernel process\n");
    execute((void*)child_task);

    // DEINIT
    printf("[soc-bootloader-chip] process has finished execution\n");
    printf("[soc-bootloader-chip] deinitialising mouse\n");
    [mouse stopTracking];
    [mouse setInit:NO];
    
    // killing task
    printf("[soc-bootloader-chip] freeing process\n");
    proc_kill(child_task);
    
    // Clear Screen
    printf("[soc-bootloader-chip] clearing screen\n");
    clearScreen();
}
