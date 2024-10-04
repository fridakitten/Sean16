//
//  kickstart.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#include "Sean16.h"
#include "libasmfile/libasmfile.h"

extern void kernel_init(uint8_t binmap[1000][6]);

void kickstart(NSString *path) {
    uint8_t **asmData = readasm([path UTF8String]);
    
    if (asmData == NULL) {
        return;
    }
    
    uint8_t binmap[1000][6] = {0};

    for (int i = 0; i < 1000; i++) {
        if (asmData[i] != NULL) {
            memcpy(binmap[i], asmData[i], sizeof(binmap[i]));
        }
    }
    
    kernel_init(binmap);
}
