//
//  Display.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import "Display.h"
#import <AppKit/AppKit.h> // Ensure AppKit is imported

#define SCREEN_WIDTH 254
#define SCREEN_HEIGHT 159
#define COLOR_COUNT 256  // Support for 256 colors

MyScreenEmulatorView *screen = NULL;

NSColor *colorPalette[COLOR_COUNT];  // Array to store 256 colors

@interface MyScreenEmulatorView () {
    NSInteger pixelData[SCREEN_WIDTH][SCREEN_HEIGHT]; // 2D array to store pixel color data
}
@end

@implementation MyScreenEmulatorView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize all pixels to "off" (color index -1)
        memset(pixelData, -1, sizeof(pixelData));
        
        // Initialize the color palette
        [self initializeColorPalette];
        
        //[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateCursor) userInfo:nil repeats:YES];
    }
    return self;
}

// Method to initialize the traditional 256 color palette
- (void)initializeColorPalette {
    // Define the basic 16 colors
    NSColor *basicColors[16] = {
        [NSColor blackColor],       // 0: Black
        [NSColor redColor],         // 1: Red
        [NSColor greenColor],       // 2: Green
        [NSColor blueColor],        // 3: Blue
        [NSColor yellowColor],      // 4: Yellow
        [NSColor magentaColor],     // 5: Magenta
        [NSColor colorWithCalibratedRed:0.0 green:1.0 blue:1.0 alpha:1.0], // 6: Cyan
        [NSColor whiteColor],       // 7: White
        [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0], // 8: Gray
        [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], // 9: Light Red
        [NSColor colorWithCalibratedRed:0.0 green:0.75 blue:0.0 alpha:1.0], // 10: Light Green
        [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.75 alpha:1.0], // 11: Light Blue
        [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.0 alpha:1.0], // 12: Light Yellow
        [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.75 alpha:1.0], // 13: Light Magenta
        [NSColor colorWithCalibratedRed:0.0 green:0.75 blue:0.75 alpha:1.0], // 14: Light Cyan
        [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.75 alpha:1.0]  // 15: Light Gray
    };

    // Fill the first 16 colors
    for (int i = 0; i < 16; i++) {
        colorPalette[i] = basicColors[i];
    }
    
    // Fill in bright variants of the first 16 colors
    for (int i = 0; i < 16; i++) {
        colorPalette[i + 16] = [basicColors[i] colorWithAlphaComponent:0.7]; // Use alpha for a brighter look
    }

    // Fill in the rest of the colors (224 colors)
    int index = 32;
    for (int r = 0; r < 6; r++) { // Red
        for (int g = 0; g < 6; g++) { // Green
            for (int b = 0; b < 6; b++) { // Blue
                if (index < COLOR_COUNT) {
                    CGFloat red = (CGFloat)r / 5.0;
                    CGFloat green = (CGFloat)g / 5.0;
                    CGFloat blue = (CGFloat)b / 5.0;
                    colorPalette[index++] = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
                }
            }
        }
    }
}

- (BOOL)isFlipped {
    return YES;  // Ensure (0, 0) is in the top-left corner
}

- (void)clearScreen {
    memset(pixelData, -1, sizeof(pixelData)); // Reset all pixels to "off"
}

- (void)setPixelAtX:(int)x Y:(int)y colorIndex:(NSInteger)colorIndex {
    if (x < 0 || x >= SCREEN_WIDTH || y < 0 || y >= SCREEN_HEIGHT || colorIndex < 0 || colorIndex >= COLOR_COUNT) {
        return; // Boundary check
    }
    pixelData[x][y] = colorIndex;  // Set pixel color index
    [self setNeedsDisplay:YES];  // Request redraw
}

- (void)drawRect:(NSRect)dirtyRect {
    // Fill the entire view with black (or clear)
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    
    for (int x = 0; x < SCREEN_WIDTH; x++) {
        for (int y = 0; y < SCREEN_HEIGHT; y++) {
            NSInteger colorIndex = pixelData[x][y];
            if (colorIndex != -1) { // Only draw if the color index is valid
                NSRect pixelRect = NSMakeRect(x, y, 1, 1);
                [colorPalette[colorIndex] setFill];  // Set color for the pixel
                NSRectFill(pixelRect);  // Draw the pixel
            }
        }
    }
}

- (NSInteger)getPixelDataAtX:(int)x y:(int)y {
    return pixelData[x][y];
}

- (void)drawCursorAtPosition:(NSPoint)position {
    // Draw a simple cursor as a rectangle at the cursor position
    [[NSColor whiteColor] setFill];
    NSRect cursorRect = NSMakeRect(position.x, position.y, 2, 2); // Cursor size
    NSRectFill(cursorRect); // Draw the cursor
}

@end

MyScreenEmulatorView *getEmulator(void) {
    if (!screen) {
        screen = [[MyScreenEmulatorView alloc] init];
    }
    
    return screen;
}
