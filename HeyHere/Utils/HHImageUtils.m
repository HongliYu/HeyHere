//
//  HHImageUtils.m
//  HeyHere
//
//  Created by HongliYu on 16/3/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHImageUtils.h"

@implementation HHImageUtils

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
