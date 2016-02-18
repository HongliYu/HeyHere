//
//  HHColor.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHColor : NSObject

@property (nonatomic, copy, readonly) NSString *colorString;
@property (nonatomic, copy, readonly) NSString *colorDesc;

- (instancetype)initWithColorString:(NSString *)colorString
                          colorDesc:(NSString *)colorDesc;

@end
