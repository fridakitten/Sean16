//
//  Delegate.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 28.09.24.
//

#import <Cocoa/Cocoa.h>

@interface YourViewController : NSViewController

@property (nonatomic, strong) CursorTracker *cursorTracker;
@property (nonatomic, strong) MyScreenEmulatorView *screenEmulator;

@end
