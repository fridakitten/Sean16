//
//  fs.h
//  Sean16CPU
//
//  Created by Frida Boleslawska on 05.10.24.
//

#import <Foundation/Foundation.h>

#define BLOCK_SIZE 512
#define MAX_FILES 100
#define FS_MAGIC 0xF1F2F3F4

typedef struct {
    uint32_t magic;
    uint32_t blockCount;
    uint32_t freeBlocks;
} FileSystemMetadata;

@interface VFSFile : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, assign) NSUInteger startBlock;
@property (nonatomic, strong) NSData *content;
@end

@interface VFSDirectory : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray<VFSFile *> *files;
@property (nonatomic, strong) NSMutableArray<VFSDirectory *> *directories;
@end

@interface VirtualFileSystem : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, assign) NSUInteger totalSize;
@property (nonatomic, strong) VFSDirectory *rootDirectory;

- (instancetype)initWithFilePath:(NSString *)path size:(NSUInteger)size;
- (void)formatFileSystem;

@end

void fs_init(void);
