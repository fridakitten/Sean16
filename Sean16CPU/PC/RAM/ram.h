//
//  ram.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#ifndef ram_h
#define ram_h

#include "../Sean16.h"

typedef struct {
    uint16_t id;
    uint8_t *memory[1024][6];
} page_t;

page_t* genpage(void);
void freepage(page_t *page);

#endif /* ram_h */
