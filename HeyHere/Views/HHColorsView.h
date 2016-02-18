//
//  HHColorsView.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/29.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHColors;

@interface HHColorsView : UIView

@property (nonatomic, strong, readonly) HHColors *colors;
- (void)bindData:(HHColors *)colors;

@end
