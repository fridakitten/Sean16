//
//  ram.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../Sean16.h"
#include "ram.h"

static uint8_t RAMDISK[S_RAMSIZE_MAX];

page_t* genpage(void) {
    page_t *page = malloc(sizeof(page_t));
    
    if (page == NULL) {
        return NULL;
    }

    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 1024; j++) {
            page->memory[i][j] = &RAMDISK[i * 1024 + j];
        }
    }

    return page;
}
