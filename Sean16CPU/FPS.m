//
//  FPS.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 03.10.24.
//

#import <Cocoa/Cocoa.h>
#import <CoreVideo/CoreVideo.h>

@interface FPSCounter : NSObject {
    CVDisplayLinkRef displayLink;
}

@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic, assign) CFTimeInterval lastTimeStamp;
@property (nonatomic, weak) NSWindow *window;

- (instancetype)initWithWindow:(NSWindow *)window;
- (void)startTrackingFPS;
- (void)stopTrackingFPS;

@end

@implementation FPSCounter

// Callback function for CVDisplayLink
static CVReturn displayLinkCallback(CVDisplayLinkRef displayLink,
                                    const CVTimeStamp* now,
                                    const CVTimeStamp* outputTime,
                                    CVOptionFlags flagsIn,
                                    CVOptionFlags* flagsOut,
                                    void* displayLinkContext) {
    // Call the method in the FPSCounter object to update FPS
    FPSCounter *fpsCounter = (__bridge FPSCounter*)displayLinkContext;
    [fpsCounter updateFPS];
    return kCVReturnSuccess;
}

- (instancetype)initWithWindow:(NSWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
        self.frameCount = 0;
        self.lastTimeStamp = 0;
    }
    return self;
}

- (void)startTrackingFPS {
    // Create and configure the CVDisplayLink
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, &displayLinkCallback, (__bridge void * _Nullable)(self));
    CVDisplayLinkStart(displayLink);
}

- (void)stopTrackingFPS {
    // Stop the CVDisplayLink
    if (displayLink) {
        CVDisplayLinkStop(displayLink);
        CVDisplayLinkRelease(displayLink);
        displayLink = NULL;
    }
}

- (void)updateFPS {
    CFTimeInterval currentTime = [self getCurrentTime];

    if (self.lastTimeStamp == 0) {
        self.lastTimeStamp = currentTime;
        return;
    }

    self.frameCount += 1;
    CFTimeInterval elapsedTime = currentTime - self.lastTimeStamp;

    if (elapsedTime >= 1.0) {
        double fps = (double)self.frameCount / elapsedTime;
        self.frameCount = 0;
        self.lastTimeStamp = currentTime;

        // Update the window title with the current FPS
        dispatch_async(dispatch_get_main_queue(), ^{
            self.window.title = [NSString stringWithFormat:@"Sean16 [FPS: %.1f]", fps];
        });
    }
}

// Helper method to get the current time
- (CFTimeInterval)getCurrentTime {
    return CFAbsoluteTimeGetCurrent();
}

@end
