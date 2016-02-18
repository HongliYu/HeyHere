//
//  HHDBRoot.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HHColors;

@interface HHDBRoot : NSObject
DEFINE_SINGLETON_FOR_HEADER(HHDBRoot);

typedef void (^mutableArrayComplitionHandler)(NSMutableArray* mainColors);

- (BOOL)checkDatabaseIfNeedRawData;
- (void)createDatabaseWithMainColors:(NSMutableArray *)mainColors;
- (void)restoreDataFromeDataBase:(mutableArrayComplitionHandler)complition;

- (void)addColors:(HHColors *)colors;

@end
