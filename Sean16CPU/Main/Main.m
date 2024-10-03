#import <Cocoa/Cocoa.h>
#import <Display/Display.h>
#import <Foundation/Foundation.h>
#import "Sean16.main.h"
#import "FPS.h"

int main(int argc, const char * argv[]) {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 510, 510)
                                                   styleMask:(NSWindowStyleMaskTitled)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    
    NSMenu      *menu;
    NSMenuItem  *menuItem;

    [NSApp setMainMenu:[[NSMenu alloc] init]];

    // Application menu
    menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Quit Sean16CPU" action:@selector(terminate:) keyEquivalent:@"q"];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Apple" action:nil keyEquivalent:@""];
    [menuItem setSubmenu:menu];
    [[NSApp mainMenu] addItem:menuItem];
    
    // Settings
    [window setTitle:@"Sean16"];
    
    // Periphal Screen
    MyScreenEmulatorView *screen = getEmulator();
    [screen setFrame:NSMakeRect(0, 0, 510, 510)];
    [window.contentView addSubview:screen];
    
    // FPS Counter
    FPSCounter *fps = [[FPSCounter alloc] initWithWindow:window];
    [fps startTrackingFPS];
    
    // Window is ready 2go
    [window makeKeyAndOrderFront:nil];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *executablePath = [NSString stringWithFormat:@"%@/output.bin", [mainBundle resourcePath]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        kickstart(executablePath, window);
    });

    return NSApplicationMain(argc, argv);
}
