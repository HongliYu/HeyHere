//
//  UIButton+EnlargeEdge.h
//  BaiduBrowser
//
//  Created by 虞鸿礼 on 15/10/20.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat)size;
- (void)setEnlargeEdgeWithTop:(CGFloat)top
                        right:(CGFloat)right
                       bottom:(CGFloat)bottom
                         left:(CGFloat)left;

@end
