//
//  fs-init.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 05.10.24.
//

#import "fs.h"

VirtualFileSystem *vfs;

// head functions
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

// management functions
void fs_mkdir(char *path) {
    vfs_mkdir(vfs.rootDirectory, [NSString stringWithFormat:@"%s", path]);
}

void fs_rmdir(char *path) {
    vfs_rmdir(vfs.rootDirectory, [NSString stringWithFormat:@"%s", path]);
}

void fs_cfile(char *path, char *content) {
    vfs_create_file(vfs.rootDirectory, [NSString stringWithFormat:@"%s", path], [[NSString stringWithFormat:@"%s", content] dataUsingEncoding:NSUTF8StringEncoding]);
}

void fs_dfile(char *path) {
    vfs_delete_file(vfs.rootDirectory, [NSString stringWithFormat:@"%s", path]);
}
