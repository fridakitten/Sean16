#import <Cocoa/Cocoa.h>
#import <Peripherals/Display/Display.h>
#import <Peripherals/Mouse/Mouse.h>
#import <Foundation/Foundation.h>
#import "Sean16.main.h"
#import "FPS.h"
#import "Controller.h"

int main(int argc, const char * argv[]) {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 510, 510)
                                                   styleMask:(NSWindowStyleMaskTitled)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    // Controller Setup
    Controller *control = [Controller alloc];
    [control menuInit:window];
    [window setDelegate: control];
    
    // Settings
    [window setTitle:@"Sean16"];
    
    
    
    // Periphal Screen
    MyScreenEmulatorView *screen = getEmulator();
    [screen setFrame:NSMakeRect(0, 0, 510, 510)];
    [window.contentView addSubview:screen];
    
    // Mouse
    getTracker((__bridge void*)window);
    
    // FPS Counter
    FPSCounter *fps = [[FPSCounter alloc] initWithWindow:window];
    [fps startTrackingFPS];
    
    // Window is ready 2go
    [window makeKeyAndOrderFront:nil];

    return NSApplicationMain(argc, argv);
}
