//
//  KeyboardTracker.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 30.09.24.
//

#import <Foundation/Foundation.h>

@interface KeyboardTracker : NSObject

@property (nonatomic, strong) NSString *lastKeyPressed;

+ (instancetype)sharedTracker;
- (void)startTracking;
- (void)stopTracking;

@end
