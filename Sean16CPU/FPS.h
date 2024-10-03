//
//  FPS.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 03.10.24.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreVideo/CoreVideo.h>

@interface FPSCounter : NSObject

@property (nonatomic, assign) NSInteger frameCount;         // To track the number of frames rendered
@property (nonatomic, assign) CFTimeInterval lastTimeStamp; // To track the time of the last FPS update
@property (nonatomic, weak) NSWindow *window;               // Reference to the NSWindow whose title will be updated

// Initialize the FPSCounter with an NSWindow
- (instancetype)initWithWindow:(NSWindow *)window;

// Start tracking FPS and updating the window title
- (void)startTrackingFPS;

// Stop tracking FPS
- (void)stopTrackingFPS;

@end
