#import "Mouse.h"

@interface CursorTracker ()

@property (nonatomic, strong) id trackingHandler;
@property (nonatomic, strong) id shortcutEventHandler;
@property (nonatomic, assign) BOOL isTrackingPaused;
@property (nonatomic, assign) BOOL isTrackingInitialised;
@property (nonatomic, assign) BOOL cursorHidden;

@end

@implementation CursorTracker

- (instancetype)initWithWindow:(NSWindow *)window {
    self = [super init];
    if (self) {
        _cursorPosition = NSMakePoint(0, 0);
        _isTrackingPaused = NO;
        _lastMouseButtonState = 0;
        _window = window;

        // Add observers for window focus events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidBecomeKey:)
                                                     name:NSWindowDidBecomeKeyNotification
                                                   object:window];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidResignKey:)
                                                     name:NSWindowDidResignKeyNotification
                                                   object:window];
    }
    return self;
}

- (void)dealloc {
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSPoint*)getCursorPosition {
    return &_cursorPosition;
}

- (NSInteger*)getLastMouseButtonState {
    return &_lastMouseButtonState;
}

- (void)startTracking {
    if (!self.isTrackingPaused) {
        return; // Already tracking
    }

    self.isTrackingPaused = NO;

    // Monitor for mouse movement (within the app window)
    self.trackingHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^(NSEvent *event) {
        if (!self.isTrackingPaused) {
            [self updateCursorPosition:event];
        }
        return event;
    }];

    // Monitor for mouse button clicks
    self.trackingHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown handler:^(NSEvent *event) {
        if (!self.isTrackingPaused) {
            if ([event type] == NSEventTypeLeftMouseDown) {
                self.lastMouseButtonState = 2; // Left click
            } else if ([event type] == NSEventTypeRightMouseDown) {
                self.lastMouseButtonState = 1; // Right click
            }
        }
        return event;
    }];
}

- (void)stopTracking {
    if (self.trackingHandler) {
        [NSEvent removeMonitor:self.trackingHandler];
        self.trackingHandler = nil;
    }

    if (self.shortcutEventHandler) {
        [NSEvent removeMonitor:self.shortcutEventHandler];
        self.shortcutEventHandler = nil;
    }
    
    self.isTrackingPaused = YES;
    [self unhideCursor];
}

- (void)hideCursor {
    if (!self.cursorHidden) {
        [NSCursor hide];
        self.cursorHidden = YES;
    }
}

- (void)unhideCursor {
    if (self.cursorHidden) {
        [NSCursor unhide];
        self.cursorHidden = NO;
    }
}

- (void)updateCursorPosition:(NSEvent *)event {
    // Get the window's frame, bounds, and position
    NSRect windowFrame = [self.window frame];
    NSRect windowBounds = [self.window contentView].bounds;
    NSPoint windowOrigin = windowFrame.origin;

    // Get the cursor's position in screen coordinates
    NSPoint screenCursorPosition = [NSEvent mouseLocation];

    // Calculate the position relative to the window's origin
    CGFloat relativeX = screenCursorPosition.x - windowOrigin.x;
    CGFloat relativeY = screenCursorPosition.y - windowOrigin.y;

    // Check if the cursor is within the window bounds
    if (relativeX >= 0 && relativeX <= windowBounds.size.width &&
        relativeY >= 0 && relativeY <= windowBounds.size.height) {
        
        // Scale the cursor position to a 0-255 range (X and Y)
        CGFloat scaledX = (relativeX / windowBounds.size.width) * 255.0;
        CGFloat scaledY = ((windowBounds.size.height - relativeY) / windowBounds.size.height) * 255.0;  // Flip Y axis

        CGFloat clampedX = fmax(0, fmin(scaledX, 255.0));
        CGFloat clampedY = fmax(0, fmin(scaledY, 255.0));

        self.cursorPosition = NSMakePoint(clampedX, clampedY);
        
        //NSLog(@"Cursor position (scaled): (%.2f, %.2f)", clampedX, clampedY);
        [self hideCursor];
    } else {
        // Cursor is outside the window, stop tracking
        //NSLog(@"Cursor outside the window.");
        [self unhideCursor];
    }
}

#pragma mark - Window Notification Handlers

- (void)windowDidBecomeKey:(NSNotification *)notification {
    if(_isTrackingInitialised) {
        [self startTracking];
    }
}

- (void)windowDidResignKey:(NSNotification *)notification {
    if(_isTrackingInitialised) {
        [self stopTracking];
    }
}

- (void)setInit:(BOOL)value {
    _isTrackingInitialised = value;
}

@end

CursorTracker *mouse;

CursorTracker *getTracker(void *arg) {
    if(mouse == NULL) {
        mouse = [[CursorTracker alloc] initWithWindow:(__bridge NSWindow*)arg];
    }
    
    return mouse;
}
