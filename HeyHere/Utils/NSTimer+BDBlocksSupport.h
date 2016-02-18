//
//  NSTimer+BDBlocksSupport.h
//  BaiduBrowser
//
//  Created by 虞鸿礼 on 15/8/20.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BDBlocksSupport)

+ (NSTimer *)bd_scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;

@end
