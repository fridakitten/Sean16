//
//  Delegate.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 28.09.24.
//

#import "CursorTracker.h"
#import "Display.h"
#import "Delegate.h"

@implementation YourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cursorTracker = [[CursorTracker alloc] init];
    self.screenEmulator = [[MyScreenEmulatorView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.screenEmulator];
    
    //[self.cursorTracker startTracking];
    
    // Setup a timer to update the cursor position
    //[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateCursor) userInfo:nil repeats:YES];
}

- (void)updateCursor {
    NSPoint cursorPos = [self.cursorTracker getCursorPosition];
    [self.screenEmulator drawCursorAtPosition:cursorPos]; // Draw the cursor at the current position
}

@end
