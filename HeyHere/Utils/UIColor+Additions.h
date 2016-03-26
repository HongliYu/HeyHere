//
//  UIColor+Additions.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHex:(NSUInteger)hex;
+ (UIColor *)colorWithRGBA:(NSInteger)red
                     green:(NSInteger)green
                      blue:(NSInteger)blue
                     alpha:(NSInteger)alpha;
+ (NSString *)hexStringFromColor:(UIColor *)color;

@end
