//
//  KeyboardTracker.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 30.09.24.
//

#import "KeyboardTracker.h"
#import <Cocoa/Cocoa.h>

@interface KeyboardTracker ()

@property (nonatomic, strong) id eventMonitor;  // Store the event monitor

@end

@implementation KeyboardTracker

+ (instancetype)sharedTracker {
    static KeyboardTracker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KeyboardTracker alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lastKeyPressed = @"";
    }
    return self;
}

- (void)startTracking {
    if (!self.eventMonitor) {
        // Create a global monitor for key down events
        self.eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskKeyDown
                                                                   handler:^(NSEvent *event) {
            // Capture the pressed key
            NSString *pressedKey = event.charactersIgnoringModifiers;
            if (pressedKey.length > 0) {
                self.lastKeyPressed = pressedKey;
                NSLog(@"Last key pressed: %@", self.lastKeyPressed);
            }
        }];
        
        NSLog(@"Keyboard tracking started.");
    }
}

- (void)stopTracking {
    if (self.eventMonitor) {
        // Remove the event monitor when stopping
        [NSEvent removeMonitor:self.eventMonitor];
        self.eventMonitor = nil;
        
        NSLog(@"Keyboard tracking stopped.");
    }
}

@end
