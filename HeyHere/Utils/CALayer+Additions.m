//
//  CALayer+Additions.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
