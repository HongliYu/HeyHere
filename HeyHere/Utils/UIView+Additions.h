//
//  UIView+Additions.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/2/3.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (void)setActionBlock:(void (^)(void))block;
- (id)findFirstResponder;

@end
