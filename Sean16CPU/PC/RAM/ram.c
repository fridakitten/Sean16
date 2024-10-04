//
//  ram.c
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#include "../Sean16.h"
#include "ram.h"

uint8_t RAMDISK[S_RAMSIZE_MAX];
uint16_t current_addr = 0;
uint8_t current_page = 0;

page_t* genpage(void) {
    page_t *page = malloc(sizeof(page_t));
    
    if (page == NULL) {
        printf("[ram] ram fault\n");
        return NULL;
    }

    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 1024; j++) {  // j goes from 0 to 1024, index for this page
            page->memory[i][j] = &RAMDISK[current_addr];
            current_addr ++;
        }
    }
    
    printf("[ram] %'d bytes left (%.2f MB)\n", S_RAMSIZE_MAX - current_addr, (S_RAMSIZE_MAX - current_addr) / (1024.0 * 1024.0));
    
    current_page += 1;

    return page;
}

