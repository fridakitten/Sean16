//
//  CursorTracker.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CursorTracker : NSObject

@property (nonatomic, assign) NSPoint cursorPosition;
@property (nonatomic, assign) NSInteger lastMouseButtonState;
@property (nonatomic, weak) NSWindow *window;

// Designated initializer
- (instancetype)initWithWindow:(NSWindow *)window;

// Methods for tracking the cursor and mouse events
- (NSPoint *)getCursorPosition;
- (void)startTracking;
- (void)stopTracking;
- (void)setInit:(BOOL)value;
- (void)unhideCursor;
- (void)hideCursor;

// Methods for mouse button state
- (NSInteger *)getLastMouseButtonState;

@end

NS_ASSUME_NONNULL_END

CursorTracker * _Nullable getTracker(void * _Nullable arg);
