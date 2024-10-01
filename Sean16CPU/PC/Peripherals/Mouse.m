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

@end

@implementation CursorTracker

- (instancetype)init {
    self = [super init];
    if (self) {
        _cursorPosition = NSMakePoint(0, 0);
        _cursorHidden = NO; // Initially, the cursor is not hidden
        _lastMouseButtonState = 0; // Initially, no button pressed
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
    [self unhideCursor];

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
    CGFloat scaledY = (screenHeight - screenCursorPosition.y) / screenHeight * 159.0;

    // Clamp the values to ensure they are within the desired range
    CGFloat clampedX = fmax(0, fmin(scaledX, 254.0));
    CGFloat clampedY = fmax(0, fmin(scaledY, 159.0));

    self.cursorPosition = NSMakePoint(clampedX, clampedY);
    // NSLog(@"Cursor Position (scaled to 255x155): %@", NSStringFromPoint(self.cursorPosition));
}

- (void)hideCursor {
    if (!self.cursorHidden) {
        [NSCursor hide];
        self.cursorHidden = YES;
        NSLog(@"Cursor hidden.");
    }
}

- (void)unhideCursor {
    if (self.cursorHidden) {
        [NSCursor unhide];
        self.cursorHidden = NO;
        NSLog(@"Cursor shown.");
    }
}

@end
