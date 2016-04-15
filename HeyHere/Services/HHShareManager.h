//
//  HHShareManager.h
//  HeyHere
//
//  Created by HongliYu on 16/4/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHShareManager : NSObject <WXApiDelegate>
DEFINE_SINGLETON_FOR_HEADER(HHShareManager);

@property (nonatomic, assign, readonly) enum WXScene scene;

- (void)setScene:(enum WXScene)scene;
- (void)sendColorContent;

@end
