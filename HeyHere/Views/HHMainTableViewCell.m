//
//  HHMainTableViewCell.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/22.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHMainTableViewCell.h"
#import "HHColorViewModel.h"

@implementation HHMainTableViewCell

- (void)bindData:(HHColorViewModel *)colorViewModel {
    if (colorViewModel.colorString) {
        self.backgroundColor = [UIColor colorWithHexString:colorViewModel.colorString];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
