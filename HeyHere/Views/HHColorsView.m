//
//  HHColorsView.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/29.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHColorsView.h"
#import "HHColors.h"
#import "HHColor.h"

@interface HHColorsView()

@property (nonatomic, strong, readwrite) HHColors *colors;

@end

@implementation HHColorsView

- (instancetype)init {
    self = [super init];
    if (self) {
        _colors = [[HHColors alloc] init];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _colors = [[HHColors alloc] init];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

- (instancetype)initWithColors:(NSMutableArray *)colors {
    self = [super init];
    if (self) {
        _colors = [colors copy];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

- (void)clearData {
    _colors = nil;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    _colors = [[HHColors alloc] init];
    [[self layer] setMasksToBounds:YES];
}

- (void)bindData:(HHColors *)colors {
    _colors = [colors copy];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef currentGraphicsContext = UIGraphicsGetCurrentContext();
    CGRect progressRect = rect;
    CGRect lastSegmentRect  = CGRectZero;
    for (int i = 0; i < _colors.colors.count; i++) {
        HHColor *color = _colors.colors[i];
        if (color.colorString) {
            unsigned long colorHex = strtoul([color.colorString UTF8String], 0, 16);
            CGColorRef color = [UIColor colorWithHex:colorHex].CGColor;
            
            progressRect = rect;
            progressRect.size.width = rect.size.width / (float)_colors.colors.count;
            progressRect.origin.x += lastSegmentRect.origin.x + lastSegmentRect.size.width;
            
            if (progressRect.origin.x > 0)  {
                progressRect.origin.x += 0.20;
            }
            
            lastSegmentRect = progressRect;
            
            [self fillRect:lastSegmentRect
                 withColor:color
                 onContext:currentGraphicsContext];

        }
    }
    self.layer.borderWidth = 1;
    self.layer.borderColor = MAIN_TEXT_COLOR.CGColor;
}

- (void)fillRect:(CGRect)rect
       withColor:(CGColorRef)color
       onContext:(CGContextRef)currentGraphicsContext {
    CGContextAddRect(currentGraphicsContext, rect);
    CGContextSetFillColorWithColor(currentGraphicsContext, color);
    CGContextFillRect(currentGraphicsContext, rect);
}

@end
