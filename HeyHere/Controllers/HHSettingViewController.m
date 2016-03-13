//
//  HHSettingViewController.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/22.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHSettingViewController.h"
#import "HHColorsView.h"
#import "HHMainManager.h"
#import "HHColors.h"
#import "HHColor.h"
#import "HHColorViewModel.h"
#import "SMVerticalSegmentedControl.h"
#import "HHQuickBlinkTableViewCell.h"
#import "ASValueTrackingSlider.h"

//static const long ddLogLevel = DDLogLevelDebug;
NSString* const kQuickBlinkCellIdentifier = @"HHQuickBlinkTableViewCell";
static const float kQuickBlinkTableViewHeight = 24.f;

@interface HHSettingViewController () <UITableViewDelegate,
UITableViewDataSource, ASValueTrackingSliderDataSource>

@property (strong, nonatomic) IBOutlet UIButton *quickBlinkButton;
@property (strong, nonatomic) IBOutlet HHColorsView *classicColorsView;
@property (strong, nonatomic) IBOutlet HHColorsView *darkColorsView;
@property (strong, nonatomic) IBOutlet HHColorsView *neonColorsView;
@property (strong, nonatomic) IBOutlet HHColorsView *pastelColorsView;
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *timeIntervalSlider;
@property (strong, nonatomic) IBOutlet SMVerticalSegmentedControl *colorpacksVerticalSegment;
@property (strong, nonatomic) IBOutlet UIButton *donateButton;
@property (strong, nonatomic) UITableView *quickBlinkTableView;

@end

@implementation HHSettingViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

#pragma mark - Life Cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self bindActions];
}

#pragma mark - BaseUI
- (void)configBaseUI {
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:[HHMainManager sharedHHMainManager].mainColors.count];
    
    // HHColorsView
    for (int i = 0; i < [HHMainManager sharedHHMainManager].mainColors.count; i++) {
        HHColors *colors = (HHColors *)[HHMainManager sharedHHMainManager].mainColors[i];
        [titles addObject:colors.colorsName];
        if ([colors.colorsName isEqualToString:@"Classic"]) { // TODO:think twice
            [self.classicColorsView bindData:colors];
        }
        if ([colors.colorsName isEqualToString:@"Dark"]) {
            [self.darkColorsView bindData:colors];
        }
        if ([colors.colorsName isEqualToString:@"Neon"]) {
            [self.neonColorsView bindData:colors];
        }
        if ([colors.colorsName isEqualToString:@"Pastel"]) {
            [self.pastelColorsView bindData:colors];
        }
    }
    
    // colorpacksVerticalSegment
    [self.colorpacksVerticalSegment setSectionTitles:titles];
    [self.colorpacksVerticalSegment setSelectedSegmentIndex:[HHMainManager sharedHHMainManager].currentColorsIndex];
    self.colorpacksVerticalSegment.selectionStyle = SMVerticalSegmentedControlSelectionStyleTextHeightStrip;
    self.colorpacksVerticalSegment.textAlignment = SMVerticalSegmentedControlTextAlignmentLeft;
    self.colorpacksVerticalSegment.selectionIndicatorThickness = 4;
    [self.colorpacksVerticalSegment setTextFont:[UIFont systemFontOfSize:18.f]];
    [self.colorpacksVerticalSegment setTextColor:MAIN_TEXT_COLOR];
    [self.colorpacksVerticalSegment setSelectedTextColor:[UIColor greenColor]];
    
    // quickblinkbutton
    [self updateQuickBlinkButton];
    
    // timeIntervalSlider
    [self.timeIntervalSlider setThumbImage:[HHImageUtils generateHandleImageWithColor:[UIColor redColor]]
                                  forState:UIControlStateNormal];
    self.timeIntervalSlider.dataSource = self;
    self.timeIntervalSlider.value = [HHMainManager sharedHHMainManager].blinkTimeInterval;

}

- (void)updateQuickBlinkButton {
    HHColorViewModel *quickBlinkColorViewModel = [HHMainManager sharedHHMainManager].quickBlinkColorViewModel;
    if (quickBlinkColorViewModel) {
        [self.quickBlinkButton setTitle:NSLocalizedString(quickBlinkColorViewModel.colorDesc, @"")
                               forState:UIControlStateNormal];
        [self.quickBlinkButton setTitleColor:[UIColor colorWithHexString:quickBlinkColorViewModel.colorString]
                                    forState:UIControlStateNormal];
    } else {
        [self.quickBlinkButton setTitle:NSLocalizedString(@"off", @"")
                               forState:UIControlStateNormal];
        [self.quickBlinkButton setTitleColor:MAIN_TEXT_COLOR
                                    forState:UIControlStateNormal];
    }
}

