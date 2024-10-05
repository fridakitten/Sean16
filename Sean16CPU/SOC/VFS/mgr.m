//
//  fs-init.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 05.10.24.
//

#import "fs.h"

VirtualFileSystem *vfs;

void fs_init(void) {
    if(vfs == NULL) {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [resourcePath stringByAppendingPathComponent:@"virtualFS.dat"];
        NSUInteger fsSize = 10 * 1024 * 1024;
        vfs = [[VirtualFileSystem alloc] initWithFilePath:filePath size:fsSize];
        [vfs formatFileSystem];
    }
}

void fs_format(void) {
    if(vfs == NULL) {
        [vfs formatFileSystem];
    }
}