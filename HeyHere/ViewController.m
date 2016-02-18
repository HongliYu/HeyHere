//
//  ViewController.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/22.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "HHMainTableViewCell.h"
#import "HHMainManager.h"
#import "HHColors.h"
#import "HHColorViewModel.h"
#import "HHDetailViewController.h"
#import "HHSettingViewController.h"

static const long ddLogLevel = DDLogLevelDebug;
static const NSInteger kCellNumber = 6;
NSString* const kCellIdentifier = @"HHMainTableViewCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseUI];
    [self bindActions];
    [[HHMainManager sharedHHMainManager] handleQuickBlinkActionWithVC:self]; // with sender
}

- (void)createBaseUI {
    // 导航栏透明，并去除下划线，标题为白色，系统边缘侧滑手势
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Transparent1x1.png"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    // statusbar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)createBaseData {
    [[HHMainManager sharedHHMainManager] creatBaseData];
}

- (void)bindActions {
    [[HHMainManager sharedHHMainManager] setMainColorsChangedCallBack:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[HHDetailViewController class]]) {
        DDLogDebug(@"going to HHDetailViewController");
//        HHDetailViewController *detailViewController = (HHDetailViewController *)[segue destinationViewController];
    }
    if ([[segue destinationViewController] isKindOfClass:[HHSettingViewController class]]) {
        DDLogDebug(@"going to HHSettingViewController");
//        HHSettingViewController *settingViewController = (HHSettingViewController *)[segue destinationViewController];
    }
}


#pragma mark - Actions
- (IBAction)settingAction:(id)sender {

}

- (IBAction)unwindSegueToMainViewController:(UIStoryboardSegue *)segue {
    if ([[segue sourceViewController] isKindOfClass:[HHDetailViewController class]]) {
        DDLogDebug(@"back from HHDetailViewController");
    }
    if ([[segue sourceViewController] isKindOfClass:[HHSettingViewController class]]) {
        DDLogDebug(@"back from HHSettingViewController");
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer { // 自定义导航按钮，开启边缘手势返回
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer
        && self.navigationController.viewControllers.count > 1) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HHColor *color = [HHMainManager sharedHHMainManager].currentColors.colors[indexPath.row];
    if (color) {
        HHColorViewModel *colorViewModel = [[HHColorViewModel alloc] initWithColorString:color.colorString
                                                                               colorDesc:color.colorDesc];
        [[HHMainManager sharedHHMainManager] setCurrentViewModel:colorViewModel];
    } else {
        DDLogDebug(@"didSelectRowAtIndexPath error");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT) / kCellNumber;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HHMainManager sharedHHMainManager].currentColors.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    HHColor *color = [[HHMainManager sharedHHMainManager].currentColors.colors objectAtIndex:indexPath.row];
    if (color) {
        HHColorViewModel *colorViewModel = [[HHColorViewModel alloc] initWithColorString:color.colorString
                                                                               colorDesc:color.colorDesc];
        [cell bindData:colorViewModel];
    } else {
        DDLogDebug(@"cellForRowAtIndexPath error");
    }
    return cell;
}

#pragma mark - Notification Received
- (void)willEnterForeground:(NSNotification *)notification {
    [[HHMainManager sharedHHMainManager] handleQuickBlinkActionWithVC:self]; // with sender
}

@end
