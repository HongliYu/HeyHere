//
//  HHColors.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHColors : NSObject

@property (nonatomic, copy, readonly) NSString *colorsID;
@property (nonatomic, copy, readonly) NSString *colorsName;
@property (nonatomic, copy, readonly) NSMutableArray *colors;

- (instancetype)initWithDataBaseInfo:(NSDictionary *)dictionary;
- (instancetype)initWithPlistInfo:(NSArray *)colorsInfo;

@end
