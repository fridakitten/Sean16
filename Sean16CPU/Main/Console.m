//
// UIConsole.m
//
// Copyright (C) 2023, 2024 SparkleChan and SeanIsTethered
// Copyright (C) 2024 fridakitten
//
// This file is part of FridaCodeManager.
//
// FridaCodeManager is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// FridaCodeManager is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FridaCodeManager. If not, see <https://www.gnu.org/licenses/>.
//

#import "Console.h"

@implementation Console

- (void)loadView {
    // Programmatically create the main view instead of loading from a nib
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 510, 510)];
    [self setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logItems = [NSMutableArray array];

    // Create the scrollable text view to display log messages
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.hasVerticalScroller = YES;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    logTextView = [[NSTextView alloc] initWithFrame:self.view.bounds];
    logTextView.editable = NO;
    logTextView.font = [NSFont fontWithName:@"Menlo" size:9];
    logTextView.textColor = [NSColor labelColor];
    logTextView.backgroundColor = [NSColor controlBackgroundColor];

    [scrollView setDocumentView:logTextView];
    [self.view addSubview:scrollView];

    // Set up the log pipe for capturing logs
    logPipe = [NSPipe pipe];
    NSFileHandle *fileHandle = [logPipe fileHandleForReading];
    
    dup2([[logPipe fileHandleForWriting] fileDescriptor], STDOUT_FILENO);
    dup2([[logPipe fileHandleForWriting] fileDescriptor], STDERR_FILENO);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogData:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:fileHandle];
    [fileHandle readInBackgroundAndNotify];

    // Set buffered output for log streams
    setvbuf(stdout, NULL, _IOLBF, 0);
    setvbuf(stderr, NULL, _IOLBF, 0);
}

// Method for handling incoming log data
- (void)handleLogData:(NSNotification *)notification {
    NSData *logData = notification.userInfo[NSFileHandleNotificationDataItem];
    if (logData.length > 0) {
        NSString *logString = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        if (logString.length > 0) {
            // Clean the log message (similar to filtering out specific messages)
            NSString *cleanedLog = [self filterLogString:logString];
            [self appendLogMessage:cleanedLog];
        }
    }

    // Keep reading the log
    [[notification object] readInBackgroundAndNotify];
}

// Filter method to clean up log output, equivalent to line filtering in Swift
- (NSString *)filterLogString:(NSString *)logString {
    NSMutableString *filteredLog = [NSMutableString string];
    NSArray *lines = [logString componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        if (![line containsString:@"perform implicit import of"]) {
            [filteredLog appendFormat:@"%@\n", line];
        }
    }

    return [filteredLog stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

// Method to append new log message to the text view
- (void)appendLogMessage:(NSString *)message {
    if (message.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.logItems addObject:message];

            // Create an attributed string with the desired font and text color
            NSDictionary *attributes = @{
                NSFontAttributeName: [NSFont fontWithName:@"Menlo" size:9],
                NSForegroundColorAttributeName: [NSColor labelColor]
            };
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", message] attributes:attributes];

            // Append the attributed string to the text view
            [[self->logTextView textStorage] appendAttributedString:attributedString];

            // Scroll to the bottom of the text view
            [self->logTextView scrollRangeToVisible:NSMakeRange(self->logTextView.string.length, 0)];
        });
    }
}

// Method to copy the logs to the clipboard
- (void)copyLogsToClipboard {
    NSString *fullLogText = [self.logItems componentsJoinedByString:@"\n"];
    NSString *cleanedText = [self filterLogString:fullLogText];
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:cleanedText forType:NSPasteboardTypeString];

    // Show copied alert (optional)
    [self showCopyAlert];
}

// Show copy alert (optional)
- (void)showCopyAlert {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Copied"];
    [alert runModal];
}

@end
