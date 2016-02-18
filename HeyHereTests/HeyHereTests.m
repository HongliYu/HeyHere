//
//  HeyHereTests.m
//  HeyHereTests
//
//  Created by 虞鸿礼 on 16/2/17.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface HeyHereTests : XCTestCase

@property (nonatomic, strong) UIApplication *app;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) ViewController *viewController;

@end

@implementation HeyHereTests

- (void)setUp {
    [super setUp];
    _app = [UIApplication sharedApplication];
    _appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testServer {
    ;
}

- (void)testMainBundleCacheFile {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cache_colors"
                                                          ofType:@"plist"];
    NSArray *cacheColorsDataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    XCTAssertNotNil(cacheColorsDataArray, @"cache_colors.plist not in the main bundle");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
