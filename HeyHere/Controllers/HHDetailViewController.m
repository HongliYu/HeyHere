//
//  HHDetailViewController.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHDetailViewController.h"
#import "HHMainManager.h"
#import "HHShareManager.h"
#import "HHColorViewModel.h"
#import "ViewController.h"
#import "HHShortMessageViewController.h"

static const long ddLogLevel = DDLogLevelAll;

@interface HHDetailViewController () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, assign) int blinkFlag;
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UIButton *shareSessionButton;
@property (strong, nonatomic) IBOutlet UIButton *shareTimelineButton;

@end

@implementation HHDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];

    self.blinkFlag = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[HHMainManager sharedHHMainManager].blinkTimeInterval
                                                  target:self
                                                selector:@selector(changeBackGroundColors)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

#pragma mark - BaseUI
- (void)configBaseUI {
    [_shareSessionButton.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:32.f]];
    [_shareSessionButton setTitle:@"\U0000e63b" forState:UIControlStateNormal];
    [_shareSessionButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [_shareTimelineButton.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:32.f]];
    [_shareTimelineButton setTitle:@"\U0000e8dd" forState:UIControlStateNormal];
    [_shareTimelineButton.titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)setCustomeBackgroundColor {
    NSString *colorString = [HHMainManager sharedHHMainManager].currentColorViewModel.colorString;
    if (colorString) {
        self.view.backgroundColor = [UIColor colorWithHexString:colorString];
    }
}

- (void)setNormalBackgroundColor {
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
}

- (void)changeBackGroundColors {
    if (self.blinkFlag == 0) {
        [self setCustomeBackgroundColor];
        self.blinkFlag++;
    } else {
        [self setNormalBackgroundColor];
        self.blinkFlag--;
    }
}

- (void)setNavBarColor:(UIColor *)navBarColor titleColor:(UIColor *)titleColor {
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_TEXT_COLOR}];
}

- (void)displaySMSComposerSheet {
    [self setNavBarColor:MAIN_BACKGROUND_COLOR titleColor:MAIN_TEXT_COLOR]; // 必须在初始化之前设置，否则无效
    HHShortMessageViewController *picker = [[HHShortMessageViewController alloc] init];
    [[picker navigationBar] setTintColor:MAIN_TEXT_COLOR]; // 取消按钮的颜色，必须在初始化完成以后设置
//    [[picker navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]; // 导航栏标题的颜色，可在初始化之前设置
    picker.messageComposeDelegate = self;
    picker.body = [NSString stringWithFormat:NSLocalizedString(@"Hey here! Blinking %@ light!", ""),
                   NSLocalizedString([HHMainManager sharedHHMainManager].currentColorViewModel.colorDesc, "")];
    [self presentViewController:picker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - Actions
- (IBAction)sendShortMessageAction:(id)sender {
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        } else {
            DDLogDebug(@"设备没有短信功能");
        }
    } else {
        DDLogDebug(@"iOS版本过低,iOS4.0以上才支持程序内发送短信");
    }
}

- (IBAction)shareSessionAction:(id)sender {
    [[HHShareManager sharedHHShareManager] shareSessionAction];
}

- (IBAction)shareTimelineAction:(id)sender {
    [[HHShareManager sharedHHShareManager] shareTimelineAction];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled: {
            DDLogDebug(@"Result: SMS sending canceled");
            break;
        }
        case MessageComposeResultSent: {
            DDLogDebug(@"Result: SMS sent");
            break;
        }
        case MessageComposeResultFailed: {
            DDLogDebug(@"短信发送失败");
            break;
        }
        default: {
            DDLogDebug(@"SMS not sent");
            break;
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[ViewController class]]) {
        [self.timer invalidate];
    }
}

@end
