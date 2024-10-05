//
//  Display.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 27.09.24.
//

#import "Display.h"
#import <AppKit/AppKit.h> // Ensure AppKit is imported

#define SCREEN_WIDTH 254
#define SCREEN_HEIGHT 254
#define COLOR_COUNT 256
#define SCALE_FACTOR 2.0

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

- (void)initializeColorPalette {
    // Define the basic 16 colors
    NSColor *basicColors[16] = {
        [NSColor blackColor],       // 0: Black
        [NSColor redColor],         // 1: Red
        [NSColor greenColor],       // 2: Green
        [NSColor blueColor],        // 3: Blue
        [NSColor yellowColor],      // 4: Yellow
        [NSColor magentaColor],     // 5: Magenta
        [NSColor cyanColor],        // 6: Cyan
        [NSColor whiteColor],       // 7: White
        [NSColor darkGrayColor],    // 8: Dark Gray
        [NSColor lightGrayColor],   // 9: Light Gray
        [NSColor brownColor],       // 10: Brown
        [NSColor orangeColor],      // 11: Orange
        [NSColor purpleColor],      // 12: Purple
        [NSColor cyanColor],        // 13: Cyan (light)
        [NSColor magentaColor],     // 14: Magenta (light)
        [NSColor grayColor]         // 15: Gray
    };

    // Fill the first 16 colors
    for (int i = 0; i < 16; i++) {
        colorPalette[i] = basicColors[i];
    }

    // Fill in the rest of the colors
    for (int i = 16; i < COLOR_COUNT; i++) {
        CGFloat red = (CGFloat)((i - 16) / 36) / 5.0;
        CGFloat green = (CGFloat)(((i - 16) / 6) % 6) / 5.0;
        CGFloat blue = (CGFloat)((i - 16) % 6) / 5.0;
        colorPalette[i] = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
    }
}

- (BOOL)isFlipped {
    return YES;  // Ensure (0, 0) is in the top-left corner
}

- (void)clearScreen {
    memset(pixelData, -1, sizeof(pixelData)); // Reset all pixels to "off"
    [self setNeedsDisplay:YES];
}

BOOL isBatchUpdating = NO;

- (void)beginBatchUpdate {
    isBatchUpdating = YES;
}

- (void)endBatchUpdate {
    isBatchUpdating = NO;
    [self setNeedsDisplay:YES];  // Trigger a single redraw after all updates
}

- (void)setPixelAtX:(int)x Y:(int)y colorIndex:(NSInteger)colorIndex {
    pixelData[x][y] = colorIndex;  // Set pixel color index

    if (!isBatchUpdating) {
        CGFloat scaledPixelSize = 1.0 * SCALE_FACTOR;
        NSRect pixelRect = NSMakeRect(x * scaledPixelSize, y * scaledPixelSize, scaledPixelSize, scaledPixelSize);
        [self setNeedsDisplayInRect:pixelRect];  // Redraw just the pixel area
    }
}


- (void)drawRect:(NSRect)dirtyRect {
    // Fill the entire view with black (or clear)
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);

    // Calculate the size of each pixel when scaled
    CGFloat scaledPixelSize = 1.0 * SCALE_FACTOR; // Scale the pixel size

    for (int x = 0; x < SCREEN_WIDTH; x++) {
        for (int y = 0; y < SCREEN_HEIGHT; y++) {
            NSInteger colorIndex = pixelData[x][y];
            if (colorIndex != -1) { // Only draw if the color index is valid
                NSRect pixelRect = NSMakeRect(x * scaledPixelSize, y * scaledPixelSize, scaledPixelSize, scaledPixelSize);
                [colorPalette[colorIndex] setFill];  // Set color for the pixel
                NSRectFill(pixelRect);  // Draw the scaled pixel
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
