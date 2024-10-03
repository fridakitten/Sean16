#import <Cocoa/Cocoa.h>
#import <Display/Display.h>
#import <Foundation/Foundation.h>
#import "Sean16.main.h"

// Declare the AppDelegate class
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextField *label;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // This method is called when the application has finished launching
    NSLog(@"Application has launched!");
    
    // Set the label's text
    [self.label setStringValue:@"Hello, World!"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // This method is called when the application is about to terminate
    NSLog(@"Application is about to terminate!");
}

@end

// Main function - entry point of the application
int main(int argc, const char * argv[]) {
    // Create the application instance
    NSApplication *app = [NSApplication sharedApplication];
    
    // Create the AppDelegate instance
    AppDelegate *delegate = [[AppDelegate alloc] init];
    
    // Set the delegate for the application
    [app setDelegate:delegate];
    
    // Load the main window from the xib file
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 510, 510)
                                                   styleMask:(NSWindowStyleMaskTitled |
                                                              NSWindowStyleMaskClosable)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    
    MyScreenEmulatorView *screen = getEmulator();
    
    // Set the frame size of the view (original resolution)
    [screen setFrame:NSMakeRect(0, 0, 510, 510)];

    [window.contentView addSubview:screen];
    [window setTitle:@"Sean16"];
    
    // Make the window visible
    [window makeKeyAndOrderFront:nil];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *executablePath = [NSString stringWithFormat:@"%@/output.bin", [mainBundle resourcePath]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        kickstart(executablePath, window);
    });

    // Run the application
    return NSApplicationMain(argc, argv);
}
