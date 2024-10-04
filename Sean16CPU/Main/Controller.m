//
//  Controller.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 04.10.24.
//

#import "../Sean16.main.h"
#import "Controller.h"

@implementation Controller : NSObject

- (void) menuInit:(NSWindow *)window {
    NSMenu      *menu;
    NSMenuItem  *menuItem;

    [NSApp setMainMenu:[[NSMenu alloc] init]];

    // Application menu
    menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Quit Sean16CPU" action:@selector(terminate:) keyEquivalent:@"q"];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Apple" action:nil keyEquivalent:@""];
    [menuItem setSubmenu:menu];
    [[NSApp mainMenu] addItem:menuItem];
    
    // Utility Menu - CPU
    menu = [[NSMenu alloc] initWithTitle:@"CPU"];
    
    // Here, ensure that the selector matches the method signature `openimg:`
    [menu addItemWithTitle:@"Run Executable" action:@selector(openimg:) keyEquivalent:@""];
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"CPU" action:nil keyEquivalent:@""];
    [menuItem setSubmenu:menu];
    [[NSApp mainMenu] addItem:menuItem];
}

- (void) openimg:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:@[@"bin"]];

    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSURL *fileURL = [[panel URLs] firstObject];
            NSLog(@"running: %@", fileURL.path);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                kickstart(fileURL.path);
            });
        }
    }];
}

@end
