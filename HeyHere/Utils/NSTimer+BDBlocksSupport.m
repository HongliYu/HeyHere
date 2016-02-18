//
//  NSTimer+BDBlocksSupport.m
//  BaiduBrowser
//
//  Created by 虞鸿礼 on 15/8/20.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import "NSTimer+BDBlocksSupport.h"

@implementation NSTimer (BDBlocksSupport)

+ (NSTimer *)bd_scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(bd_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)bd_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}

@end