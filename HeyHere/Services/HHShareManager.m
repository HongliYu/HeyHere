//
//  HHShareManager.m
//  HeyHere
//
//  Created by HongliYu on 16/4/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHShareManager.h"
#import "HHMainManager.h"
#import "HHColorViewModel.h"
#import "PSTAlertController.h"

/**
 *  WXSceneSession 会话
    WXSceneTimeline 朋友圈
    WXSceneFavorite 收藏
 */
@interface HHShareManager()

@property (nonatomic, assign, readwrite) enum WXScene scene;

@end

@implementation HHShareManager
DEFINE_SINGLETON_FOR_CLASS(HHShareManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        [WXApi registerApp:@"wx27e014969d3603a8" withDescription:NSLocalizedString(@"HeyHere", "")];
        _scene = WXSceneSession;
    }
    return self;
}

- (void)setScene:(enum WXScene)scene {
    _scene = scene;
}

- (void)sendColorContent {
    NSString *colorString = [HHMainManager sharedHHMainManager].currentColorViewModel.colorString;
    UIColor *currentColor = [UIColor colorWithHexString:colorString];
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation([HHImageUtils createImageWithColor:currentColor
                                                                                andSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]);
    
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    [mediaMessage setThumbImage:[HHImageUtils createImageWithColor:currentColor
                                                           andSize:CGSizeMake(50.f, 50.f)]];
    mediaMessage.mediaObject = imageObject;
    
    SendMessageToWXReq* shareRequest = [[SendMessageToWXReq alloc] init];
    shareRequest.bText = NO;
    shareRequest.message = mediaMessage;
    shareRequest.scene = _scene;
    
    [WXApi sendReq:shareRequest];
}

#pragma WXApiDelegate
- (void)onReq:(BaseReq *)req {
    // WeChat => HeyHere
    // TODO: need WeChat white list
    if([req isKindOfClass:[GetMessageFromWXReq class]]) {
        
    } else if([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        
    } else if([req isKindOfClass:[LaunchFromWXReq class]]) {
    
    }
}

- (void)onResp:(BaseResp *)resp {
    // WXApi sendReq call back
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess: { // 成功
                break;
            }
            case WXErrCodeCommon: { // 普通错误类型
                [self alertWithErrorMessage:NSLocalizedString(@"Common Error", "")];
                break;
            }
            case WXErrCodeUserCancel: { // 用户点击取消并返回
                break;
            }
            case WXErrCodeSentFail: { // 发送失败
                [self alertWithErrorMessage:NSLocalizedString(@"Request Error", "")];
                break;
            }
            case WXErrCodeAuthDeny: { // 授权失败
                [self alertWithErrorMessage:NSLocalizedString(@"Authorization Error", "")];
                break;
            }
            case WXErrCodeUnsupport: { // 微信不支持
                [self alertWithErrorMessage:NSLocalizedString(@"WeChat Not Support Error", "")];
                break;
            }
            default: {
                break;
            }
        }
    }
}

- (void)alertWithErrorMessage:(NSString *)message {
    PSTAlertController *alertController = [PSTAlertController alertWithTitle:NSLocalizedString(@"WeChat Share Failed", "")
                                                                     message:message];
    PSTAlertAction *alertAction = [PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", "")
                                                            style:PSTAlertActionStyleDestructive
                                                          handler:nil];
    [alertController addAction:alertAction];
    [alertController showWithSender:nil controller:nil animated:YES completion:NULL];
}

@end
