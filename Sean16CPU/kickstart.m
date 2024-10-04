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
        fprintf(stderr, "Error reading ASM data.\n");
        return; // Exit if readasm fails
    }
    
    uint8_t binmap[1000][6] = {0};

    for (int i = 0; i < 1000; i++) {
        for (int j = 0; j < 6; j++) {
            if (asmData[i] != NULL && j < sizeof(asmData[i])/sizeof(asmData[i][0])) {
                binmap[i][j] = asmData[i][j];
            } else {
                binmap[i][j] = 0;
            }
        }
    }
    
    kernel_init(binmap);
}
