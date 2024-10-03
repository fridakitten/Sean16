//
//  CursorTracker.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import "Mouse.h"

@interface CursorTracker ()

@property (nonatomic, strong) id trackingHandler;
@property (nonatomic, strong) id shortcutEventHandler;
@property (nonatomic, assign) BOOL cursorHidden;
@property (nonatomic, assign) NSInteger lastMouseButtonState; // New property for mouse button state
@property (nonatomic, weak) NSWindow *window; // Reference to the window

@end

@implementation CursorTracker

- (instancetype)initWithWindow:(NSWindow *)window {
    self = [super init];
    if (self) {
        _cursorPosition = NSMakePoint(0, 0);
        _cursorHidden = NO; // Initially, the cursor is not hidden
        _lastMouseButtonState = 0; // Initially, no button pressed
        _window = window; // Set the window reference
    }
    return self;
}

- (NSPoint*)getCursorPosition {
    return &_cursorPosition;
}

- (NSInteger*)getLastMouseButtonState {
    return &_lastMouseButtonState;
}

- (void)startTracking {
    [self hideCursor];
    
    // Update window title
    [self updateWindowTitle];

    // Monitor for mouse movement
    self.trackingHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^(NSEvent *event) {
        [self updateCursorPosition:event];
        return event; // Pass the event along
    }];
    
    // Monitor for keyboard shortcuts
    self.shortcutEventHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent *event) {
        if ((event.modifierFlags & NSEventModifierFlagCommand) && [[event charactersIgnoringModifiers] isEqualToString:@"r"]) {
            [self unhideCursor];
        }
        if ((event.modifierFlags & NSEventModifierFlagCommand) && [[event charactersIgnoringModifiers] isEqualToString:@"s"]) {
            [self hideCursor];
        }
        return event;
    }];
    
    // Monitor for mouse button clicks (left and right)
    self.trackingHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown handler:^(NSEvent *event) {
        if ([event type] == NSEventTypeLeftMouseDown) {
            self.lastMouseButtonState = 2; // Left click
        } else if ([event type] == NSEventTypeRightMouseDown) {
            self.lastMouseButtonState = 1; // Right click
        }
        return event;
    }];
}

- (void)stopTracking {
    if (self.trackingHandler) {
        [NSEvent removeMonitor:self.trackingHandler];
        self.trackingHandler = nil;
    }
    
    // Unhide cursor and reset window title
    [self unhideCursor];
    [self resetWindowTitle];

    if (self.shortcutEventHandler) {
        [NSEvent removeMonitor:self.shortcutEventHandler];
        self.shortcutEventHandler = nil;
    }
}

- (void)updateCursorPosition:(NSEvent *)event {
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenRect = [mainScreen frame];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    NSPoint screenCursorPosition = [event locationInWindow];
    
    // Keep the X position as is (no inversion)
    CGFloat scaledX = (screenCursorPosition.x / screenWidth) * 254.0;

    // Invert the Y position
    CGFloat scaledY = (screenHeight - screenCursorPosition.y) / screenHeight * 254.0;

    // Clamp the values to ensure they are within the desired range
    CGFloat clampedX = fmax(0, fmin(scaledX, 254.0));
    CGFloat clampedY = fmax(0, fmin(scaledY, 254.0));

    self.cursorPosition = NSMakePoint(clampedX, clampedY);
}

- (void)hideCursor {
    if (!self.cursorHidden) {
        [NSCursor hide];
        self.cursorHidden = YES;
        NSLog(@"Cursor hidden.");
        
        // Capture the mouse to the window
        [self.window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
        [self.window setMovableByWindowBackground:NO];
        [self.window makeKeyAndOrderFront:nil];
        [self.window setIgnoresMouseEvents:NO]; // Allow mouse events within window
        
        // Update window title
        [self updateWindowTitle];
    }
}

- (void)unhideCursor {
    if (self.cursorHidden) {
        [NSCursor unhide];
        self.cursorHidden = NO;
        NSLog(@"Cursor shown.");
        
        // Release the mouse focus
        [self.window setCollectionBehavior:NSWindowCollectionBehaviorDefault];
        [self.window setIgnoresMouseEvents:YES]; // Ignore mouse events
        [self resetWindowTitle]; // Reset window title
    }
}

- (void)updateWindowTitle {
    NSString *currentTitle = self.window.title;
    self.window.title = [currentTitle stringByAppendingString:@" - Press Command + R to escape"];
}

- (void)resetWindowTitle {
    NSString *titleWithoutMessage = [self.window.title stringByReplacingOccurrencesOfString:@" - Press Command + R to escape" withString:@""];
    self.window.title = titleWithoutMessage;
}

@end
