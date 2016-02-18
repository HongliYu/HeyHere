//
//  HHMainManager.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HHColors;
@class HHColorViewModel;

@interface HHMainManager : NSObject
DEFINE_SINGLETON_FOR_HEADER(HHMainManager);

@property (nonatomic, strong, readonly) NSMutableArray *mainColors;
@property (nonatomic, assign, readonly) NSInteger currentColorsIndex;
@property (nonatomic, assign, readonly) NSTimeInterval blinkTimeInterval;
@property (nonatomic, strong, readonly) HHColors *currentColors;
@property (nonatomic, strong, readonly) HHColorViewModel *currentColorViewModel;
@property (nonatomic, strong, readonly) HHColorViewModel *quickBlinkColorViewModel;

@property (nonatomic, copy) void (^dataReadyCallBack)(); // 异步加载数据预留接口
@property (nonatomic, copy) void (^mainColorsChangedCallBack)();

- (void)creatBaseData;
- (void)createLogger;

/**
 *  增、删、改、查、持久化
 */
- (void)addColors:(HHColors *)colors;
- (void)deleteColors:(HHColors *)colors;
- (void)updateColors:(HHColors *)colors
       withNewColors:(HHColors *)newColors;
- (HHColors *)selectColorsWithColorsID:(NSString *)colorID;

- (void)setCurrentViewModel:(HHColorViewModel *)currentColorViewModel;
- (void)setCurrentColors:(HHColors *)currentColors;
- (void)setCurrentColorsIndex:(NSInteger)currentColorsIndex;
- (void)setQuickBlinkColorViewModel:(HHColorViewModel *)quickBlinkColorViewModel;
- (void)setBlinkTimeInterval:(NSTimeInterval)blinkTimeInterval;

- (void)handleQuickBlinkActionWithVC:(UIViewController *)viewController;

@end
