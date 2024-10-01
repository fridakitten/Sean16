//
//  CursorTracker.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Display.h"

@interface CursorTracker : NSObject

//@property (nonatomic) NSPoint cursorPosition;

@property (nonatomic, assign) NSPoint cursorPosition;

- (void)startTracking;
- (void)stopTracking;
- (NSPoint)getCursorPosition;

@end
