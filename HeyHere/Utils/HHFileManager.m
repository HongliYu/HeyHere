//
//  HHFileManager.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHFileManager.h"

@implementation HHFileManager

+ (NSString *)LibraryDirectory {
    return [NSSearchPathForDirectoriesInDomains(
                                                NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)DocumentDirectory {
    //    NSString * documentsDirectory = [NSHomeDirectory()
    //    stringByAppendingPathComponent:@"Documents"];
    //    NSString *filePath= [documentsDirectory
    //    stringByAppendingPathComponent:fileName];
    return [NSSearchPathForDirectoriesInDomains(
                                                NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)PreferencePanesDirectory {
    return [NSSearchPathForDirectoriesInDomains(
                                                NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)CachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(
                                                NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)CreateFile:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager createDirectoryAtPath:filePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
    if ([fileManager fileExistsAtPath:filePath] == NO) {
        if ([fileManager createFileAtPath:filePath contents:nil attributes:nil] ==
            NO) {
            NSLog(@"Unable to create file: %@", [error localizedDescription]);
        }
    }
}

+ (void)WriteContent:(NSString *)content toFile:(NSString *)filePath {
    NSError *error;
    if ([content writeToFile:filePath
                  atomically:YES
                    encoding:NSUTF8StringEncoding
                       error:&error] == NO) {
        NSLog(@"Unable to wirite content: %@", [error localizedDescription]);
    }
}

+ (void)renameFile:(NSString *)originalPath to:(NSString *)newPath {
    //通过移动该文件对文件重命名
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager moveItemAtPath:originalPath toPath:newPath error:&error] ==
        NO) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
}

+ (void)removeFile:(NSString *)filePath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
        NSLog(@"Unable to remove file: %@", [error localizedDescription]);
    }
}

+ (void)removeAll:(NSString *)filePath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents =
    [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([fileManager
             removeItemAtPath:[filePath stringByAppendingPathComponent:filename]
             error:NULL] == NO) {
            NSLog(@"Unable to remove files: %@", [error localizedDescription]);
        }
    }
}

+ (NSArray *)FileAttributes:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes =
    [fileManager attributesOfFileSystemForPath:filePath error:nil];
    if (fileAttributes != nil) {
        NSNumber *fileSize;
        NSString *fileOwner, *creationDate;
        NSDate *fileModDate;
        // NSString *NSFileCreationDate
        //文件大小
        if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
            NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
        }
        //文件创建日期
        if ((creationDate = [fileAttributes objectForKey:NSFileCreationDate])) {
            NSLog(@"File creationDate: %@\n", creationDate);
            // textField.text=NSFileCreationDate;
        }
        //文件所有者
        if ((fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName])) {
            NSLog(@"Owner: %@\n", fileOwner);
        }
        //文件修改日期
        if ((fileModDate = [fileAttributes objectForKey:NSFileModificationDate])) {
            NSLog(@"Modification date: %@\n", fileModDate);
        }
    } else {
        NSLog(@"Path (%@) is invalid.", filePath);
    }
    return nil;
}

+ (NSString *)FileContentToString:(NSString *)filePath {
    NSError *error;
    NSString *textFileContents =
    [NSString stringWithContentsOfFile:filePath
                              encoding:NSUTF8StringEncoding
                                 error:&error];
    if (textFileContents == nil) {
        NSLog(@"Error reading text file: %@", [error localizedFailureReason]);
    }
    return textFileContents;
}

+ (void)PrintContent:(NSString *)filePath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"File Array: %@",
          [fileManager contentsOfDirectoryAtPath:filePath error:&error]);
}

+ (double)sizeWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dir = NO;
    BOOL exits = [fileManager fileExistsAtPath:filePath isDirectory:&dir];
    if (!exits) {
        return 0;
    }
    if (dir) {  // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [fileManager subpathsAtPath:filePath];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [filePath stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [fileManager fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) {
                NSDictionary *attrs =
                [fileManager attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1000 * 1000.0);
    } else {  // 文件
        NSDictionary *attrs =
        [fileManager attributesOfItemAtPath:filePath error:nil];
        return [attrs[NSFileSize] intValue] / (1000 * 1000.0);
    }
}

@end
