//
//  Display.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import <Cocoa/Cocoa.h>

@interface MyScreenEmulatorView : NSView

- (void)setPixelAtX:(int)x Y:(int)y colorIndex:(NSInteger)colorIndex;
- (void)clearScreen;
- (void)drawCursorAtPosition:(NSPoint)position;

@end

MyScreenEmulatorView *getEmulator(void);
