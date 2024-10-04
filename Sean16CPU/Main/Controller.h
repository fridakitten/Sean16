//
//  Controller.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 04.10.24.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Controller : NSObject <NSWindowDelegate>

@property (nonatomic, weak) NSWindow *window;
@property (nonatomic, weak) NSWindow *logwindow;

- (void) menuInit:(NSWindow*)window logwindow:(NSWindow*)logwindow;
- (void) openimg:(id)sender;

@end
