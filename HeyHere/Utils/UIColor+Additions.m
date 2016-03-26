//
//  UIColor+Additions.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned long colorHex = strtoul([hexString UTF8String], 0, 16);
    return [self colorWithHex:colorHex];
}

+ (UIColor *)colorWithHex:(NSUInteger)hex {
    NSUInteger a = 0xFF;
    if (hex > 0xFFFFFF) {
        a = (hex >> 24) & 0xFF;
    }
    NSUInteger r = (hex >> 16) & 0xFF;
    NSUInteger g = (hex >> 8 ) & 0xFF;
    NSUInteger b = hex & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

+ (UIColor *)colorWithRGBA:(NSInteger)red
                     green:(NSInteger)green
                      blue:(NSInteger)blue
                     alpha:(NSInteger)alpha {
    return [self colorWithRed:(red / 255.0f)
                        green:(green / 255.0f)
                         blue:(blue / 255.0f)
                        alpha:(alpha / 255.0f)];
}

+ (NSString *)hexStringFromColor:(UIColor *)color {
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r, g, b, a;
    if (colorSpace == kCGColorSpaceModelMonochrome) {
      r = components[0];
      g = components[0];
      b = components[0];
      a = components[1];
    } else if (colorSpace == kCGColorSpaceModelRGB) {
      r = components[0];
      g = components[1];
      b = components[2];
      a = components[3];
    }
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255)];
}

@end
