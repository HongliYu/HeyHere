//
//  HHColor.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHColor.h"

@interface HHColor() <NSCopying, NSCoding>

@property (nonatomic, copy, readwrite) NSString *colorString;
@property (nonatomic, copy, readwrite) NSString *colorDesc;

@end

@implementation HHColor

- (instancetype)initWithColorString:(NSString *)colorString
                          colorDesc:(NSString *)colorDesc{
    self = [super init];
    if (self) {
        _colorString = [colorString copy];
        _colorDesc = [colorDesc copy];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;
    _colorString = [coder decodeObjectForKey:@"colorString"];
    _colorDesc = [coder decodeObjectForKey:@"colorDesc"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.colorString != nil) [coder encodeObject:self.colorString forKey:@"colorString"];
    if (self.colorDesc != nil) [coder encodeObject:self.colorDesc forKey:@"colorDesc"];
}

- (id)copyWithZone:(NSZone *)zone {
    HHColor *color = [[self.class allocWithZone:zone] init];
    color->_colorString = self.colorString;
    color->_colorDesc = self.colorDesc;
    return color;
}

- (NSUInteger)hash {
    return self.colorString.hash ^ self.colorDesc.hash;
}

- (BOOL)isEqual:(HHColor *)color {
    if (![color isKindOfClass:HHColor.class]) return NO;
    return [self.colorString isEqualToString:color.colorString];
}

@end