- (void)createQuickBlinkTableView {
    if (!self.quickBlinkTableView) {
        self.quickBlinkTableView = [[UITableView alloc] init];
        self.quickBlinkTableView.delegate = self;
        self.quickBlinkTableView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([HHQuickBlinkTableViewCell class])
                                    bundle:nil];
        [self.quickBlinkTableView registerNib:nib
                       forCellReuseIdentifier:kQuickBlinkCellIdentifier];
        self.quickBlinkTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.quickBlinkTableView.bounces = NO;
        self.quickBlinkTableView.layer.borderWidth = 2.f;
        self.quickBlinkTableView.layer.borderColor = MAIN_TEXT_COLOR.CGColor;
    }
    
    if ([self.quickBlinkTableView superview]) {
        [self removeQuickBlinkTableView];
    } else {
        [self.view addSubview:self.quickBlinkTableView];
        __weak typeof(self) weakSelf = self;
        [self.quickBlinkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.top.equalTo(strongSelf.quickBlinkButton.mas_bottom).offset(-2);
            make.left.equalTo(strongSelf.quickBlinkButton.mas_left);
            make.width.equalTo(strongSelf.quickBlinkButton.mas_width);
            make.height.equalTo(@(kQuickBlinkTableViewHeight * ([HHMainManager sharedHHMainManager].currentColors.colors.count + 1)));
        }];
    }
}

- (void)removeQuickBlinkTableView {
    if ([self.quickBlinkTableView superview]) {
        [self.quickBlinkTableView removeFromSuperview];
    }
}

#pragma mark - Actions
- (void)bindActions {
    // colorpacksVerticalSegment
    __weak typeof(self) weakSelf = self;
    [self.colorpacksVerticalSegment setIndexChangeBlock:^(NSInteger index) {
        __strong typeof(self) strongSelf = weakSelf;
        [[HHMainManager sharedHHMainManager] setCurrentColorsIndex:index];
        [strongSelf updateQuickBlinkButton];
        [strongSelf.quickBlinkTableView reloadData];
    }];
}

- (IBAction)tapViewAction:(id)sender { // TODO:手势冲突的处理，storyboard中tap的设置
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
       UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer *)sender;
        if (tapGesture.state == UIGestureRecognizerStateEnded) {
            [self removeQuickBlinkTableView];
        }
    }
}

- (IBAction)donateButtonAction:(id)sender {
    NSURL *targetURL = [NSURL URLWithString:@"https://qr.alipay.com/apeez0tpttrt2yove2"];
    [[UIApplication sharedApplication] openURL:targetURL];
}

- (IBAction)quickBlinkButtonAction:(id)sender {
    [self createQuickBlinkTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HHMainManager sharedHHMainManager].currentColors.colors.count + 1; // 1 for off
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHQuickBlinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQuickBlinkCellIdentifier];
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"off", @"");
    } else {
        HHColor *color = [HHMainManager sharedHHMainManager].currentColors.colors[indexPath.row - 1];
        if (color) {
            [cell bindData:color];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [[HHMainManager sharedHHMainManager] setQuickBlinkColorViewModel:nil];
    } else {
        HHColor *selectedQuickBlinkColor = [HHMainManager sharedHHMainManager].currentColors.colors[indexPath.row - 1];
        HHColorViewModel *quickBlinkColorViewModel = [[HHColorViewModel alloc] initWithColorString:selectedQuickBlinkColor.colorString
                                                                                         colorDesc:selectedQuickBlinkColor.colorDesc];
        [[HHMainManager sharedHHMainManager] setQuickBlinkColorViewModel:quickBlinkColorViewModel];
    }
    [self updateQuickBlinkButton];
    [self removeQuickBlinkTableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kQuickBlinkTableViewHeight;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - ASValueTrackingSliderDataSource
- (NSString *)slider:(ASValueTrackingSlider *)slider
      stringForValue:(float)value {
    [[HHMainManager sharedHHMainManager] setBlinkTimeInterval:value];
    NSString *resaultString = [NSString stringWithFormat:@"%f",value];
    return resaultString;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Notification Received
- (void)willEnterForeground:(NSNotification *)notification {
    ;
}

@end
