//
//  HHMainManager.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHMainManager.h"
#import "HHColors.h"
#import "HHColor.h"
#import "HHDBRoot.h"
#import "HHColorViewModel.h"
#import "ViewController.h"
#import "HHSettingViewController.h"

static const long ddLogLevel = DDLogLevelAll;
static const NSTimeInterval DefaultBlinkTimeInterval = 0.4f;

@interface HHMainManager()

@property (nonatomic, strong, readwrite) NSMutableArray *mainColors;
@property (nonatomic, strong, readwrite) HHColors *currentColors;
@property (nonatomic, strong, readwrite) HHColorViewModel *currentColorViewModel;
@property (nonatomic, assign, readwrite) NSInteger currentColorsIndex;
@property (nonatomic, strong, readwrite) HHColorViewModel *quickBlinkColorViewModel;
@property (nonatomic, assign, readwrite) NSTimeInterval blinkTimeInterval;

@end

@implementation HHMainManager
DEFINE_SINGLETON_FOR_CLASS(HHMainManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        _mainColors = [[NSMutableArray alloc] init];
        _blinkTimeInterval = DefaultBlinkTimeInterval;
    }
    return self;
}

- (void)createLogger {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60*60*24;  // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

- (void)addColors:(HHColors *)colors {
    if (![self.mainColors containsObject:colors]) {
        [self.mainColors addObject:colors];
        // DB
        [[HHDBRoot sharedHHDBRoot] addColors:colors];
    } else {
        DDLogError(@"addColors Failed");
    }
}

- (void)deleteColors:(HHColors *)colors {
    if (![self.mainColors containsObject:colors]) {
        DDLogError(@"deleteColors Failed");
    } else {
        [self.mainColors removeObject:colors];
        //DB
    }
}

- (void)updateColors:(HHColors *)colors
       withNewColors:(HHColors *)newColors{
    if (![self.mainColors containsObject:colors]) {
        DDLogError(@"updateColors Failed");
    } else {
        NSUInteger originalIndex = [self.mainColors indexOfObject:colors];
        [self.mainColors replaceObjectAtIndex:originalIndex
                                   withObject:newColors];
        //DB
    }
}

- (HHColors *)selectColorsWithColorsID:(NSString *)colorsID {
    for (HHColors *colors in self.mainColors) {
        if ([colorsID isEqualToString:colors.colorsID]) {
            return colors;
        }
    }
    return nil;
}

- (void)creatBaseData { // 第一次从plist中读取，以后每次启动从数据库中读取
    if ([[HHDBRoot sharedHHDBRoot] checkDatabaseIfNeedRawData]) {
        [self createRawDataWithPlist];
        [[HHDBRoot sharedHHDBRoot] createDatabaseWithMainColors:self.mainColors];
    } else {
        [[HHDBRoot sharedHHDBRoot] restoreDataFromeDataBase:^(NSMutableArray *mainColors) {
            self.mainColors = [mainColors mutableCopy];
            if (self.mainColors) {
                [self restoreUserSettings];
            } else {
                DDLogError(@"mainColors is nil");
            }
        }];
    }
    if (self.dataReadyCallBack) {
        self.dataReadyCallBack();
    }
}

- (void)createRawDataWithPlist {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cache_colors"
                                                          ofType:@"plist"];
    NSArray *cacheColorsDataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (int i = 0; i < cacheColorsDataArray.count; i++) {
        NSArray *colorsInfoArray = cacheColorsDataArray[i]; // 一条数据
        HHColors *hhcolors = [[HHColors alloc] initWithPlistInfo:colorsInfoArray];
        [self.mainColors addObject:hhcolors];
    }
    self.currentColors = [self.mainColors firstObject];
    DDLogDebug(@"cacheColorsData :%@", cacheColorsDataArray);
}



- (void)setCurrentViewModel:(HHColorViewModel *)currentColorViewModel {
    _currentColorViewModel = currentColorViewModel;
}

