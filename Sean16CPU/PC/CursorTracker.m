//
//  CursorTracker.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import "CursorTracker.h"

@interface CursorTracker ()

@property (nonatomic, strong) id trackingHandler;
@property (nonatomic, strong) id shortcutEventHandler;
@property (nonatomic, assign) BOOL cursorHidden;

@end

@implementation CursorTracker

- (instancetype)init {
    self = [super init];
    if (self) {
        _cursorPosition = NSMakePoint(0, 0);
        _cursorHidden = NO; // Initially, the cursor is not hidden
    }
    return self;
}

- (void)startTracking {
    [self hideCursor];
    
    self.trackingHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^(NSEvent *event) {
        [self updateCursorPosition:event];
        return event; // Pass the event along
    }];
    
    self.shortcutEventHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent *event) {
        if ((event.modifierFlags & NSEventModifierFlagCommand) && [[event charactersIgnoringModifiers] isEqualToString:@"r"]) {
            [self unhideCursor];
        }
        if ((event.modifierFlags & NSEventModifierFlagCommand) && [[event charactersIgnoringModifiers] isEqualToString:@"s"]) {
            [self hideCursor];
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
    
    CGFloat scaledX = (screenCursorPosition.x / screenWidth) * 254.0;
    CGFloat scaledY = (screenCursorPosition.y / screenHeight) * 159.0;

    CGFloat clampedX = fmax(0, fmin(scaledX, 254.0));
    CGFloat clampedY = fmax(0, fmin(scaledY, 159.0));

    self.cursorPosition = NSMakePoint(clampedX, clampedY);
    NSLog(@"Cursor Position (scaled to 255x155): %@", NSStringFromPoint(self.cursorPosition));
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
