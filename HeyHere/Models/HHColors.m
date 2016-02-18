//
//  HHColors.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHColors.h"
#import "HHColor.h"

@interface HHColors() <NSCopying, NSCoding>

@property (nonatomic, copy, readwrite) NSString *colorsID;
@property (nonatomic, copy, readwrite) NSString *colorsName;
@property (nonatomic, copy, readwrite) NSMutableArray *colors;

@end

@implementation HHColors

- (instancetype)initWithDataBaseInfo:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        _colorsID = [dictionary[@"colorsID"] copy];
        _colorsName = [dictionary[@"colorsName"] copy];
        [self parseColorsFromDataBase:[dictionary[@"colorsData"] copy]];
    }
    return self;
}

- (instancetype)initWithPlistInfo:(NSArray *)colorsInfo {
    self = [self init];
    if (self) {
        [self parseColorsFromPlist:colorsInfo];
    }
    return self;
}

- (void)parseColorsFromPlist:(NSArray *)colorsInfo {
    _colors = [[NSMutableArray alloc] initWithCapacity:colorsInfo.count - 1];
    for (int i = 0; i < colorsInfo.count; i++) {
        NSDictionary *tempDic = colorsInfo[i];
        if (i == 0) {
            _colorsID = [[tempDic objectForKey:@"colorsID"] copy];
            _colorsName = [[tempDic objectForKey:@"colorsName"] copy];
        } else {
            NSString *colorString = [[tempDic objectForKey:@"color_string"] copy];
            NSString *colorDesc = [[tempDic objectForKey:@"color_desc"] copy];
            HHColor *color = [[HHColor alloc] initWithColorString:colorString
                                                        colorDesc:colorDesc];
            [_colors addObject:color];
        }
    }
    NSAssert(_colors, @"parse color from plist error");
}

- (void)parseColorsFromDataBase:(NSData *)colorsData {
    _colors = [[NSMutableArray alloc] init];
    _colors = [NSKeyedUnarchiver unarchiveObjectWithData:colorsData];
    NSAssert(_colors, @"parse color from database error");
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;
    _colorsID = [coder decodeObjectForKey:@"colorsID"];
    _colorsName = [coder decodeObjectForKey:@"colorsName"];
    _colors = [coder decodeObjectForKey:@"colors"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.colorsID != nil) [coder encodeObject:self.colorsID forKey:@"colorsID"];
    if (self.colorsName != nil) [coder encodeObject:self.colorsName forKey:@"colorsName"];
    if (self.colors != nil) [coder encodeObject:self.colors forKey:@"colors"];
}

- (id)copyWithZone:(NSZone *)zone {
    HHColors *colors = [[self.class allocWithZone:zone] init];
    colors->_colorsID = self.colorsID;
    colors->_colorsName = self.colorsName;
    colors->_colors = self.colors;
    return colors;
}

- (NSUInteger)hash {
    return self.colorsID.hash ^ self.colorsName.hash;
}

- (BOOL)isEqual:(HHColors *)colors {
    if (![colors isKindOfClass:HHColors.class]) return NO;
    return [self.colorsID isEqualToString:colors.colorsID];
}

- (NSString *)debugDescription {
    return self.colorsName;
}

@end
