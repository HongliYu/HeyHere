//
//  HHFileManager.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFileManager : NSObject

/** 打印filePath目录下所有内容 */
+ (void)PrintContent:(NSString *)filePath;

/** 读取文件内容操作 */
+ (NSString *)FileContentToString:(NSString *)filePath;

/** 获得文件的属性 */
+ (NSArray *)FileAttributes:(NSString *)filePath;

/** 删除目录下所有文件 */
+ (void)removeAll:(NSString *)filePath;

/** 删除一个文件 */
+ (void)removeFile:(NSString *)filePath;

/** 对文件重命名 */
+ (void)renameFile:(NSString *)originalPath to:(NSString *)newPath;

/** 给文件写入文本内容 */
+ (void)WriteContent:(NSString *)content toFile:(NSString *)filePath;

/** 创建文件 */
+ (void)CreateFile:(NSString *)filePath;

/** 返回path路径下文件的文件大小*/
+ (double)sizeWithFilePath:(NSString *)filePath;

+ (NSString *)LibraryDirectory;
+ (NSString *)DocumentDirectory;
+ (NSString *)PreferencePanesDirectory;
+ (NSString *)CachesDirectory;

@end