- (void)setCurrentColors:(HHColors *)currentColors {
    _currentColors = currentColors;
    _currentColorsIndex = [self.mainColors indexOfObject:currentColors];
    [self persistCurrentColors];
    [self updateQuickBlinkColor];
    if (self.mainColorsChangedCallBack) {
        self.mainColorsChangedCallBack();
    }
}

- (void)setCurrentColorsIndex:(NSInteger)currentColorsIndex {
    if (currentColorsIndex > self.mainColors.count - 1 || currentColorsIndex < 0) {
        DDLogDebug(@"currentColorsIndex error");
    }
    _currentColorsIndex = currentColorsIndex;
    _currentColors = self.mainColors[currentColorsIndex];
    [self persistCurrentColors];
    [self updateQuickBlinkColor];
    if (self.mainColorsChangedCallBack) {
        self.mainColorsChangedCallBack();
    }
}

- (void)setQuickBlinkColorViewModel:(HHColorViewModel *)quickBlinkColorViewModel {
    _quickBlinkColorViewModel = quickBlinkColorViewModel;
    [self persistQuickBlinkColor];
}

- (void)setBlinkTimeInterval:(NSTimeInterval)blinkTimeInterval {
    _blinkTimeInterval = blinkTimeInterval;
    [self persistBlinkTimeInterval];
}

#pragma mark - UpdateInfo
- (void)updateQuickBlinkColor { // when current colors changed
    if (self.quickBlinkColorViewModel) {
        for (HHColor *color in self.currentColors.colors) {
            if ([color.colorDesc isEqualToString:self.quickBlinkColorViewModel.colorDesc]) {
                self.quickBlinkColorViewModel = [[HHColorViewModel alloc] initWithColorString:color.colorString
                                                                                    colorDesc:color.colorDesc];
            }
        }
        [self persistQuickBlinkColor];
    }
}

#pragma mark - RestoreUserSettings
- (void)restoreUserSettings {
    [self restoreCurentColors];
    [self restoreQuickBlinkColor];
    [self restoreQuickTimeInterval];
}

- (void)restoreCurentColors {
    NSString *currentColorsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedColors"];
    if (currentColorsName) {
        for (HHColors *colors in self.mainColors) {
            if ([colors.colorsName isEqualToString:currentColorsName]) {
                self.currentColors = colors;
            }
        }
    } else {
        self.currentColors = [self.mainColors firstObject];
    }
}

- (void)restoreQuickBlinkColor {
    NSString *quickBlinkColorDesc = [[NSUserDefaults standardUserDefaults] objectForKey:@"QuickBlinkColor"];
    for (HHColor *color in self.currentColors.colors) {
        if ([color.colorDesc isEqualToString:quickBlinkColorDesc]) {
            self.quickBlinkColorViewModel = [[HHColorViewModel alloc] initWithColorString:color.colorString
                                                                                colorDesc:color.colorDesc];
        }
    }
}

- (void)restoreQuickTimeInterval {
    NSTimeInterval timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"BlinkTimeInterval"];
    self.blinkTimeInterval = timeInterval;
}

#pragma mark - PersistUserSettings
- (void)persistUserSettings {
    [self persistCurrentColors];
    [self persistQuickBlinkColor];
    [self persistBlinkTimeInterval];
}

- (void)persistCurrentColors {
    if ([self.currentColors.colorsName isValid]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.currentColors.colorsName
                                                  forKey:@"SelectedColors"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)persistQuickBlinkColor {
    if ([self.quickBlinkColorViewModel.colorDesc isValid]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.quickBlinkColorViewModel.colorDesc
                                                  forKey:@"QuickBlinkColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:@"QuickBlinkColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)persistBlinkTimeInterval {
    [[NSUserDefaults standardUserDefaults] setDouble:self.blinkTimeInterval
                                              forKey:@"BlinkTimeInterval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Actions
- (void)handleQuickBlinkActionWithVC:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ViewController class]]) {
        if (self.quickBlinkColorViewModel) {
            [self setCurrentViewModel:self.quickBlinkColorViewModel];
            [viewController performSegueWithIdentifier:@"MainToDetail" sender:self];
        }
    }
}

#pragma mark - Utils
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

- (UIViewController *)getPresentedViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end
