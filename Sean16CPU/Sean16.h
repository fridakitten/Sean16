//
//  Sean16.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#ifndef Sean16_h
#define Sean16_h

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>
#include <pthread/pthread.h>

#define S_CPU_REGISTER_MAX 128
#define S_RAMSIZE_MAX 64000000
#define S_PAGE_SIZE 256

//CPU
void kickstart(void);

#endif /* Sean16_h */
