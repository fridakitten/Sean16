//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <Foundation/Foundation.h>

#include <stdint.h>
#include "Sean16.h"
#import "PC/Display.h"
#import "PC/CursorTracker.h"
#import "PC/Delegate.h"

//INTERPRETER
uint8_t** interpret(NSString *code);
