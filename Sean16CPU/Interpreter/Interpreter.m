//
//  Interpreter.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

#import <Foundation/Foundation.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>

#define MAX_LINES 1000
#define MAX_WORDS_PER_LINE 3

uint8_t** interpret(NSString *code) {    
    printf("[interpreter] preparing...\n");
    fflush(stdout);
    //prepare
    char *raw[1000];
    char *rawbinmap[1000][4];
    
    //split into array
    NSArray *lines = [code componentsSeparatedByString:@"\n"];
    
    for (int index = 0; index < 1000 && index < MAX_LINES; index++) {
        NSString *line = [lines objectAtIndex:index];
        const char *cString = [line UTF8String];

        // Allocate memory for a modifiable copy of the line
        raw[index] = (char *)malloc(strlen(cString) + 1);
        strcpy(raw[index], cString); // Copy content to the allocated buffer
    }
    
    //split into rawbitmap
    for (int i = 0; i < 1000; i++) {
        char *line = raw[i];
        if (line == NULL) continue;  // Ensure that the line is not NULL

        // Tokenize the line into words (split by space or tab)
        char *token = strtok(line, " \t");
        int wordIndex = 0;

        // Split each line into up to MAX_WORDS_PER_LINE words
        while (token != NULL && wordIndex < MAX_WORDS_PER_LINE) {
            // Allocate memory for each word
            rawbinmap[i][wordIndex] = (char *)malloc(strlen(token) + 1);
            strcpy(rawbinmap[i][wordIndex], token); // Copy token to rawbinmap
            wordIndex++;

            // Continue tokenizing the line
            token = strtok(NULL, " \t");
        }

        // Set remaining word slots to NULL if fewer than MAX_WORDS_PER_LINE
        while (wordIndex < MAX_WORDS_PER_LINE) {
            rawbinmap[i][wordIndex] = NULL;
            wordIndex++;
        }
    }

    printf("compiling\n");
    fflush(stdout);
    //compiling
    
    uint8_t **binmap = (uint8_t **)malloc(1000 * sizeof(uint8_t *));
    for (int i = 0; i < 1000; i++) {
        binmap[i] = (uint8_t *)malloc(4 * sizeof(uint8_t));
        //printf("HALLO: %s\n", rawbinmap[i][0]);
        
    }

    for (int i = 0; i < 1000; i++) {
        for (int j = 0; j < 4; j++) {
            binmap[i][j] = (uint8_t)(i + j);
        }
    }

    return binmap;
}
