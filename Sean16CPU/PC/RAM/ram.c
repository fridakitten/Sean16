//
//  ram.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../Sean16.h"
#include "ram.h"

static uint8_t RAMDISK[S_RAMSIZE_MAX];
static uint16_t current_addr = 0;

page_t* genpage(void) {
    page_t *page = malloc(sizeof(page_t));
    
    if (page == NULL) {
        return NULL;
    }

    for (int i = 0; i < 6; i++) {
        for (int j = current_addr + 0; j < current_addr + 1024; j++) {
            page->memory[i][j] = &RAMDISK[i * 1024 + j];
        }
    }
    
    current_addr += 1024;

    return page;
}
