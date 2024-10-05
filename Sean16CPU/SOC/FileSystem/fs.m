//
//  fs.m
//  Sean16CPU
//
//  Created by Frida Boleslawska on 05.10.24.
//

#import "fs.h"

@implementation VFSDirectory
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _files = [NSMutableArray array];
        _directories = [NSMutableArray array];
    }
    return self;
}
@end

@implementation VFSFile
@end

@implementation VirtualFileSystem

- (instancetype)initWithFilePath:(NSString *)path size:(NSUInteger)size {
    if (self = [super init]) {
        _filePath = path;
        _totalSize = size;
        _rootDirectory = [[VFSDirectory alloc] initWithName:@"/"];
        
        // Create an empty data block (the virtual file system)
        NSMutableData *data = [NSMutableData dataWithLength:size];
        [data writeToFile:path atomically:YES];
        
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        if (!_fileHandle) {
            NSLog(@"Failed to open virtual file system.");
            return nil;
        }
    }
    return self;
}

// Format the virtual file system
- (void)formatFileSystem {
    FileSystemMetadata metadata;
    metadata.magic = FS_MAGIC;
    metadata.blockCount = (uint32_t)(self.totalSize / BLOCK_SIZE);
    metadata.freeBlocks = metadata.blockCount - 1;
    
    NSData *metadataData = [NSData dataWithBytes:&metadata length:sizeof(FileSystemMetadata)];
    
    // Write metadata to the first block (block 0)
    [self.fileHandle seekToFileOffset:0];
    [self.fileHandle writeData:metadataData];
    
    NSLog(@"Formatted the file system with %u blocks.", metadata.blockCount);
}

@end

// VFS Utility functions
void vfs_mkdir(VFSDirectory *parentDir, NSString *dirName) {
    VFSDirectory *newDir = [[VFSDirectory alloc] initWithName:dirName];
    [parentDir.directories addObject:newDir];
    NSLog(@"Directory '%@' created.", dirName);
}

void vfs_rmdir(VFSDirectory *parentDir, NSString *dirName) {
    for (VFSDirectory *dir in parentDir.directories) {
        if ([dir.name isEqualToString:dirName]) {
            [parentDir.directories removeObject:dir];
            NSLog(@"Directory '%@' removed.", dirName);
            return;
        }
    }
    NSLog(@"Directory '%@' not found.", dirName);
}

void vfs_create_file(VFSDirectory *parentDir, NSString *fileName, NSData *content) {
    VFSFile *newFile = [[VFSFile alloc] init];
    newFile.name = fileName;
    newFile.size = content.length;
    newFile.content = content;
    [parentDir.files addObject:newFile];
    NSLog(@"File '%@' created.", fileName);
}

void vfs_delete_file(VFSDirectory *parentDir, NSString *fileName) {
    for (VFSFile *file in parentDir.files) {
        if ([file.name isEqualToString:fileName]) {
            [parentDir.files removeObject:file];
            NSLog(@"File '%@' deleted.", fileName);
            return;
        }
    }
    NSLog(@"File '%@' not found.", fileName);
}

void vfs_list_dir(VFSDirectory *dir) {
    NSLog(@"Listing directory: %@", dir.name);
    for (VFSDirectory *subdir in dir.directories) {
        NSLog(@"[DIR] %@", subdir.name);
    }
    for (VFSFile *file in dir.files) {
        NSLog(@"[FILE] %@ (%lu bytes)", file.name, (unsigned long)file.size);
    }
}

NSData *vfs_read_file(VFSDirectory *parentDir, NSString *fileName) {
    for (VFSFile *file in parentDir.files) {
        if ([file.name isEqualToString:fileName]) {
            NSLog(@"Reading file '%@'", fileName);
            return file.content;
        }
    }
    NSLog(@"File '%@' not found.", fileName);
    return nil;
}

void vfs_write_file(VFSDirectory *parentDir, NSString *fileName, NSData *content) {
    for (VFSFile *file in parentDir.files) {
        if ([file.name isEqualToString:fileName]) {
            file.content = content;
            file.size = content.length;
            NSLog(@"Wrote data to file '%@'", fileName);
            return;
        }
    }
    NSLog(@"File '%@' not found.", fileName);
}

/*int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Locate the Resources directory path (for development purposes)
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [resourcePath stringByAppendingPathComponent:@"virtualFS.dat"];
        
        // Specify size of the virtual file system (e.g., 10 MB)
        NSUInteger fsSize = 10 * 1024 * 1024; // 10 MB
        
        // Create and format the virtual file system
        VirtualFileSystem *vfs = [[VirtualFileSystem alloc] initWithFilePath:filePath size:fsSize];
        [vfs formatFileSystem];
        
        // File system operations
        vfs_mkdir(vfs.rootDirectory, @"Documents");
        vfs_mkdir(vfs.rootDirectory, @"Downloads");
        vfs_create_file(vfs.rootDirectory, @"file1.txt", [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding]);
        
        // List directory contents
        vfs_list_dir(vfs.rootDirectory);
        
        // Read and write file
        NSData *readContent = vfs_read_file(vfs.rootDirectory, @"file1.txt");
        NSLog(@"Read content: %@", [[NSString alloc] initWithData:readContent encoding:NSUTF8StringEncoding]);
        
        // Write new content to file
        vfs_write_file(vfs.rootDirectory, @"file1.txt", [@"New Content" dataUsingEncoding:NSUTF8StringEncoding]);
        
        // List directory again
        vfs_list_dir(vfs.rootDirectory);
        
        // Remove a directory
        vfs_rmdir(vfs.rootDirectory, @"Downloads");
        vfs_list_dir(vfs.rootDirectory);
        
        // Close the file system
        [vfs.fileHandle closeFile];
    }
    return 0;
}*/
