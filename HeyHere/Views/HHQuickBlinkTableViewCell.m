//
//  HHQuickBlinkTableViewCell.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/2/1.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHQuickBlinkTableViewCell.h"
#import "HHColor.h"

@implementation HHQuickBlinkTableViewCell

- (void)awakeFromNib {
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.highlightedTextColor = [UIColor blackColor];
    self.backgroundColor = [UIColor blackColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)bindData:(HHColor *)color {
    self.textLabel.text = NSLocalizedString(color.colorDesc, @"");
    self.textLabel.textColor = [UIColor colorWithHexString:color.colorString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
