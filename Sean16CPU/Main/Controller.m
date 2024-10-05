//
//  Controller.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 04.10.24.
//

#import "../Sean16.main.h"
#import "Controller.h"
#import "Console.h"

@implementation Controller : NSObject

- (void) menuInit:(NSWindow*)window logwindow:(NSWindow*)logwindow {
    NSMenu      *menu;
    NSMenuItem  *menuItem;

    [NSApp setMainMenu:[[NSMenu alloc] init]];

    // Application menu
    menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Quit Sean16CPU" action:@selector(terminate:) keyEquivalent:@"q"];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Apple" action:nil keyEquivalent:@""];
    [menuItem setSubmenu:menu];
    [[NSApp mainMenu] addItem:menuItem];
    
    menu = [[NSMenu alloc] initWithTitle:@"File"];
    [menu addItemWithTitle:@"Open" action:@selector(openimg:) keyEquivalent:@""];
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"CPU" action:nil keyEquivalent:@""];
    [menuItem setSubmenu:menu];
    [[NSApp mainMenu] addItem:menuItem];
    
    menu = [[NSMenu alloc] initWithTitle:@"Log"];
    [menu addItemWithTitle:@"Show Log" action:@selector(showlog:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Hide Log" action:@selector(hidelog:) keyEquivalent:@""];
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Log" action:nil keyEquivalent:@""];
    [menuItem setSubmenu:menu];
    [[NSApp mainMenu] addItem:menuItem];
    
    _window = window;
    _logwindow = logwindow;
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

- (void) showlog:(id)sender {
    [_logwindow makeKeyAndOrderFront:nil];
}

- (void) hidelog:(id)sender {
    [_logwindow orderOut:nil];
}

@end
