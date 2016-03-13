//
//  HHImageUtils.m
//  HeyHere
//
//  Created by HongliYu on 16/3/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHImageUtils.h"

@implementation HHImageUtils

+ (UIImage *)generateHandleImageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 8.f, 8.f);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.f);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, color.CGColor);
  CGContextFillRect(context, CGRectInset(rect, 0, 0));
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

@end
